class HealthyArticle {
  final String title;
  final String source;
  final String category;
  final String articleUrl;

  HealthyArticle({
    required this.title,
    required this.source,
    required this.category,
    required this.articleUrl,
  });

  factory HealthyArticle.fromMap(
    Map<String, dynamic> data,
  ) {
    return HealthyArticle(
      title: data['title'] ?? '',
      source: data['source'] ?? '',
      category: data['category'] ?? '',
      articleUrl: data['articleUrl'] ?? '',
    );
  }
}