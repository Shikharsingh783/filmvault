import 'package:filmvault/components/detail_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailScreen extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final double rating;
  final List<String> genres;

  const DetailScreen({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.rating,
    required this.genres,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //name
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          //rating
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                const Text(
                                  'Rating: ',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.grey),
                                ),
                                Text(widget.rating.toString(),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
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
                          HapticFeedback.selectionClick();
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

                      const SizedBox(
                        height: 20,
                      ),

                      DetailCard(
                        genres: widget.genres,
                      )
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
                  color: Colors.white.withOpacity(0.2),
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
