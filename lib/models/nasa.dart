class NasaApod {
  final String date;
  final String explanation;
  final String title;
  final String url;
  final String mediaType;

  NasaApod({
    required this.date,
    required this.explanation,
    required this.title,
    required this.url,
    required this.mediaType,
  });

  factory NasaApod.fromJson(Map<String, dynamic> json) {
    return NasaApod(
      date: json['date'] ?? '',
      explanation: json['explanation'] ?? '',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      mediaType: json['media_type'] ?? '',
    );
  }
}