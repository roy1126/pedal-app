import 'package:flutter/material.dart';
import 'package:get/get.dart';

// HomePage widget with minimal content
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedal Application'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Your City, Your Way"),
            const Padding(
                padding: EdgeInsets.only(top: 50, bottom: 20),
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 30),
                )),
            const Text('Welcome back to the App!'),
            SizedBox(
              width: 300, // Set the desired width here
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            SizedBox(
              width: 300, // Set the desired width here
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const HomePage());
                  },
                  child: const Text('Login')),
            )
          ],
        ),
      ),
    );
  }
}
