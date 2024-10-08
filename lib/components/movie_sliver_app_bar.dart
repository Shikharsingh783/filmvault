import 'package:filmvault/models/movie_model.dart';
import 'package:filmvault/provider/favourite_provider.dart';
import 'package:filmvault/screen/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'glass_snackbar.dart';
import 'package:flutter/services.dart';

class MovieSliverAppBar extends StatefulWidget {
  final PageController pageController;
  final List<ShowModel> displayMovies;

  const MovieSliverAppBar({
    Key? key,
    required this.pageController,
    required this.displayMovies,
  }) : super(key: key);

  @override
  State<MovieSliverAppBar> createState() => _MovieSliverAppBarState();
}

class _MovieSliverAppBarState extends State<MovieSliverAppBar> {
  double _currentPage = 0;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      setState(() {
        _currentPage = widget.pageController.page ?? 0;
        _scrollOffset = widget.pageController.offset; // Update scroll offset
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: 400,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.transparent,
          child: PageView.builder(
            controller: widget.pageController,
            itemCount: widget.displayMovies.length,
            itemBuilder: (context, index) {
              final movie = widget.displayMovies[index];
              bool isFavorite =
                  Provider.of<FavouriteProvider>(context).isFavorite(movie);

              double scale =
                  (1 - ((_currentPage - index).abs() * 0.2)).clamp(0.0, 1.0);

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
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailScreen(
                                              image: movie.imageUrlOriginal
                                                  .toString(),
                                              title: movie.name,
                                              description: movie.summary,
                                              rating: movie.rating,
                                              genres: movie.genres,
                                              ended: movie.ended,
                                              premiered: movie.premiered,
                                              displayMovie: movie,
                                              scheduleTime:
                                                  movie.scheduleTime.toString(),
                                              scheduleDays:
                                                  movie.scheduleDays!)));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: movie.imageUrlOriginal != null
                                          ? NetworkImage(
                                              movie.imageUrlOriginal!)
                                          : const AssetImage(
                                                  'assets/placeholder.png')
                                              as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
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
                              Positioned(
                                bottom: 10,
                                left: 45,
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.heavyImpact();
                                    final favoritesProvider =
                                        Provider.of<FavouriteProvider>(context,
                                            listen: false);
                                    if (isFavorite) {
                                      favoritesProvider.removeFavorite(movie);
                                      final snackBar = GlassSnackBar(
                                        text:
                                            '${movie.name} removed from favorites!',
                                      ).build();
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                    } else {
                                      favoritesProvider.addFavorite(movie);
                                      final snackBar = GlassSnackBar(
                                        text:
                                            '${movie.name} Added to favorites!',
                                      ).build();
                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                    }
                                  },
                                  child: Container(
                                    height: 45,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: isFavorite
                                          ? Colors.white.withOpacity(0.7)
                                          : Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: isFavorite
                                          ? const Text(
                                              'Added to List',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : const Text(
                                              'My List',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
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
      ),
      // bottom: PreferredSize(
      //   preferredSize: Size.fromHeight(40), // Height of the bottom widget
      //   child: Container(
      //     color: Colors.black54, // Background color of the bottom widget
      //     child: Visibility(
      //       visible: _scrollOffset >= 400, // Show when collapsed
      //       child: const Center(
      //         child: Text(
      //           'Swipe down for more details',
      //           style: TextStyle(color: Colors.red, fontSize: 16),
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
