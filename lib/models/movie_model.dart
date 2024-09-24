class ShowModel {
  final int id;
  final String name;
  final double rating;
  final String url;
  final String language;
  final String summary;
  final String status;
  final String? imageUrlMedium;
  final String? imageUrlOriginal;
  final List<String> genres;

  ShowModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.url,
    required this.language,
    required this.summary,
    required this.status,
    this.imageUrlMedium,
    this.imageUrlOriginal,
    required this.genres,
  });

  // Static method to remove HTML tags from a string
  static String _removeHtmlTags(String htmlString) {
    final RegExp exp =
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
    return htmlString.replaceAll(exp, '');
  }

  factory ShowModel.fromJson(Map<String, dynamic> json) {
    return ShowModel(
      id: json['id'],
      name: json['name'],
      rating: json['rating']?['average']?.toDouble() ?? 0,
      url: json['url'] ?? '',
      language: json['language'] ?? 'Unknown',
      summary: json['summary'] != null
          ? ShowModel._removeHtmlTags(json['summary'])
          : 'No summary available',
      status: json['status'] ?? 'Unknown',
      imageUrlMedium: json['image']?['medium'],
      imageUrlOriginal: json['image']?['original'],
      genres: List<String>.from(json['genres']),
    );
  }
}
