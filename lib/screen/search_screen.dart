import 'package:filmvault/components/search_show_card.dart';
import 'package:filmvault/services/show_services.dart';
import 'package:flutter/material.dart';
import 'package:filmvault/models/movie_model.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ShowServices _showServices = ShowServices();
  List<ShowModel> _searchResults = [];
  List<ShowModel> _allShows = []; // List to store all shows
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAllShows(); // Fetch all shows on initialization
  }

  // Fetch all shows
  void _fetchAllShows() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset any previous error
    });

    try {
      final results = await _showServices.fetchMovies();
      setState(() {
        _allShows = results; // Store all shows
        _searchResults = results; // Show all results initially
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error fetching shows: ${error.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Search shows based on user input
  void _searchShows(String query) {
    setState(() {
      if (query.isEmpty) {
        // If the search query is empty, show all shows
        _searchResults = _allShows;
      } else {
        // Filter the shows based on the search query
        _searchResults = _allShows.where((show) {
          return show.name.toLowerCase().contains(query.toLowerCase()) ||
              show.genres.any(
                  (genre) => genre.toLowerCase().contains(query.toLowerCase()));
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 20), // Horizontal padding
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 100), // Adjust top padding as needed
              child: TextField(
                controller: _searchController,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  hintText: 'Search for shows...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () => _searchShows(_searchController.text),
                  ),
                ),
                onChanged: _searchShows, // Trigger search on text change
                onSubmitted: (_) => _searchShows(
                    _searchController.text), // Trigger search on submit
              ),
            ),
            if (_isLoading)
              Expanded(
                child: ListView.builder(
                  itemCount: 10, // Set the item count for shimmer
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey.shade800,
                      highlightColor: Colors.grey.shade600,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        height: 100, // Height of the shimmer effect
                        child: Row(
                          children: [
                            Container(
                              height: 100,
                              width: 80,
                              color: Colors.white, // Placeholder for image
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 20,
                                    color:
                                        Colors.white, // Placeholder for title
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 15,
                                    color:
                                        Colors.white, // Placeholder for genre
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            else if (_errorMessage != null)
              Center(
                child: Text(_errorMessage!,
                    style: const TextStyle(color: Colors.red)),
              )
            else if (_searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final show = _searchResults[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SearchShowCard(
                          url: show.imageUrlOriginal.toString(),
                          name: show.name,
                          genres: show.genres),
                    );
                  },
                ),
              )
            else
              const Center(
                  child: Text('No results found.',
                      style: TextStyle(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
