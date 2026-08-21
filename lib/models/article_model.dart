class Article {
  final int id;
  final String title;
  final String category;
  final String body;
  final String? imageUrl;
  final DateTime createdAt;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.body,
    this.imageUrl,
    required this.createdAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      body: json['body'],
      imageUrl: json['image'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}