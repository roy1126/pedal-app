
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedal_application/controller/main_controller.dart';
import 'package:pedal_application/screens/booking_screen.dart';
import 'sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TextEditingControllers for the email and password fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final mainController = Get.put(MainController());
  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double mobileWidth = 400; // Maximum width for mobile
    double mobileHeight = 600; // Maximum height for mobile

    double scalingFactor = 0.25; // 25% of screen height
    double minLogoSize = 400.0; // Minimum size for the logo
    double logoSize = screenHeight * scalingFactor;

    if (logoSize < minLogoSize) {
      logoSize = minLogoSize;
    }

    bool isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
                  Text("Loading..."),
                ],
              ) // Shows the loading spinner
            : ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: mobileWidth,
                  maxHeight: mobileHeight,
                ),
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              'lib/assets/images/LOGO.png',
                              height: logoSize,
                              width: logoSize,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                "Welcome back! Log in to continue.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Email Field with Controller
                              TextFormField(
                                controller:
                                    emailController, // Attach controller
                                decoration: InputDecoration(
                                  labelText: 'Enter Email',
                                  prefixIcon: const Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Password Field with Controller
                              TextFormField(
                                controller:
                                    passwordController, // Attach controller
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Enter Password',
                                  prefixIcon: const Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Login Button
                              ElevatedButton(
                                onPressed: () {
                                  // Handle login logic here

                                  String email = emailController.text;
                                  String password = passwordController.text;

                                  if (email.isEmpty || password.isEmpty) {
                                    // Show an error if fields are empty
                                    Get.snackbar(
                                      'Error',
                                      'Please enter both email and password.',
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  } else {
                                    setState(() {
                                      _isLoading = true;
                                      mainController.login(email, password);
                                    });

                                    Future.delayed(Duration(seconds: 3), () {
                                      if (mainController.isLoggedIn()) {
                                        Get.to(() => BookingScreen());
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          'User is not found',
                                          snackPosition: SnackPosition.BOTTOM,
                                        );
                                      }

                                      setState(() {
                                        _isLoading = false;
                                      });
                                    });
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.tealAccent[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 12),
                                ),
                                child: Text(
                                  "Login",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  // Forgot password logic
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.tealAccent[700],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.to(() => SignUpScreen(
                                            isDriver: false,
                                          ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                          color: Colors.tealAccent[700]!),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                    ),
                                    child: Text(
                                      "Create Account",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.tealAccent[700],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Add logic for creating a driver's account
                                      Get.to(() => SignUpScreen(
                                            isDriver: true,
                                          ));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      side: BorderSide(
                                          color: Colors.tealAccent[700]!),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 12),
                                    ),
                                    child: Text(
                                      "Create Driver's Account",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.tealAccent[700],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
