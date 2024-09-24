class MovieModel {
  final String name;
  final String url;
  final String language;
  final String summary;
  final String status;
  final String imageUrl;
  final List<String> genres;

  MovieModel({
    required this.name,
    required this.url,
    required this.language,
    required this.summary,
    required this.status,
    required this.imageUrl,
    required this.genres,
  });
}
