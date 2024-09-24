import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const DetailScreen({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Use a SingleChildScrollView to allow scrolling if necessary
          SingleChildScrollView(
            child: Column(
              children: [
                // Container for the image with fade effect starting from bottom to top
                ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter, // Start from the bottom
                      end: Alignment.bottomCenter, // Fade towards the center
                      colors: [
                        Colors.black, // Start with black at the bottom
                        Colors.transparent, // End transparent at the center
                      ],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstIn,
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height *
                        0.4, // Fixed height for the image
                  ),
                ),
                // Details section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Ensure text is visible
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white, // Ensure text is visible
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Back button positioned at the top
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
