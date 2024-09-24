import 'dart:ui'; // For the BackdropFilter
import 'package:flutter/material.dart';

class SearchShowCard extends StatelessWidget {
  final String url;
  final String name;
  final List<String> genres;

  const SearchShowCard({
    super.key,
    required this.url,
    required this.name,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin:
          const EdgeInsets.symmetric(vertical: 8.0), // Add margin for spacing
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black
            .withOpacity(0.4), // Slightly more transparent background
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Shadow color
            blurRadius: 10.0, // Softening the shadow
            offset: const Offset(0, 4), // Shadow offset
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0), // Increased blur effect for glassmorphism
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1), // Light transparent color
                  Colors.white.withOpacity(0.05), // Dark transparent color
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                // Left side: Image
                Container(
                  width: 80, // Fixed width for the image
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(url),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10), // Space between image and text
                // Right side: Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4), // Small space between texts
                        Text(
                          genres.join(', '),
                          style: const TextStyle(
                            color: Colors.grey, // Grey color for genres
                          ),
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
