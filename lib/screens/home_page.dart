import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sign_up_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // Get the screen size for mobile responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Limit to mobile screens by setting a maximum width and height
    double mobileWidth = 400; // Maximum width for mobile
    double mobileHeight = 600; // Maximum height for mobile

    // Set a scaling factor and minimum size for the logo and background
    double scalingFactor = 0.25; // 25% of screen height
    double minLogoSize = 400.0; // Minimum size for the logo
    double logoSize = screenHeight * scalingFactor; // Calculate logo size based on screen height

    // Ensure the logo size is not smaller than the minimum size
    if (logoSize < minLogoSize) {
      logoSize = minLogoSize;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: mobileWidth, // Limit width to mobile size
            maxHeight: mobileHeight, // Limit height to mobile size
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0), // No vertical padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Use a Stack to overlay the logo without background container
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Add a border radius to the image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Add rounded corners
                      child: Image.asset(
                        'lib/assets/images/LOGO.png', // Your logo file path
                        height: logoSize, // Fixed size for the logo
                        width: logoSize, // Fixed size for the logo
                        fit: BoxFit.contain, // Ensures the logo maintains its aspect ratio
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Reduced height to move form up
                // Login Form Section
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
                        // Email Field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter Email',
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Password Field
                        TextFormField(
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
                        // Login Button with tealAccent700 background color
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => const HomePage()); // Replace with desired page
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.tealAccent[700], // Set login button to tealAccent700
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Forgot Password Text
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
                        // Buttons for Create Account and Create Driver's Account aligned horizontally
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons to the left and right
                          children: [
                            // Create Account Button
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "/signup");  // This navigates to the Sign Up page
                              },
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Colors.tealAccent[700]!, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              ),
                              child: Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.tealAccent[700],
                                ),
                              ),
                            ),
                            // Create Driver's Account Button
                            ElevatedButton(
                              onPressed: () {
                                // Add logic for creating a driver's account
                              },
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Colors.tealAccent[700]!, width: 1), // Border color tealAccent700
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                              ),
                              child: Text(
                                "Create Driver's Account",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.tealAccent[700], // Set text color to tealAccent700
                                ),
                              ),
                            ),
                          ],
                        ),
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
