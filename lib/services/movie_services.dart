import 'dart:convert';
import 'package:filmvault/models/movie_model.dart';
import 'package:http/http.dart' as http;

class ShowServices {
  Future<List<ShowModel>> fetchMovies() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/shows'));

    if (response.statusCode == 200) {
      List<dynamic> showsJson = jsonDecode(response.body);
      return showsJson.map((json) => ShowModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load shows');
    }
  }
}
