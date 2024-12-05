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
  bool isPwd = false;
  String selectedPwdType = '';

  final List<String> pwdTypes = [
    "Vision Impairment",
    "Hearing Impairment",
    "Mental Illness",
    "Intellectual Disability",
    "Learning Disability",
    "Autism Spectrum Disorder",
    "Cerebral Palsy",
    "Orthopedic Disability",
    "Psychosocial Disability",
    "Blindness",
    "Disability Caused by Chronic Illness",
    "Leprosy Cured",
    "Locomotor Disability",
    "Muscular Dystrophy",
    "Physical Disability",
    "Acquired Brain Injury",
    "Attention Deficit Hyperactivity Disorder",
    "Chronic Illness",
    "Dwarfism",
    "Hemophilia",
    "Multiple Disabilities",
    "Sickle Cell Disease",
    "Speech Impairment",
    "Thalassemia",
  ];
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Ensure a mobile-friendly UI
    double contentWidth = screenWidth < 400 ? screenWidth : 400;
    double contentHeight = screenHeight < 600 ? screenHeight : 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: contentWidth,
            height: contentHeight,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Booking List Section
                mainController.getAllBookings().isEmpty
                    ? Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 100,
                                color: Colors.grey[300],
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                "No bookings for you today!",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: mainController.getAllBookings().length,
                          itemBuilder: (context, index) {
                            var booking =
                                mainController.getAllBookings()[index];
                            return BookingCard(
                              bookingId: booking.bookingId,
                              customerName: booking.customerId,
                              date: booking.dateCreated.toString(),
                              status: booking.bookingStatus,
                            );
                          },
                        ),
                      ),
                const SizedBox(height: 20),

                // PWD Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Are you a PWD?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: isPwd,
                              onChanged: (value) {
                                setState(() {
                                  isPwd = value ?? false;
                                  if (!isPwd) {
                                    selectedPwdType = '';
                                  }
                                });
                              },
                            ),
                            const Text("Yes"),
                          ],
                        ),
                        Row(
                          children: [
                            Radio<bool>(
                              value: false,
                              groupValue: isPwd,
                              onChanged: (value) {
                                setState(() {
                                  isPwd = value ?? false;
                                  if (!isPwd) {
                                    selectedPwdType = '';
                                  }
                                });
                              },
                            ),
                            const Text("No"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                if (isPwd)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Select PWD Type",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      value: selectedPwdType.isEmpty ? null : selectedPwdType,
                      onChanged: (value) {
                        setState(() {
                          selectedPwdType = value!;
                        });
                      },
                      items: pwdTypes.map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                    ),
                  ),

                const SizedBox(height: 20),

                // Book Now Button
                Center(
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.green,
                    onPressed: () {
                      Get.to(() => BookingScreen());
                    },
                    icon: const Icon(Icons.add),
                    label: const Text(
                      "Book Now",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
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
