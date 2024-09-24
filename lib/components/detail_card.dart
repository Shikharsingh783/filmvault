import 'dart:ui'; // For the BackdropFilter
import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  final List<String> genres;
  const DetailCard({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Blurred background
            BackdropFilter(
              filter:
                  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Blur effect
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color:
                      Colors.white.withOpacity(0.2), // Semi-transparent white
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white
                        .withOpacity(0.2), // Border with slight transparency
                  ),
                ),
              ),
            ),
            // Content on top of the blur effect
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.55),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Genre',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        genres.join(', '),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(
                    color: Colors.white54,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
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
