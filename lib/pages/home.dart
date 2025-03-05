import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            "Home Page",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
