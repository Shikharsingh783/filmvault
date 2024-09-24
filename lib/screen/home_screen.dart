import 'dart:async';
import 'package:filmvault/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:filmvault/screen/detail_screen.dart';
import 'package:filmvault/provider/show_provider.dart';
import 'package:filmvault/components/movie_sliver_app_bar.dart'; // Import your new component

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.72);
  Timer? _timer;
  late Future<List<ShowModel>> futureMovies;
  List<ShowModel> displayMovies = []; // Store displayMovies here

  @override
  void initState() {
    super.initState();
    futureMovies =
        Provider.of<ShowProvider>(context, listen: false).fetchMovies();

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      _nextPage();
    });
  }

  void _nextPage() {
    int nextPage = (_pageController.page!.round() + 1) %
        (displayMovies.length); // Use displayMovies.length
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
      backgroundColor: Colors.black,
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
          displayMovies = [
            moviesList.last,
            ...moviesList,
            moviesList.first,
          ];

          // Grouping movies by genres
          Map<String, List<ShowModel>> genreGroups = {};
          for (var movie in moviesList) {
            for (var genre in movie.genres) {
              if (!genreGroups.containsKey(genre)) {
                genreGroups[genre] = [];
              }
              genreGroups[genre]!.add(movie);
            }
          }

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                MovieSliverAppBar(
                  pageController: _pageController,
                  displayMovies: displayMovies,
                ),

                // Iterate over the grouped genres
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      // Get genre name from keys
                      String genreName = genreGroups.keys.elementAt(index);
                      List<ShowModel> moviesInGenre = genreGroups[genreName]!;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Genre Header
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                genreName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            // Movies Horizontal List
                            SizedBox(
                              height: 200, // Fixed height for movie list
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: moviesInGenre.length,
                                itemBuilder: (context, movieIndex) {
                                  final movie = moviesInGenre[movieIndex];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                            displayMovie: movie,
                                            ended: movie.ended,
                                            premiered: movie.premiered,
                                            genres: movie.genres,
                                            image: movie.imageUrlOriginal!,
                                            title: movie.name,
                                            description: movie.summary,
                                            rating: movie.rating,
                                          ),
                                        ));
                                      },
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Container(
                                          width:
                                              140, // Fixed width for movie item
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  movie.imageUrlMedium ?? ''),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .end, // Align title to the bottom
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 4),
                                                child: Text(
                                                  movie
                                                      .name, // Display movie name
                                                  style: const TextStyle(
                                                    color: Colors.white54,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                  textAlign: TextAlign
                                                      .center, // Center the title text
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                    childCount: genreGroups.length,
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
