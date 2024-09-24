import 'dart:async';
import 'package:filmvault/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:filmvault/screen/detail_screen.dart';
import 'package:filmvault/provider/show_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController =
      PageController(viewportFraction: 0.72); // Increased viewportFraction
  Timer? _timer;
  double _currentPage = 0;
  late Future<List<ShowModel>> futureMovies; // Declare as late

  @override
  void initState() {
    super.initState();

    // Initialize the futureMovies variable
    futureMovies =
        Provider.of<ShowProvider>(context, listen: false).fetchMovies();

    // Set up the timer to automatically switch between images every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      _nextPage();
    });

    // Listen to page changes
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  void _nextPage() {
    int nextPage = (_currentPage + 1).toInt();
    _pageController.animateToPage(
      nextPage,
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
      body: FutureBuilder<List<ShowModel>>(
        future: futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 50,
              ),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load movies.',
                  style: TextStyle(color: Colors.white)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No movies found.',
                  style: TextStyle(color: Colors.white)),
            );
          }

          final List<ShowModel> moviesList = snapshot.data!;
          List<ShowModel> displayMovies = [
            moviesList.last, // Duplicate last
            ...moviesList,
            moviesList.first, // Duplicate first
          ];

          return SafeArea(
            child: Column(
              children: [
                // Carousel container for sliding posters with scaling and rotation effects
                SizedBox(
                  height: 400,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: displayMovies.length,
                    itemBuilder: (context, index) {
                      final movie = displayMovies[index];

                      // Calculate the scaling and rotation effects
                      double scale = (1 - ((_currentPage - index).abs() * 0.2))
                          .clamp(0.0, 1.0); // Adjust scale for smoothness

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 1.0), // Reduced padding for more width
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..setEntry(3, 2, 0.001),
                          child: Opacity(
                            opacity: scale.clamp(
                                0.5, 1.0), // Fade effect for side cards
                            child: Transform.scale(
                              scale: scale, // Scale effect for the center card
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: movie.imageUrlOriginal != null
                                            ? NetworkImage(
                                                movie.imageUrlOriginal!)
                                            : const AssetImage(
                                                'assets/placeholder.png',
                                              ) as ImageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // List of movies below the carousel
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
                          elevation: 4,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: movie.imageUrlMedium != null
                                  ? Image.network(
                                      movie.imageUrlMedium!,
                                      width: 50,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.movie, color: Colors.grey),
                            ),
                            title: Text(
                              movie.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(movie.status,
                                    style: const TextStyle(color: Colors.grey)),
                                Text('Genres: ${movie.genres.join(', ')}',
                                    style: const TextStyle(color: Colors.grey)),
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
