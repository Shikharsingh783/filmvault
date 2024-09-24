import 'dart:async';
import 'package:filmvault/screen/index_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 1), // Duration of the splash screen
      () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const IndexScreen()),
        (Route<dynamic> route) => false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/splash_background.jpg'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo (Replace with your actual logo asset)
            Image.asset(
              'assets/logo.png', // Your logo image
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 20),
            // App title or tagline
            const Text(
              'Film Vault',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Change text color as needed
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black54,
                    offset: Offset(0.0, 0.0),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your ultimate movie guide',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black54,
                    offset: Offset(0.0, 0.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
