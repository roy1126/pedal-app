import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pedal_application/controller/main_controller.dart';
import 'package:pedal_application/model/vehicle.details.model.dart';
import 'package:pedal_application/screens/vehicle_documents_screen.dart';

class VehicleDetailsScreen extends StatefulWidget {
  const VehicleDetailsScreen({super.key});

  @override
  _VehicleDetailsScreenState createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final mainController = Get.put(MainController());

  final TextEditingController vehicleModelController = TextEditingController();
  final TextEditingController yearOfModelController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();

  bool? rampAvailability; // For the dropdown menu

  final TextEditingController wheelchairCapacityController =
      TextEditingController();
  final TextEditingController accessibilityFeaturesController =
      TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose of the controller when it's no longer needed
    wheelchairCapacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> vehicleDetailHandler() async {
      final url = Uri.parse(
          'http://localhost:3000/api/vehicle/details'); // Replace with your API URL

      final vehicleDetails = VehicleDetails(
          model: vehicleModelController.text,
          yearModel: int.tryParse(yearOfModelController.text) ?? 0,
          licenseNumber: licensePlateController.text,
          rampOrLiftAvailability: rampAvailability ?? false,
          wheelCapacity: int.tryParse(wheelchairCapacityController.text) ?? 0,
          otherAccessibilityFeat: accessibilityFeaturesController.text);

      final payload = {
        "userId": mainController.getCurrentUser().id,
        "vehicleDetails": vehicleDetails.toJson()
      };

      print(payload);
      // Send POST request
      try {
        final response = await http.put(
          url,
          headers: {
            'Content-Type':
                'application/json', // Required for sending JSON data
          },
          body: jsonEncode(payload), // Convert requestData to JSON
        );

        // Check the response status
        if (response.statusCode == 200) {
          setState(() {
            _isLoading = true;
          });

          Get.snackbar(
              'Success', // Title
              'Register successfully!');

          Future.delayed(Duration(seconds: 3), () {
            Get.to(() => VehicleDocumentsScreen());
            setState(() {
              _isLoading = false;
            });
          });
        } else {
          print(payload);
          print(response);
          Get.snackbar(
            'Error',
            'Network Error.',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Vertically center
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Horizontally center
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 8,
                  ),
                  SizedBox(
                      height:
                          10), // Adds some spacing between the spinner and text
                  Text("Logging in..."),
                ],
              ) // Shows the loading spinner
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "Vehicle Details!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        "Complete the process details",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Vehicle Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: vehicleModelController,
                      decoration: const InputDecoration(
                        labelText: "Vehicle Model",
                        hintText: "Enter Vehicle Model",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: yearOfModelController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Year of Model",
                        hintText: "ex. 2009",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: licensePlateController,
                      decoration: const InputDecoration(
                        labelText: "License Plate Number",
                        hintText: "ex. NBC 1234",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Accessibility Features",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: rampAvailability == null
                          ? null
                          : rampAvailability!
                              ? 'Yes'
                              : 'No',
                      onChanged: (String? newValue) {
                        setState(() {
                          rampAvailability = newValue == 'Yes';
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Ramp or Lift Availability",
                        border: OutlineInputBorder(),
                      ),
                      items: <String>['Yes', 'No']
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: wheelchairCapacityController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter
                            .digitsOnly, // Allow only digits
                      ],
                      decoration: const InputDecoration(
                        labelText: "Wheelchair Capacity",
                        hintText: "(number only)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: accessibilityFeaturesController,
                      decoration: const InputDecoration(
                        labelText: "Other Accessibility Features",
                        hintText: "Enter Features",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (vehicleModelController.text == "" ||
                              yearOfModelController.text == "" ||
                              licensePlateController.text == "" ||
                              rampAvailability == null ||
                              wheelchairCapacityController.text == "" ||
                              accessibilityFeaturesController.text == "") {
                            Get.snackbar(
                              'Error',
                              'Please complete all the fields.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          vehicleDetailHandler();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
