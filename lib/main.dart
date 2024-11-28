import 'package:flutter/material.dart';
import 'package:pedal_application/screens/home_page.dart';
import 'package:route_manager/route_manager.dart';

import 'screens/book_page.dart';
import 'screens/sign_up_screen.dart';
import 'screens/registration_form1.dart'; // Import for Registration Form 1
import 'screens/registration_form2.dart'; // Import for Registration Form 2

final routeManager = RouteManager(
  routesInfo: [
    RouteInfo(name: "/", routeWidget: (args) => const HomePage()),
    RouteInfo(name: "/book", routeWidget: (args) => const BookPage()),
    RouteInfo(name: "/signup", routeWidget: (args) => SignUpScreen()), // Sign-up page route
    RouteInfo(name: "/registration_form1", routeWidget: (args) => RegistrationForm1()), // Registration Form 1
    RouteInfo(name: "/registration_form2", routeWidget: (args) => RegistrationForm2()), // Registration Form 2
  ],  
  initialRouteInfo: InitialRouteInfo(initialRouteName: "/"),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routeInformationParser: routeManager.informationParser,
      routerDelegate: routeManager.routerDelegate,
    );
  }
}
