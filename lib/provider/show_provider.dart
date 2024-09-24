import 'package:filmvault/models/movie_model.dart';
import 'package:filmvault/services/show_services.dart';
import 'package:flutter/material.dart';

class ShowProvider extends ChangeNotifier {
  List<ShowModel> _movies = [];
  bool _isLoading = false;
  final ShowServices _services = ShowServices();

  List<ShowModel> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<List<ShowModel>> fetchMovies() async {
    // Check if the movies list is already populated
    if (_movies.isNotEmpty) return _movies;

    _isLoading = true;
    notifyListeners(); // Notify listeners to show loading state

    try {
      // Fetch movies from the service
      _movies = await _services.fetchMovies();
    } catch (e) {
      // Handle the error if fetching fails
      _movies = [];
      // Optionally: handle logging or showing error messages
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners to update UI
    }

    // Return the list of fetched movies
    return _movies;
  }
}
