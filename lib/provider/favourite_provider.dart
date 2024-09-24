import 'package:filmvault/models/movie_model.dart';
import 'package:flutter/material.dart';

class FavouriteProvider extends ChangeNotifier {
  final List<ShowModel> _favoriteMovies = [];

  List<ShowModel> get favoriteMovies => _favoriteMovies;

  void addFavorite(ShowModel movie) {
    _favoriteMovies.add(movie);
    notifyListeners();
  }

  void removeFavorite(ShowModel movie) {
    _favoriteMovies.remove(movie);
    notifyListeners();
  }

  bool isFavorite(ShowModel movie) {
    return _favoriteMovies.any((fav) => fav.id == movie.id); // Check using ID
  }

  // Toggle method to add/remove movie from favorites
  void toggleFavorite(ShowModel movie) {
    if (isFavorite(movie)) {
      removeFavorite(movie);
    } else {
      addFavorite(movie);
    }
  }

  //clear the list
  void clearFavourites() {
    _favoriteMovies.clear();
    notifyListeners();
  }
}
