import 'package:flutter/material.dart';
import 'package:filmvault/models/movie_model.dart';
import 'package:filmvault/services/show_services.dart';

class SearchProvider with ChangeNotifier {
  final TextEditingController _searchController = TextEditingController();
  final ShowServices _showServices = ShowServices();

  List<ShowModel> _allShows = []; // Store all shows
  List<ShowModel> _searchResults = []; // Store search results
  bool _isLoading = false;
  String? _errorMessage;

  TextEditingController get searchController => _searchController;
  List<ShowModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SearchProvider() {
    _fetchAllShows(); // Fetch all shows when provider is created
  }

  void _fetchAllShows() async {
    _setLoading(true);
    try {
      final results = await _showServices.fetchMovies();
      _allShows = results; // Store all fetched shows
      _searchResults = results; // Initialize search results with all shows
      notifyListeners();
    } catch (error) {
      _errorMessage = 'Error fetching shows: ${error.toString()}';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void searchShows(String query) {
    if (query.isEmpty) {
      _searchResults = _allShows; // Reset to all shows if query is empty
    } else {
      _searchResults = _allShows.where((show) {
        return show.name.toLowerCase().contains(query.toLowerCase()) ||
            show.genres.any(
                (genre) => genre.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    }
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
