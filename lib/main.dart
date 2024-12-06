import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedal_application/screens/home_screen.dart';
import 'package:pedal_application/screens/login_screen.dart';

import 'screens/booking_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/vehicle_details_screen.dart'; // Import for Registration Form 1
import 'screens/vehicle_registration_screen.dart'; // Import for Registration Form 2

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      getPages: [
        GetPage(name: '/', page: () => const LoginScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/book', page: () => BookingScreen()),
        GetPage(name: '/sign_up', page: () => SignUpScreen(isDriver: false)),
        GetPage(
            name: '/vehicle_registration',
            page: () => const VehicleRegistrationScreen()),
        GetPage(
            name: '/vehicle_details', page: () => const VehicleDetailsScreen()),
      ],
      initialRoute: '/',
    );
  }
}
