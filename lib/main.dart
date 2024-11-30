import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedal_application/screens/login_screen.dart';
import 'package:route_manager/route_manager.dart';

import 'screens/booking_screen.dart';
import 'screens/sign_up_screen.dart';
import 'screens/vehicle_details_screen.dart'; // Import for Registration Form 1
import 'screens/vehicle_registration_screen.dart'; // Import for Registration Form 2

// final routeManager = RouteManager(
//   routesInfo: [
//     // Defining all routes
//     RouteInfo(name: "/", routeWidget: (args) => const LoginScreen()),
//     RouteInfo(name: "/book", routeWidget: (args) => const BookingScreen()),
//     RouteInfo(name: "/sign_up_screen", routeWidget: (args) => SignUpScreen()),
//     RouteInfo(
//         name: "/vehicle_registration",
//         routeWidget: (args) => const VehicleRegistrationScreen()),
//     RouteInfo(
//         name: "/vehicle_details",
//         routeWidget: (a  rgs) => const VehicleDetailsScreen()),
//   ],
//   initialRouteInfo:
//       InitialRouteInfo(initialRouteName: "/"), // Starting route is LoginScreen
// );

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       routeInformationParser:
//           routeManager.informationParser, // Used for parsing the route
//       routerDelegate:
//           routeManager.routerDelegate, // Used for managing the navigation
//       // Make sure that the `onGenerateRoute` is not set here to avoid conflicts
//       // onGenerateRoute: (settings) => null, // Ensure this is not set or commented out
//     );
//   }
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      getPages: [
        GetPage(name: '/', page: () => const LoginScreen()),
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
