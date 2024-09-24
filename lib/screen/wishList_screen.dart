import 'dart:ui';
import 'package:filmvault/provider/favourite_provider.dart'; // Import the FavouriteProvider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          Consumer<FavouriteProvider>(
            builder: (context, favouriteProvider, child) {
              return favouriteProvider.favoriteMovies.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              backgroundColor: Colors.transparent,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10.0, sigmaY: 10.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.1),
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
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('Clear',
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                  onPressed: () {
                                                    favouriteProvider
                                                        .clearFavourites();
                                                    Navigator.of(context).pop();
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
                  : const SizedBox();
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

          if (favoriteMovies.isEmpty) {
            return const Center(
              child: Text(
                'No favorite movies added yet.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65, // Adjusted aspect ratio for better layout
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];
              bool isFavorite = favouriteProvider.isFavorite(movie);

              return GestureDetector(
                onTap: () {
                  // Handle item tap (navigate to detail screen if needed)
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Display
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                            image: DecorationImage(
                              image: movie.imageUrlOriginal != null
                                  ? NetworkImage(movie.imageUrlOriginal!)
                                  : const AssetImage('assets/placeholder.png')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Movie Details Container
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(12)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Movie Name and Rating
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    movie.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rating: ${movie.rating ?? "N/A"}',
                                  style: const TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            // Favorite Icon
                            IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite ? Colors.white : Colors.white,
                              ),
                              onPressed: () {
                                favouriteProvider.toggleFavorite(movie);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
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
