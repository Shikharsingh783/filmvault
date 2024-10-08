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
  final String premiered;
  final String ended;
  final String? scheduleTime;
  final List<String>? scheduleDays;

  ShowModel({
    required this.premiered,
    required this.ended,
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
    this.scheduleTime,
    this.scheduleDays,
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
      ended: json['ended'] ?? 'N/A',
      premiered: json['premiered'] ?? 'N/A',
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
      scheduleTime: json['schedule']['time'] ?? 'N/A',
      scheduleDays: json['schedule']?['days'] != null
          ? List<String>.from(json['schedule']['days']) // Fetch schedule days
          : null,
    );
  }
}
