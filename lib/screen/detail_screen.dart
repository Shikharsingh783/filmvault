import 'package:filmvault/components/detail_card.dart';
import 'package:filmvault/models/movie_model.dart';
import 'package:filmvault/provider/favourite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final double rating;
  final List<String> genres;
  final String ended;
  final String premiered;
  final ShowModel displayMovie;
  final String scheduleTime;
  final List<String> scheduleDays;

  const DetailScreen({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    required this.rating,
    required this.genres,
    required this.ended,
    required this.premiered,
    required this.displayMovie,
    required this.scheduleTime,
    required this.scheduleDays, // Changed here
  }) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isExpanded = false; // Controls if the description is expanded or not

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavouriteProvider>(context);

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
                          // Name
                          SizedBox(
                            width: 250,
                            child: Text(
                              overflow: TextOverflow.ellipsis,
                              widget.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Rating
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                const Text(
                                  'Rating: ',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.grey),
                                ),
                                Text(
                                  widget.rating.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
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

                      //add to wishlist
                      const SizedBox(height: 20),

                      GestureDetector(
                        onTap: () {
                          HapticFeedback.heavyImpact();
                          favoriteProvider.toggleFavorite(widget.displayMovie);
                        },
                        child: Container(
                          height: 70,
                          decoration: BoxDecoration(
                              color: favoriteProvider
                                      .isFavorite(widget.displayMovie)
                                  ? const Color.fromARGB(255, 246, 35, 20)
                                  : const Color.fromARGB(255, 244, 51, 51),
                              borderRadius: BorderRadius.circular(12)),
                          child: Center(
                              child: favoriteProvider
                                      .isFavorite(widget.displayMovie)
                                  ? const Text(
                                      'Added To Wishlist',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const Text(
                                      'Add To Wishlist',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                        ),
                      ),

                      const SizedBox(height: 20),

                      //detial card
                      const SizedBox(height: 20),
                      DetailCard(
                        genres: widget.genres,
                        ended: widget.ended,
                        premiered: widget.premiered,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      //schdeule row
                      // Schedule Row with better styling and icons
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[900], // Subtle background color
                            borderRadius:
                                BorderRadius.circular(8), // Rounded corners
                          ),
                          child: Row(
                            children: [
                              // Calendar Icon
                              const Icon(
                                Icons.calendar_today,
                                color: Colors
                                    .redAccent, // Netflix-style red accent
                                size: 24,
                              ),
                              const SizedBox(width: 20),

                              // Days Schedule
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Schedule',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Every ${widget.scheduleDays.join(', ')}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 20),

                              // Clock Icon
                              const Icon(
                                Icons.access_time,
                                color: Colors
                                    .redAccent, // Netflix-style red accent
                                size: 24,
                              ),
                              const SizedBox(width: 10),

                              // Time Schedule
                              Text(
                                widget.scheduleTime,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 50,
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
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
