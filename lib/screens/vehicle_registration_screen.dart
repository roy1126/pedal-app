import 'package:flutter/material.dart';
import 'dart:typed_data'; // For Uint8List
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const VehicleRegistrationScreen());
}

class VehicleRegistrationScreen extends StatelessWidget {
  const VehicleRegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CarRegistrationScreen(),
    );
  }
}

class CarRegistrationScreen extends StatefulWidget {
  @override
  _CarRegistrationScreenState createState() => _CarRegistrationScreenState();
}

class _CarRegistrationScreenState extends State<CarRegistrationScreen> {
  // TextEditingControllers
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController insuranceValidityController =
      TextEditingController();

  String? inspectionCertificate; // Dropdown value

  // File upload variables
  List<Map<String, dynamic>> vehicleRegistrationFiles = [];
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
    if (fileType == 'vehicleRegistration') {
      return vehicleRegistrationFiles;
    } else if (fileType == 'insuranceDocument') {
      return insuranceDocumentFiles;
    } else if (fileType == 'driverLicense') {
      return driverLicenseFiles;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  "Car Registration!",
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
              const SizedBox(height: 16),
              TextField(
                controller: licenseNumberController,
                decoration: const InputDecoration(
                  labelText: "License Number",
                  hintText: "ex. DL-1234567",
                  border: OutlineInputBorder(),
                ),
              ),
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
              value: inspectionCertificate,
              onChanged: (String? newValue) {
                setState(() {
                  inspectionCertificate = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: "Vehicle Inspection Certificate",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0), // Reduce padding
              ),
              items: <String>['Yes', 'No']
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              isExpanded: true, // Ensures it fills the width of the container but remains compact
            ),

              const SizedBox(height: 24),
              const Text(
                "Document Uploads",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              buildFileUploadField(
                label: "Vehicle Registration Document",
                fileType: 'vehicleRegistration',
                files: vehicleRegistrationFiles,
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
        }).toList(),
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
