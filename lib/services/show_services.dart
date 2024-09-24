import 'dart:convert';
import 'package:filmvault/models/movie_model.dart';
import 'package:http/http.dart' as http;

class ShowServices {
  // Fetch all movies
  Future<List<ShowModel>> fetchMovies() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/shows'));

    if (response.statusCode == 200) {
      List<dynamic> showsJson = jsonDecode(response.body);
      return showsJson.map((json) => ShowModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load shows');
    }
  }

  // Search for shows based on a search term
  Future<List<ShowModel>> searchShows(String searchTerm) async {
    //trimming the search text
    final trimmedSearchTerm = searchTerm.trim();
    final response = await http.get(
      Uri.parse('https://api.tvmaze.com/search/shows?q=$trimmedSearchTerm'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ShowModel.fromJson(json['show'])).toList();
    } else {
      throw Exception('Error searching shows');
    }
  }
}
