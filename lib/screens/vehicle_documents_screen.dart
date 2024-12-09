import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:typed_data'; // For Uint8List
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:pedal_application/controller/main_controller.dart';
import 'package:pedal_application/model/vehicle.documents.model.dart';
import 'package:http/http.dart' as http;
import 'package:pedal_application/screens/home_screen.dart';

class VehicleDocumentsScreen extends StatefulWidget {
  const VehicleDocumentsScreen({super.key});

  @override
  _VehicleDocumentsScreenState createState() => _VehicleDocumentsScreenState();
}

class _VehicleDocumentsScreenState extends State<VehicleDocumentsScreen> {
  final mainController = Get.put(MainController());
  // TextEditingControllers
  final TextEditingController insuranceValidityController =
      TextEditingController();

  bool? inspectionCertificate; // Dropdown value

  // File upload variables
  List<Map<String, dynamic>> VehicleDocumentsFiles = [];
  List<Map<String, dynamic>> insuranceDocumentFiles = [];
  List<Map<String, dynamic>> driverLicenseFiles = [];

  // File picker function
  Future<void> pickFile(String fileType) async {
    if (_getFileList(fileType).length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You can only upload up to 3 files.")),
      );
      return;
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      String fileName = result.files.single.name;
      Uint8List? fileBytes = result.files.single.bytes;

      setState(() {
        _getFileList(fileType).add({'name': fileName, 'bytes': fileBytes});
      });
    }
  }

  void removeFile(String fileType, int index) {
    setState(() {
      _getFileList(fileType).removeAt(index);
    });
  }

  List<Map<String, dynamic>> _getFileList(String fileType) {
    if (fileType == 'VehicleDocuments') {
      return VehicleDocumentsFiles;
    } else if (fileType == 'insuranceDocument') {
      return insuranceDocumentFiles;
    } else if (fileType == 'driverLicense') {
      return driverLicenseFiles;
    }
    return [];
  }

  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose of the controller when it's no longer needed
    insuranceValidityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> vehicleDetailHandler() async {
      final url = Uri.parse(
          'https://nameless-waters-42836-7709a51fcf3d.herokuapp.com/api/vehicle/documents'); // Replace with your API URL

      final vehicleDocuments = VehicleDocuments(
        insuranceValidity: insuranceValidityController.text,
        hasInspectionCertificate: inspectionCertificate ?? false,
      );
      final payload = {
        "userId": mainController.getCurrentUser().id,
        "vehicleDocuments": vehicleDocuments.toJson()
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
              'Documents submitted successfully!');

          Future.delayed(Duration(seconds: 3), () {
            Get.to(() => HomeScreen());
            setState(() {
              _isLoading = false;
            });
          });
        } else {
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
                        "Vehicle Registration!",
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
                      "Validity and Safety",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 16),
                    // TextField(
                    //   controller: licenseNumberController,
                    //   decoration: const InputDecoration(
                    //     labelText: "License Number",
                    //     hintText: "ex. DL-1234567",
                    //     border: OutlineInputBorder(),
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: insuranceValidityController,
                      decoration: const InputDecoration(
                        labelText: "Insurance Validity",
                        hintText: "e.g., MM/YYYY",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: inspectionCertificate == null
                          ? null
                          : inspectionCertificate!
                              ? 'Yes'
                              : 'No',
                      onChanged: (String? newValue) {
                        setState(() {
                          // Map "Yes" to true and "No" to false
                          inspectionCertificate = newValue == 'Yes';
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Vehicle Inspection Certificate",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0), // Reduce padding
                      ),
                      items: <String>['Yes', 'No']
                          .map((String value) => DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      isExpanded:
                          true, // Ensures it fills the width of the container but remains compact
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Document Uploads (optional)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildFileUploadField(
                      label: "Vehicle Registration Document",
                      fileType: 'VehicleDocuments',
                      files: VehicleDocumentsFiles,
                    ),
                    const SizedBox(height: 16),
                    buildFileUploadField(
                      label: "Insurance Document",
                      fileType: 'insuranceDocument',
                      files: insuranceDocumentFiles,
                    ),
                    const SizedBox(height: 16),
                    buildFileUploadField(
                      label: "Driver's License",
                      fileType: 'driverLicense',
                      files: driverLicenseFiles,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle "Next" button press
                          if (insuranceValidityController.text == "" ||
                              inspectionCertificate == null) {
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

  Widget buildFileUploadField({
    required String label,
    required String fileType,
    required List<Map<String, dynamic>> files,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        // Display the file names without the box around them
        ...files.asMap().entries.map((entry) {
          int index = entry.key;
          String fileName = entry.value['name'];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    fileName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () => removeFile(fileType, index),
                ),
              ],
            ),
          );
        }),
        files.length < 3
            ? ElevatedButton(
                onPressed: () => pickFile(fileType),
                child: const Text("Add File"),
              )
            : const Text(
                "Maximum 3 files uploaded",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
      ],
    );
  }
}
