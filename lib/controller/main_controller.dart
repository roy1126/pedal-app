import 'dart:developer';

import 'package:get/get.dart';
import 'package:pedal_application/model/user-model.dart';
import 'dart:convert'; // For JSON parsing
import '../model/appData.model.dart';

class MainController extends GetxController {
  var _isLogin = false;
  final Rx<({List booking, List<User> users})> _applicationData = (
    users: [
      User(
          id: "0001",
          firstName: "John",
          lastName: "Smith",
          phoneNumber: "09123456789",
          address: "29 F. Cruz Santolan , Pasig City",
          email: "q",
          password: "w",
          isDriver: false),
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
