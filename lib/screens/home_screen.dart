import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedal_application/screens/booking_screen.dart';

import '../controller/main_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final mainController = Get.put(MainController());
  Widget build(BuildContext context) {
    double mobileWidth = 400; // Maximum width for mobile
    double mobileHeight = 600; // Maximum height for mobile

    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Screen"),
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
            child: Container(
          width: 400,
          height: 600,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 400,
                height: 500,
                child: mainController.getAllBookings().isEmpty
                    ? Text("No booking for you today!")
                    : ListView.builder(
                        itemCount: mainController.getAllBookings().length,
                        itemBuilder: (context, index) {
                          var booking = mainController.getAllBookings()[index];
                          return BookingCard(
                            bookingId: booking.bookingId!,
                            customerName: booking.customerId!,
                            date: booking.dateCreated.toString()!,
                            status: booking.bookingStatus!,
                          );
                        },
                      ),
              ),
              Container(
                width: 200,
                height: 50,
                child: FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {
                    Get.to(() => BookingScreen());
                  },
                  child: Text(
                    "Book Now",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        )));
  }
}

class BookingCard extends StatelessWidget {
  final String bookingId;
  final String customerName;
  final String date;
  final String status;

  BookingCard({
    required this.bookingId,
    required this.customerName,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking ID: $bookingId',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Customer: $customerName',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Date: $date',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 8),
            Text(
              'Status: $status',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
