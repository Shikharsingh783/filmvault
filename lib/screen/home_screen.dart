import 'dart:async';

import 'package:filmvault/provider/show_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:filmvault/models/movie_model.dart';
import 'package:filmvault/screen/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Fetch movies when the screen initializes
    final movieProvider = Provider.of<ShowProvider>(context, listen: false);
    movieProvider.fetchMovies();

    // Set up the timer to automatically switch between images every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      _nextPage();
    });
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E), // Dark background color
      body: Consumer<ShowProvider>(
        builder: (context, movieProvider, child) {
          // Handle loading and error states
          if (movieProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (movieProvider.movies.isEmpty) {
            return const Center(
              child: Text('No movies found.',
                  style: TextStyle(color: Colors.white)),
            );
          }

          final List<ShowModel> moviesList = movieProvider.movies;
          List<ShowModel> displayMovies = [
            moviesList.last, // Duplicate last
            ...moviesList,
            moviesList.first, // Duplicate first
          ];

          return SafeArea(
            child: Column(
              children: [
                // Top container for sliding posters
                SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: displayMovies.length,
                    itemBuilder: (context, index) {
                      final movie = displayMovies[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(16), // Rounded corners
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 250, // Set the height for the container
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: movie.imageUrlOriginal != null
                                    ? NetworkImage(movie.imageUrlOriginal!)
                                    : const AssetImage(
                                        'assets/placeholder.png'), // Use a placeholder if no image
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Rest of the ListView
                Expanded(
                  child: ListView.builder(
                    itemCount: moviesList.length,
                    itemBuilder: (context, index) {
                      final movie = moviesList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          color: const Color(0xFF2C2C2E), // Darker card color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4, // Elevation for depth effect
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  8), // Rounded corners for image
                              child: movie.imageUrlMedium != null
                                  ? Image.network(
                                      movie.imageUrlMedium!,
                                      width: 50,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.movie,
                                      color: Colors
                                          .grey), // Placeholder for missing image
                            ),
                            title: Text(
                              movie.name,
                              style: const TextStyle(
                                color: Colors.white, // Light text color
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(movie.status,
                                    style: const TextStyle(
                                        color: Colors
                                            .grey)), // Display movie status
                                Text('Genres: ${movie.genres.join(', ')}',
                                    style: const TextStyle(
                                        color: Colors.grey)), // Display genres
                              ],
                            ),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailScreen(
                                  genres: movie.genres,
                                  image: movie.imageUrlOriginal!,
                                  title: movie.name,
                                  description: movie.summary,
                                  rating: movie.rating,
                                ),
                              ));
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
