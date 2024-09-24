import 'package:filmvault/models/movie_model.dart';
import 'package:filmvault/services/movie_services.dart';
import 'package:flutter/material.dart';

class ShowProvider extends ChangeNotifier {
  List<ShowModel> _movies = [];
  bool _isLoading = false;
  final ShowServices _services = ShowServices();

  List<ShowModel> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> fetchMovies() async {
    if (_movies.isNotEmpty) return; // Prevent fetching if already loaded

    _isLoading = true;
    notifyListeners(); // Notify listeners for loading state

    try {
      _movies = await _services.fetchMovies();
    } catch (e) {
      // Handle errors as needed
      _movies = [];
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners after fetching
    }
  }
}
