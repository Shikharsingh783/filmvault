import 'package:filmvault/components/show_tile.dart';
import 'package:filmvault/screen/detail_screen.dart';
import 'package:filmvault/services/movie_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<ShowModel>> movies;
  ShowServices services = ShowServices();

  @override
  void initState() {
    super.initState();
    movies = services.fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FilmVault',
          style: TextStyle(fontFamily: 'Cascadia'),
        ),
      ),
      body: FutureBuilder<List<ShowModel>>(
        future: movies,
        builder: (context, snapshot) {
          // Handle loading and error states
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching movies.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No movies found.'));
          }

          // If data is available, render the ListView
          final List<ShowModel> movies = snapshot.data!;

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];

              return ListTile(
                leading: movie.imageUrlMedium != null
                    ? Image.network(
                        movie.imageUrlMedium!,
                        width: 50,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : const Icon(Icons.movie), // Placeholder for missing image
                title: Text(movie.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(movie.status), // Display movie status
                    Text(
                        'Genres: ${movie.genres.join(', ')}'), // Display genres
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailScreen(
                            image: movie.imageUrlOriginal!,
                            title: movie.name,
                            description: movie.summary,
                            rating: movie.rating,
                          )));
                },
              );
            },
          );
        },
      ),
    );
  }
}
