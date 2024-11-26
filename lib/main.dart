import 'package:flutter/material.dart';
import 'package:pedal_application/screens/home_page.dart';
import 'package:route_manager/route_manager.dart';

import 'screens/book_page.dart';

final routeManager = RouteManager(
  routesInfo: [
    RouteInfo(name: "/", routeWidget: (args) => const HomePage()),
    RouteInfo(name: "/book", routeWidget: (args) => const BookPage()),
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
