import 'package:flutter/material.dart';
<<<<<<< Updated upstream
import 'package:flutter/services.dart';
import 'package:get/get.dart';
=======
>>>>>>> Stashed changes
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

import '../controller/main_controller.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final TextEditingController fromController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

<<<<<<< Updated upstream
  bool isPWD = false; // Variable to check if user is eligible for PWD discount
  final String googleApiKey =
      "AIzaSyCyLNeZ9Flp2v7yM0AccRqKkRwd-LlPaKA"; // Replace with your actual API key
  double estimatedDistance = 0.0; // in kilometers
=======
  final String googleApiKey = "AIzaSyDnXprchK9H4LXeUaEHr4yUVKqJGFtW5iY";
  double estimatedDistance = 0.0;
>>>>>>> Stashed changes
  double estimatedPrice = 0.0;
  bool isBookingConfirmed = false;
  LatLng? fromLocation;
  LatLng? toLocation;

  late GoogleMapController mapController;

  // Method to get current location
  Future<void> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        fromLocation = LatLng(position.latitude, position.longitude);
        fromController.text = "Lat: ${position.latitude}, Long: ${position.longitude}";
      });
      mapController.animateCamera(CameraUpdate.newLatLng(fromLocation!));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error getting location: $e")),
      );
    }
  }

  // Method to calculate distance and price
  Future<void> calculateDistanceAndPrice() async {
    if (fromController.text.isEmpty || destinationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter both locations")),
      );
      return;
    }

    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins=${fromController.text}&destinations=${destinationController.text}&key=$googleApiKey");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final distanceMeters = data['rows'][0]['elements'][0]['distance']['value'];
        final distanceKm = distanceMeters / 1000; // Convert to kilometers
        final baseRate = 50.0;
        final ratePerKm = 10.0;

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

  void confirmBooking() {
    setState(() {
      isBookingConfirmed = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Booking Confirmed! Driver is on the way.")),
    );
  }

  void cancelBooking() {
    setState(() {
      isBookingConfirmed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isBookingConfirmed) ...[
                  // Input Fields
                  buildInputFields(),
                  const SizedBox(height: 10),

                  // Distance and Price
                  if (estimatedDistance > 0) buildDistanceAndPriceDisplay(),

                  const SizedBox(height: 20),

                  // Confirm Button
                  if (estimatedPrice > 0)
                    ElevatedButton(
                      onPressed: confirmBooking,
                      child: const Text("Confirm Booking"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                ] else ...[
                  // Booking Confirmation Details
                  Text(
                    "Driver is on the way!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text("From: ${fromController.text}"),
                  Text("To: ${destinationController.text}"),
                  Text("Price: PHP ${estimatedPrice.toStringAsFixed(2)}"),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: cancelBooking,
                    child: const Text("Cancel Booking"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],

                // Map Display
                Container(
                  height: 300,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: fromLocation ?? LatLng(0.0, 0.0),
                      zoom: 14.0,
                    ),
                    markers: {
                      if (fromLocation != null)
                        Marker(markerId: MarkerId("from"), position: fromLocation!),
                      if (toLocation != null)
                        Marker(markerId: MarkerId("to"), position: toLocation!),
                    },
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                    myLocationEnabled: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column buildInputFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Current Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: fromController,
          decoration: InputDecoration(
            hintText: "Enter your current location",
            prefixIcon: const Icon(Icons.location_on),
            suffixIcon: IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: getCurrentLocation,
            ),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        const Text("Destination", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        TextField(
          controller: destinationController,
          decoration: InputDecoration(
            hintText: "Enter your destination",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: calculateDistanceAndPrice,
          child: const Text("Calculate Distance & Price"),
        ),
      ],
    );
  }

  Column buildDistanceAndPriceDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Estimated Distance: ${estimatedDistance.toStringAsFixed(2)} km"),
        Text("Estimated Price: PHP ${estimatedPrice.toStringAsFixed(2)}"),
      ],
    );
  }
}
