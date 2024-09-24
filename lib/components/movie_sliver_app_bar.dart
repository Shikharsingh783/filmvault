import 'package:filmvault/models/movie_model.dart';
import 'package:filmvault/provider/favourite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(() {
      setState(() {
        _currentPage = widget.pageController.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.transparent, // Color for the collapsed bar
      expandedHeight: 400,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.transparent, // Transparent color for expanded state
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
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: movie.imageUrlOriginal != null
                                        ? NetworkImage(movie.imageUrlOriginal!)
                                        : const AssetImage(
                                                'assets/placeholder.png')
                                            as ImageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              //gradient container
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
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
                                    final favoritesProvider =
                                        Provider.of<FavouriteProvider>(context,
                                            listen: false);
                                    if (isFavorite) {
                                      favoritesProvider.removeFavorite(movie);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          '${movie.name} removed from favorites!',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        backgroundColor: Colors.red,
                                        duration: const Duration(seconds: 2),
                                      ));
                                    } else {
                                      favoritesProvider.addFavorite(movie);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          '${movie.name} added to favorites!',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: const Duration(seconds: 2),
                                      ));
                                    }
                                    setState(() {});
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
      ),
    );
  }
}
