import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen size for mobile responsiveness
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Limit to mobile screens by setting a maximum width and height
    double mobileWidth = screenWidth < 400 ? screenWidth - 32 : 400; // Max width for mobile
    double mobileHeight = screenHeight < 700 ? screenHeight : 700; // Max height for mobile

    // Adjust form width based on screen size
    double formWidth = mobileWidth;
    double logoSize = 400.0; // Size for the logo

    return Scaffold(
      backgroundColor: Colors.white, // No tealAccent background color
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
                // Stack to overlay the logo at the back and other content on top
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Logo at the back
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Add rounded corners
                      child: Image.asset(
                        'lib/assets/images/LOGO.png', // Your logo file path
                        height: logoSize, // Fixed size for the logo
                        width: logoSize, // Fixed size for the logo
                        fit: BoxFit.contain, // Ensures the logo maintains its aspect ratio
                      ),
                    ),
                    // Positioned widget to bring the back button in front of the logo
                    Positioned(
                      top: 16,
                      left: 16,
                      child: BackButton(color: Colors.black), // Back button inside the logo
                    ),
                  ],
                ),
                // "Let's Get Started!" and "Complete the RIDER profile details" at the top of the form
                Padding(
                  padding: const EdgeInsets.only(top: 5), // Reduced top padding to move text closer to the image
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // "Let's Get Started!" text centered
                      Text(
                        "Let's get Started!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 5),
                      // Subtitle "Complete the RIDER profile details" centered
                      Text(
                        "Complete the RIDER profile details",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                // The rest of the content, the form
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Grayish background for the form
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Form fields for the user input
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0), // Space between fields
                              child: TextFormField(
                                decoration: InputDecoration(
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
                              padding: const EdgeInsets.only(left: 8.0), // Space between fields
                              child: TextFormField(
                                decoration: InputDecoration(
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
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          hintText: 'Enter Phone Number',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Home Address',
                          hintText: 'Enter Home Address',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter Email',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter Password',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Retype Password',
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Sign-up action
                        },
                        child: Text('Sign Up'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent[700],
                          foregroundColor: Colors.white, // Text color
                          padding: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
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
