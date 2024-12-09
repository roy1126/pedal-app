import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedal_application/model/booking.model.dart';
import 'package:pedal_application/screens/booking_screen.dart';
import 'package:http/http.dart' as http;
import '../controller/main_controller.dart';
import 'package:intl/intl.dart'; // For date formatting

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final mainController = Get.put(MainController());
  bool _isLoading = false;
  late List<Booking> _currentBookings = [];
  List<Booking> _archivedBookings = [];

  // Refresh bookings when user pulls down
  Future<void> _refreshBookings() async {
    await _getCurrentBookings(); // This will refresh the bookings
    await _getArchivedBookings(); // This will refresh the bookings
  }

  // Function to fetch current bookings
  Future<void> _getCurrentBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = mainController.getCurrentUser().id;
      final response = await http.post(
        Uri.parse(
            'https://nameless-waters-42836-7709a51fcf3d.herokuapp.com/api/bookings/current'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseJson = json.decode(response.body);
        setState(() {
          _currentBookings = responseJson
              .map((bookingJson) => Booking.fromJson(bookingJson))
              .toList();
        });
      } else {
        Get.snackbar('Error', 'Network Error.',
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

  // Function to fetch archived bookings
  Future<void> _getArchivedBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = mainController.getCurrentUser().id;
      final response = await http.post(
        Uri.parse(
            'https://nameless-waters-42836-7709a51fcf3d.herokuapp.com/api/bookings/archived'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        List<dynamic> responseJson = json.decode(response.body);
        setState(() {
          _archivedBookings = responseJson
              .map((bookingJson) => Booking.fromJson(bookingJson))
              .toList();
        });
      } else {
        Get.snackbar('Error', 'Network Error.',
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

  Future<void> _cancelBooking(String bookId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final payload = {
        "bookingId": bookId,
      };
      // Use GET request and pass the driverId as a query parameter
      final response = await http.post(
        Uri.parse(
            'https://nameless-waters-42836-7709a51fcf3d.herokuapp.com/api/booking/user/cancel'),
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

  @override
  void initState() {
    super.initState();
    _refreshBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Screen"),
          backgroundColor: Colors.blue,
        ),
        body: RefreshIndicator(
          onRefresh: _refreshBookings, // This triggers the refresh logic
          child: SingleChildScrollView(
            child: Center(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("In-Progress",
                              style: Theme.of(context).textTheme.headlineLarge),
                          _currentBookings.isEmpty
                              ? const Center(
                                  child: Text("No bookings for you today!"))
                              : ListView.builder(
                                  itemCount: _currentBookings.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var booking = _currentBookings[index];
                                    return AnimatedContainer(
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeInOut,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                            color: Colors.blue, width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: BookingCard(
                                        onCancel: () {
                                          _showConfirmationDialog(
                                              context, booking.id!);
                                        },
                                        bookingId: booking.id!,
                                        customerName:
                                            "${mainController.getCurrentUser().firstName} ${mainController.getCurrentUser().lastName}",
                                        date: booking.updatedAt.toString(),
                                        status: booking.bookingStatus,
                                        startLocation: booking.startLocation,
                                        destination: booking.destination,
                                        driverId: booking.driverId ??
                                            "Looking for a driver...",
                                      ),
                                    );
                                  },
                                ),
                          const SizedBox(height: 20),
                          Text("History",
                              style: Theme.of(context).textTheme.headlineLarge),
                          _archivedBookings.isEmpty
                              ? const Center(
                                  child: Text("No History for you today!"))
                              : ListView.builder(
                                  itemCount: _archivedBookings.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    var booking = _archivedBookings[index];
                                    return BookingCard(
                                      bookingId: booking.id!,
                                      customerName:
                                          "${mainController.getCurrentUser().firstName} ${mainController.getCurrentUser().lastName}",
                                      date: booking.updatedAt.toString(),
                                      status: booking.bookingStatus,
                                      startLocation: booking.startLocation,
                                      destination: booking.destination,
                                      driverId: booking.driverId ??
                                          "Looking for a driver...",
                                    );
                                  },
                                ),
                          const SizedBox(height: 20),
                          Center(
                            child: FloatingActionButton.extended(
                              backgroundColor: Colors.green,
                              onPressed: () {
                                Get.to(() => BookingScreen());
                              },
                              icon: const Icon(Icons.add),
                              label: const Text("Book Now",
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ));
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, String bookingId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Cancel"),
          content: Text("Are you sure you want to cancel this booking?"),
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
                _cancelBooking(bookingId); // Perform cancel action
              },
            ),
          ],
        );
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  final String bookingId;
  final String customerName;
  final String date;
  final String status;
  final String startLocation;
  final String destination;
  final String driverId;
  final VoidCallback? onCancel;

  const BookingCard(
      {super.key,
      required this.bookingId,
      required this.customerName,
      required this.date,
      required this.status,
      required this.startLocation,
      required this.destination,
      required this.driverId,
      this.onCancel});

  // Function to format the date into a readable format
  String _formatDate(String dateString) {
    final DateTime date = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('MMMM d, yyyy, h:mm a');
    return formatter.format(date); // Example: "December 9, 2024, 2:30 PM"
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reference Number: ${bookingId.substring(bookingId.length - 5)}', // Show only first 5 characters of booking ID
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Customer: $customerName',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Date: ${_formatDate(date)}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Start Location: $startLocation',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Destination: $destination',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text('Driver ID: $driverId',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text('Status: $status',
                style: TextStyle(fontSize: 14, color: Colors.green)),
            if (onCancel != null) const SizedBox(height: 15),
            if (onCancel != null)
              ElevatedButton(
                onPressed: onCancel,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Cancel"),
              )
          ],
        ),
      ),
    );
  }
}
