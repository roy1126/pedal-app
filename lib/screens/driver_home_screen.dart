import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedal_application/model/booking.model.dart';
import 'package:pedal_application/screens/booking_screen.dart';
import 'package:http/http.dart' as http;
import '../controller/main_controller.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final mainController = Get.put(MainController());
  bool _isLoading = false;
  List<Booking> _inProgressBookings = [];

  @override
  void initState() {
    super.initState();
    _getInProgressBookings();
  }

  // Fetch in-progress bookings
  Future<void> _getInProgressBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Use GET request and pass the driverId as a query parameter
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/bookings/in-progress'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Decode response to JSON
        List<dynamic> responseJson = json.decode(response.body);
        setState(() {
          // Map JSON to Booking model
          _inProgressBookings = responseJson
              .map((bookingJson) => Booking.fromJson(bookingJson))
              .toList();
        });
      } else {
        Get.snackbar('Error', 'Network Error. Please try again.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _acceptBooking(String bookId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final payload = {
        "bookingId": bookId,
        "driverId": mainController.getCurrentUser().id,
      };
      // Use GET request and pass the driverId as a query parameter
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/booking/accept'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        // Decode response to JSON
        List<dynamic> responseJson = json.decode(response.body);
        setState(() {
          // Map JSON to Booking model
          _inProgressBookings = responseJson
              .map((bookingJson) => Booking.fromJson(bookingJson))
              .toList();
        });
      } else {
        Get.snackbar('Error', 'Network Error. Please try again.',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Home Screen"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "In-Progress Bookings",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      _inProgressBookings.isEmpty
                          ? const Center(
                              child: Text("No bookings for you today!"))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _inProgressBookings.length,
                              itemBuilder: (context, index) {
                                var booking = _inProgressBookings[index];
                                return BookingCard(
                                  booking: booking,
                                  onAccept: () {
                                    // Handle booking accept logic here
                                    print('Booking Accepted: ${booking.id}');
                                  },
                                );
                              },
                            ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onAccept;

  const BookingCard({super.key, required this.booking, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'From: ${booking.startLocation}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'To: ${booking.destination}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Price: \$${booking.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Accept"),
            ),
          ],
        ),
      ),
    );
  }
}
