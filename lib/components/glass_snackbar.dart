import 'dart:ui';
import 'package:flutter/material.dart';

class GlassSnackBar {
  final String text;

  GlassSnackBar({required this.text});

  SnackBar build() {
    return SnackBar(
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.only(bottom: 20, left: 55, right: 55),
      padding: EdgeInsets
          .zero, // No padding here, we will manage it inside the content
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      behavior: SnackBarBehavior.floating,
      content: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:
                  Colors.white.withOpacity(0.2), // Semi-transparent background
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: Colors.white.withOpacity(0.5), width: 1),
            ),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:
                      Colors.white, // Change text color to white for contrast
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Utility function to show the GlassSnackBar
void showGlassSnackBar(BuildContext context, String message) {
  final snackBar = GlassSnackBar(text: message).build();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
