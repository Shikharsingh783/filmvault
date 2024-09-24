class MovieModel {
  final String name;
  final String url;
  final String language;
  final String summary;
  final String status;
  final String? imageUrlMedium;
  final String? imageUrlOriginal;
  final List<String> genres;
  final double rating;

  MovieModel({
    required this.name,
    required this.rating,
    required this.url,
    required this.language,
    required this.summary,
    required this.status,
    this.imageUrlMedium, // Handle nullable image URL
    this.imageUrlOriginal, // Handle nullable image URL
    required this.genres,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      name: json['name'],
      rating: json['rating']['average'],
      url: json['url'],
      language: json['language'],
      summary: json['summary'],
      status: json['status'],
      imageUrlMedium: json['image']?['medium'],
      imageUrlOriginal: json['image']?['original'],
      genres: List<String>.from(json['genres']),
    );
  }
}
