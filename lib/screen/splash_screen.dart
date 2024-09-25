import 'dart:async';
import 'package:flutter/material.dart';
import 'package:filmvault/screen/index_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _scaleAnimations;

  final String filmVaultText = "FilmVault"; // The text to animate

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Duration for the whole animation
    );

    // Generate staggered animations for each letter's fade and scale effect
    _fadeAnimations = List.generate(filmVaultText.length, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1, // Stagger fade animation for each letter
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    // Modify the scale based on the position to give a curved effect
    _scaleAnimations = List.generate(filmVaultText.length, (index) {
      double scaleFactor;

      // Adjust scale factor based on the position to create a curved effect
      int centerIndex = filmVaultText.length ~/ 2;
      if (index == centerIndex) {
        scaleFactor = 1.1; // Center letter slightly larger
      } else if (index < centerIndex) {
        scaleFactor = 1.0 + (0.1 * (centerIndex - index)); // Left side larger
      } else {
        scaleFactor = 1.0 + (0.1 * (index - centerIndex)); // Right side larger
      }

      return Tween<double>(begin: 0.5, end: scaleFactor).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1, // Stagger scale animation for each letter
            1.0,
            curve: Curves.elasticOut, // Netflix-like elastic zoom effect
          ),
        ),
      );
    });

    // Start the animation
    _animationController.forward();

    // Move to the next screen after 4 seconds
    Timer(
      const Duration(seconds: 4),
      () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const IndexScreen()),
        (Route<dynamic> route) => false,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min, // Center the row horizontally
            mainAxisAlignment: MainAxisAlignment.center, // Center the text
            children: List.generate(filmVaultText.length, (index) {
              return AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimations[index].value, // Fade effect
                    child: Transform.scale(
                      scale: _scaleAnimations[index]
                          .value, // Scale effect with curve
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal:
                                5.0), // Increased padding for cleaner spacing
                        child: Text(
                          filmVaultText[index],
                          style: const TextStyle(
                            fontFamily: 'BebasNeue',
                            fontSize: 70, // Font size remains large
                            fontWeight: FontWeight.bold,
                            color: Colors.red, // Netflix-like red color
                            letterSpacing:
                                3.0, // Increased letter spacing for cleaner look
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
