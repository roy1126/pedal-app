import 'package:flutter/material.dart';

void main() {
  runApp(const VehicleDetailsScreen());
}

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CarRegistrationScreen(),
    );
  }
}

class CarRegistrationScreen extends StatefulWidget {
  const CarRegistrationScreen({super.key});

  @override
  _CarRegistrationScreenState createState() => _CarRegistrationScreenState();
}

class _CarRegistrationScreenState extends State<CarRegistrationScreen> {
  final TextEditingController vehicleModelController = TextEditingController();
  final TextEditingController yearOfModelController = TextEditingController();
  final TextEditingController licensePlateController = TextEditingController();
  final TextEditingController wheelchairCapacityController =
      TextEditingController();
  final TextEditingController accessibilityFeaturesController =
      TextEditingController();

  String? rampAvailability; // For the dropdown menu

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
                value: rampAvailability,
                onChanged: (String? newValue) {
                  setState(() {
                    rampAvailability = newValue;
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
}
