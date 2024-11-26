import 'package:flutter/material.dart';

// BookPage widget with minimal content
class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Now'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const Text("YHiour City, Your Way"),
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
            child: ElevatedButton(onPressed: () {}, child: const Text('Login')),
          )
        ],
      ),
    );
  }
}
