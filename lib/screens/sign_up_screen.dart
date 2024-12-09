import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pedal_application/model/user-model.dart';
import 'package:pedal_application/screens/login_screen.dart';

class SignUpScreen extends StatefulWidget {
  final bool isDriver;

  const SignUpScreen({super.key, required this.isDriver});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    // Dispose of the controller when it's no longer needed
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDriver = widget.isDriver;
    // Get the screen size for mobile responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Limit to mobile screens by setting a maximum width and height
    double mobileWidth =
        screenWidth < 400 ? screenWidth - 32 : 400; // Max width for mobile
    double mobileHeight =
        screenHeight < 700 ? screenHeight : 700; // Max height for mobile

    // Adjust form width based on screen size
    double formWidth = mobileWidth;
    double logoSize = 400.0; // Size for the logo

    Future<void> signupHandler() async {
      final url = Uri.parse(
          'https://nameless-waters-42836-7709a51fcf3d.herokuapp.com/api/signup'); // Replace with your API URL

      User user = User(
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          phoneNumber: phoneNumberController.text,
          address: addressController.text,
          email: emailController.text,
          password: passwordController.text,
          isDriver: isDriver,
          lastLogin: null);

      // Send POST request
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type':
                'application/json', // Required for sending JSON data
          },
          body: jsonEncode(user), // Convert requestData to JSON
        );

        // Check the response status
        if (response.statusCode == 200) {
          setState(() {
            _isLoading = true;
          });

          Get.snackbar(
              'Success', // Title
              'Sign up successfully!');

          Future.delayed(Duration(seconds: 3), () {
            Get.to(() => LoginScreen());
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
      backgroundColor: Colors.white, // No tealAccent background color
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
                  Text("Navigating to Login Screen..."),
                ],
              )
            : ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: mobileWidth, // Limit width to mobile size
                  maxHeight: mobileHeight, // Limit height to mobile size
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 0), // No vertical padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Stack to overlay the logo at the back and other content on top
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Logo at the back
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                                20), // Add rounded corners
                            child: Image.asset(
                              'lib/assets/images/LOGO.png', // Your logo file path
                              height: logoSize, // Fixed size for the logo
                              width: logoSize, // Fixed size for the logo
                              fit: BoxFit
                                  .contain, // Ensures the logo maintains its aspect ratio
                            ),
                          ),
                          // Positioned widget to bring the back button in front of the logo
                          const Positioned(
                            top: 16,
                            left: 16,
                            child: BackButton(
                                color: Colors
                                    .black), // Back button inside the logo
                          ),
                        ],
                      ),
                      // "Let's Get Started!" and "Complete the RIDER profile details" at the top of the form
                      Padding(
                        padding: const EdgeInsets.only(
                            top:
                                5), // Reduced top padding to move text closer to the image
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // "Let's Get Started!" text centered
                            const Text(
                              "Let's get Started!",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            // Subtitle "Complete the RIDER profile details" centered
                            Text(
                              isDriver
                                  ? "Complete the RIDER profile details"
                                  : 'Complete USER details',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      // The rest of the content, the form
                      Container(
                        decoration: BoxDecoration(
                          color: Colors
                              .grey[200], // Grayish background for the form
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Form fields for the user input
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8.0), // Space between fields
                                    child: TextFormField(
                                      controller: firstNameController,
                                      decoration: const InputDecoration(
                                        labelText: 'First Name',
                                        hintText: 'ex. Juan',
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0), // Space between fields
                                    child: TextFormField(
                                      controller: lastNameController,
                                      decoration: const InputDecoration(
                                        labelText: 'Last Name',
                                        hintText: 'ex. Dela Cruz',
                                        labelStyle: TextStyle(
                                          color: Colors.black,
                                        ),
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: phoneNumberController,
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                hintText: 'Enter Phone Number',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: addressController,
                              decoration: const InputDecoration(
                                labelText: 'Home Address',
                                hintText: 'Enter Home Address',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                hintText: 'Enter Email',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter Password',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: confirmPasswordController,
                              decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Retype Password',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (firstNameController.text == "" ||
                                    lastNameController.text == "" ||
                                    phoneNumberController.text == "" ||
                                    addressController.text == "" ||
                                    emailController.text == "" ||
                                    passwordController.text == "" ||
                                    firstNameController.text == "" ||
                                    confirmPasswordController.text == "") {
                                  Get.snackbar(
                                    'Error',
                                    'Please complete all the fields.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }

                                if (passwordController.text !=
                                    confirmPasswordController.text) {
                                  Get.snackbar(
                                    'Error',
                                    'Please match your passwords.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }

                                signupHandler();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.tealAccent[700],
                                foregroundColor: Colors.white, // Text color
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text('Sign Up'),
                            ),
                          ],
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
