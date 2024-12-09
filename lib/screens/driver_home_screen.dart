import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedal_application/model/booking.model.dart';
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
  List<Booking> _acceptedBookings = [];
  List<Booking> _availableBookings = [];

  @override
  void initState() {
    super.initState();
    _refreshBookings();
  }

  // Fetch in-progress bookings
  Future<void> _getAcceptedBookings() async {
    setState(() {
      _isLoading = true;
      _acceptedBookings = [];
    });

    try {
      final payload = {
        "driverId": mainController.getCurrentUser().id,
      };
      // Use GET request and pass the driverId as a query parameter
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/bookings/accepted'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseJson = json.decode(response.body);
        if (responseJson.isNotEmpty) {
          setState(() {
            // Map JSON to Booking model
            _acceptedBookings = responseJson
                .map((bookingJson) => Booking.fromJson(bookingJson))
                .toList();
          });
        }
      } else {
        Get.snackbar('Error',
            'Network Error in getting accepted bookings. Please try again.',
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

  // Fetch in-progress bookings
  Future<void> _getAvailableBookings() async {
    setState(() {
      _isLoading = true;
      _availableBookings = [];
    });

    try {
      // Use GET request and pass the driverId as a query parameter
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/bookings/available'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Decode response to JSON
        List<dynamic> responseJson = json.decode(response.body);
        if (responseJson.isNotEmpty) {
          setState(() {
            // Map JSON to Booking model
            _availableBookings = responseJson
                .map((bookingJson) => Booking.fromJson(bookingJson))
                .toList();
          });
        }
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

  // Refresh bookings when user pulls down
  Future<void> _refreshBookings() async {
    await _getAcceptedBookings(); // This will refresh the bookings
    await _getAvailableBookings(); // This will refresh the bookings
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
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/booking/driver/accept'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Booking Accepted!');
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
      _refreshBookings();
    }
  }

  Future<void> _cancelBooking(String bookId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final payload = {
        "bookingId": bookId,
        "driverId": mainController.getCurrentUser().id,
      };
      // Use GET request and pass the driverId as a query parameter
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/booking/driver/cancel'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Booking successfully cancelled!');
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
      _refreshBookings();
    }
  }

  Future<void> _finishBooking(String bookId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final payload = {
        "bookingId": bookId,
        "driverId": mainController.getCurrentUser().id,
      };
      // Use GET request and pass the driverId as a query parameter
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/booking/driver/finish'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Book has been finished!');
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
      _refreshBookings();
    }
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, String action, String bookingId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(action == "Accept"
              ? "Confirm Accept"
              : action == "Finish"
                  ? "Confirm Finish"
                  : "Confirm Cancel"),
          content: Text(action == "Accept"
              ? "Are you sure you want to accept this booking?"
              : action == "Finish"
                  ? "Are you sure you want to finish this booking?"
                  : "Are you sure you want to cancel this booking?"),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                if (action == "Accept") {
                  _acceptBooking(bookingId); // Perform accept action
                } else if (action == "Finish") {
                  _finishBooking(bookingId);
                } else {
                  _cancelBooking(bookingId); // Perform cancel action
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Driver Home Screen"),
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshBookings, // This triggers the refresh logic
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Accepted Bookings",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _acceptedBookings.isEmpty
                          ? const Center(
                              child:
                                  Text("No avaiable bookings for you today!"))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _acceptedBookings.length,
                              itemBuilder: (context, index) {
                                var booking = _acceptedBookings[index];
                                return BookingCard(
                                  booking: booking,
                                  onFinish: () {
                                    _showConfirmationDialog(
                                        context, "Finish", booking.id!);
                                  },
                                  onCancel: () {
                                    // Handle booking accept logic here
                                    _showConfirmationDialog(
                                        context, "Cancel", booking.id!);
                                  },
                                );
                              },
                            ),
                  const Text(
                    "Available Bookings",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _availableBookings.isEmpty
                          ? const Center(
                              child:
                                  Text("No avaiable bookings for you today!"))
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: _availableBookings.length,
                              itemBuilder: (context, index) {
                                var booking = _availableBookings[index];
                                return BookingCard(
                                  isAccept: true,
                                  booking: booking,
                                  onAccept: () {
                                    // Handle booking accept logic here
                                    _showConfirmationDialog(
                                        context, "Accept", booking.id!);
                                  },
                                );
                              },
                            ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final bool isAccept;
  final Booking booking;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final VoidCallback? onFinish;

  const BookingCard(
      {super.key,
      this.isAccept = false,
      required this.booking,
      this.onAccept,
      this.onCancel,
      this.onFinish});

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
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'To: ${booking.destination}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            Text(
              'ETA: ${DateTime.parse(booking.eta.toString())}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Price: \$${booking.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            isAccept
                ? ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Accept"),
                  )
                : Row(
                    children: [
                      ElevatedButton(
                        onPressed: onFinish,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.greenAccent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Finish"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: onCancel,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Cancel"),
                      )
                    ],
                  )
          ],
        ),
      ),
    );
  }
}
