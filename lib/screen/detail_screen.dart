import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final double rating;

  const DetailScreen({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.rating,
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isExpanded = false; // Controls if the description is expanded or not

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height *
                          0.55, // Fixed height for the image
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height *
                          0.55, // Same height as the image
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [
                            Colors.black, // Darker at the bottom
                            Colors
                                .transparent, // Fully transparent at the center
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // Details section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 60,
                          ),
                          Text(
                            'Rating: ${widget.rating}',
                            style: TextStyle(fontSize: 17, color: Colors.grey),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Description with a 'Read more' button
                      Text(
                        widget.description,
                        maxLines:
                            isExpanded ? null : 3, // Show 3 lines initially
                        overflow: isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded; // Toggle expanded state
                          });
                        },
                        child: Text(
                          isExpanded ? "Read less" : "Read more",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // 'Read more' button color
                          ),
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
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.5),
                ),
                child: const Center(
                    child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
