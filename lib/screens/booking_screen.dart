import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(BookingScreen());
}

class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GoogleMapController mapController;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // Coordinates of San Francisco
    zoom: 12,
  );

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  void clearField(TextEditingController controller) {
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,  // Background color for the scaffold
      appBar: AppBar(
        backgroundColor: Colors.tealAccent.shade400, // tealAccent400 background
        title: const Text(
          'Transportation Booking',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(  // Using Stack to overlay widgets
        children: [
          // Google Map (background layer)
          Positioned.fill(
            child: GoogleMap(
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
          ),
          
          // Image (background layer)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300,  // Image height
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                image: DecorationImage(
                  image: AssetImage('lib/assets/images/car.png'),  // Your background image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // From and To Fields
          Positioned(
            top: 320,  // Positioned below the image
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Book Your Ride",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text(
                  "Enter your journey details",
                  style: TextStyle(fontSize: 16, color: Colors.white60),
                ),
                const SizedBox(height: 20),

                // From and To Fields aligned horizontally
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // From TextField
                    Expanded(
                      child: TextField(
                        controller: fromController,
                        decoration: InputDecoration(
                          labelText: 'From',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.location_on, color: Colors.tealAccent[700]),
                          suffixIcon: fromController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.white),
                                  onPressed: () => clearField(fromController),
                                )
                              : null,
                        ),
                        style: TextStyle(color: Colors.white), // White text color
                      ),
                    ),
                    const SizedBox(width: 10),
                    // To TextField
                    Expanded(
                      child: TextField(
                        controller: toController,
                        decoration: InputDecoration(
                          labelText: 'To',
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.tealAccent.shade100,
                          prefixIcon: Icon(Icons.location_on, color: Colors.white),
                          suffixIcon: toController.text.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.white),
                                  onPressed: () => clearField(toController),
                                )
                              : null,
                        ),
                        style: TextStyle(color: Colors.white), // White text color
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Book Ride Button aligned next to the "To" field
                ElevatedButton(
                  onPressed: () {
                    String from = fromController.text;
                    String to = toController.text;

                    if (from.isNotEmpty && to.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Ride booked from $from to $to"),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill in both fields")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent.shade400, // tealAccent400 background
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Book Ride',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
        selectedItemColor: Colors.tealAccent.shade400,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
      ),
    );
  }
}
