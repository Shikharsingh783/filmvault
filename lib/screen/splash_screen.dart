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
      const Duration(seconds: 3), // Duration of the splash screen
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
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stylish logo or text representation
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[850], // Dark grey for the circle background
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 20,
                    offset: Offset(0, 10), // Shadow position
                  ),
                ],
              ),
              child: const Text(
                'FV',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // App title
            const Text(
              'Film Vault',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            // Tagline
            Text(
              'Your ultimate movie guide',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
