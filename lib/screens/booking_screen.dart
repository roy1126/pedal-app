import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  bool isPWD = false; // Variable to check if user is eligible for PWD discount
  final String googleApiKey = "AIzaSyCyLNeZ9Flp2v7yM0AccRqKkRwd-LlPaKA"; // Replace with your actual API key
  double estimatedDistance = 0.0; // in kilometers
  double estimatedPrice = 0.0;

  @override
  void dispose() {
    // Dispose of the controllers to avoid memory leaks
    fromController.dispose();
    destinationController.dispose();
    discountController.dispose();
    super.dispose();
  }

  Future<void> calculateDistanceAndPrice() async {
    if (fromController.text.isEmpty || destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both locations")),
      );
      return;
    }

    final from = Uri.encodeFull(fromController.text);
    final destination = Uri.encodeFull(destinationController.text);

    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$from&destinations=$destination&key=$googleApiKey");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final distanceMeters = data['rows'][0]['elements'][0]['distance']['value'];
        final distanceKm = distanceMeters / 1000; // Convert meters to kilometers
        final baseRate = 50.0; // Base fare
        final ratePerKm = 10.0; // Cost per km

        setState(() {
          estimatedDistance = distanceKm;
          estimatedPrice = baseRate + (ratePerKm * distanceKm);
        });
      } else {
        throw Exception("Failed to fetch distance");
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching distance: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Banner with Bus Logo
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          'lib/assets/images/car.png',
                          width: 350,
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 16,
                      child: Row(
                        children: [
                          Image.asset(
                            'lib/assets/logo/logo.png',
                            width: 40,
                            height: 40,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Your City, Your Way",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Input Fields and Buttons
                buildInputFields(),
                const SizedBox(height: 10),

                // Distance and Price Display
                if (estimatedDistance > 0) buildDistanceAndPriceDisplay(),

                const SizedBox(height: 20),

                // Map Placeholder
                Container(
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(0.0, 0.0), // Replace with the current location
                      zoom: 14.0,
                    ),
                    markers: {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Column buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Current Location",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: fromController,
          decoration: InputDecoration(
            labelText: "Where are you now?",
            hintText: "Current Location",
            prefixIcon: const Icon(Icons.location_on),
            suffixIcon: IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: () {
                // Get the current location logic here
                // Update the fromController with the current location
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "City Destination",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: destinationController,
          decoration: InputDecoration(
            labelText: "Where to?",
            hintText: "ex: Manila, Makati etc.",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: calculateDistanceAndPrice,
          child: const Text("Calculate Distance & Price"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
            backgroundColor: Colors.blue,
          ),
        ),
      ],
    );
  }

  Column buildDistanceAndPriceDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Estimated Distance: ${estimatedDistance.toStringAsFixed(2)} km",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          "Estimated Price: PHP ${estimatedPrice.toStringAsFixed(2)}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.help), label: "Help"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "Activity"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
    );
  }
}
