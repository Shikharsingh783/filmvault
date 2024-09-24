import 'dart:async';
import 'package:filmvault/models/movie_model.dart';
import 'package:filmvault/provider/favourite_provider.dart';
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
  final PageController _pageController = PageController(viewportFraction: 0.72);
  Timer? _timer;
  double _currentPage = 0;
  late Future<List<ShowModel>> futureMovies;

  @override
  void initState() {
    super.initState();

    futureMovies =
        Provider.of<ShowProvider>(context, listen: false).fetchMovies();

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      _nextPage();
    });

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
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
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
            moviesList.last,
            ...moviesList,
            moviesList.first,
          ];

          return SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 400,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: displayMovies.length,
                    itemBuilder: (context, index) {
                      final movie = displayMovies[index];
                      bool isFavorite = Provider.of<FavouriteProvider>(context)
                          .isFavorite(movie); // Check if movie is favorite

                      double scale = (1 - ((_currentPage - index).abs() * 0.2))
                          .clamp(0.0, 1.0);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()..setEntry(3, 2, 0.001),
                          child: Opacity(
                            opacity: scale.clamp(0.5, 1.0),
                            child: Transform.scale(
                              scale: scale,
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: movie.imageUrlOriginal !=
                                                    null
                                                ? NetworkImage(
                                                    movie.imageUrlOriginal!)
                                                : const AssetImage(
                                                        'assets/placeholder.png')
                                                    as ImageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.4,
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.center,
                                              colors: [
                                                Colors.black,
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 60,
                                        left: 16,
                                        right: 16,
                                        child: Text(
                                          'Genre: ${movie.genres.join(', ')}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // My list container with onTap to add to favorites
                                      Positioned(
                                        bottom: 10,
                                        left: 45,
                                        child: GestureDetector(
                                          onTap: () {
                                            // Access the FavoritesProvider
                                            final favoritesProvider =
                                                Provider.of<FavouriteProvider>(
                                                    context,
                                                    listen: false);

                                            // Add or remove movie to favorites
                                            if (isFavorite) {
                                              favoritesProvider.removeFavorite(
                                                  movie); // Remove if already in favorites
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  '${movie.name} removed from favorites!',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor: Colors.red,
                                                duration:
                                                    const Duration(seconds: 2),
                                              ));
                                            } else {
                                              favoritesProvider.addFavorite(
                                                  movie); // Add if not in favorites
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content: Text(
                                                  '${movie.name} added to favorites!',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                backgroundColor: Colors.green,
                                                duration:
                                                    const Duration(seconds: 2),
                                              ));
                                            }
                                            setState(() {}); // Refresh the UI
                                          },
                                          child: Container(
                                            height: 45,
                                            width: 200,
                                            decoration: BoxDecoration(
                                              color: isFavorite
                                                  ? Colors.white
                                                      .withOpacity(0.7)
                                                  : Colors.white.withOpacity(
                                                      0.2), // Change color based on favorite status
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: isFavorite
                                                  ? const Text(
                                                      'Added to List',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  : const Text(
                                                      'My List',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
                Expanded(
                  child: ListView.builder(
                    itemCount: moviesList.length,
                    itemBuilder: (context, index) {
                      final movie = moviesList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Card(
                          color: const Color(0xFF2C2C2E),
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
