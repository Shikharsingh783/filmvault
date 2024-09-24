// ignore: file_names
import 'package:filmvault/provider/favourite_provider.dart'; // Import the FavouriteProvider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui'; // Import for BackdropFilter

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          // Show the bin icon if the favoriteMovies list is not empty
          Consumer<FavouriteProvider>(
            builder: (context, favouriteProvider, child) {
              return favouriteProvider.favoriteMovies.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Handle bin icon press
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor:
                                  Colors.transparent, // Transparent background
                              child: Stack(
                                children: [
                                  // BackdropFilter for glass effect
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10.0, sigmaY: 10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(
                                              0.1), // Semi-transparent background
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                              color: Colors.white
                                                  .withOpacity(0.2)),
                                        ),
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Clear Wishlist',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Text(
                                              'Are you sure you want to clear your wishlist?',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 20),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                TextButton(
                                                  child: const Text('Cancel',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Clear',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  onPressed: () {
                                                    // Clear the wishlist
                                                    favouriteProvider
                                                        .clearFavourites();
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    )
                  : const SizedBox(); // Empty widget if no favorites
            },
          ),
        ],
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text('My Wishlist'),
      ),
      body: Consumer<FavouriteProvider>(
        builder: (context, favouriteProvider, child) {
          final favoriteMovies = favouriteProvider.favoriteMovies;

          // Check if there are no favorite movies
          if (favoriteMovies.isEmpty) {
            return const Center(
              child: Text(
                'No favorite movies added yet.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          // Use GridView to display favorite movies
          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              childAspectRatio: 0.7, // Aspect ratio of each item
              crossAxisSpacing: 10, // Horizontal spacing between items
              mainAxisSpacing: 10, // Vertical spacing between items
            ),
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];
              return GestureDetector(
                onTap: () {
                  // Handle item tap (navigate to detail screen if needed)
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: movie.imageUrlOriginal != null
                          ? NetworkImage(movie.imageUrlOriginal!)
                          : const AssetImage('assets/placeholder.png')
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        movie.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
