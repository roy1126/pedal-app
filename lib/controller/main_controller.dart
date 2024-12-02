//import 'dart:developer';

import 'package:get/get.dart';
import 'package:pedal_application/model/user-model.dart';
//import 'dart:convert'; // For JSON parsing
//import '../model/appData.model.dart';

class MainController extends GetxController {
  var _isLogin = false;
  final Rx<({List booking, List<User> users})> _applicationData = (
    users: [
      User(
          id: "0001",
          firstName: "John",
          lastName: "Smith",
          phoneNumber: "09123456789",
          homeAddress: "29 F. Cruz Santolan , Pasig City",
          email: "q",
          password: "w",
          confirmPassword"w",
          isDriver: false),

      Driver(
          id: "0001",
          firstName: "John",
          lastName: "Smith",
          phoneNumber: "09123456789",
          homeAddress: "29 F. Cruz Santolan , Pasig City",
          email: "q",
          password: "w",
          confirmPassword"w",
          isDriver: true),

                // Create car and document objects
      CarDetails car = CarDetails(
        vehicleModel: "Toyota Corolla",
        yearModel: "2024",
        licensePlate: "ABC1234",
        accessibilityFeatures: "RAMP",
      );

      Documents documents = Documents(
        vehicleRegistration: "DL123456",
        insuranceDocument: DateTime(2025, 12, 31),
        driverLicense: "D-0123",
      );

      // Add details to the controller
      final controller = Get.find<MainController>();
      controller.addCarDetails("0001", car); // Assuming userId is "0001"
      controller.addDocuments("0001", documents);
    ],
    booking: []
  ).obs;

  login(String email, String password) {
    final users = _applicationData.value.users
        .where((User user) => user.email == email && user.password == password);

    _isLogin = users.isNotEmpty;
  }

  bool isLoggedIn() {
    return _isLogin;
  }
}
