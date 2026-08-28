import 'article_model.dart';

class ArticleBookmark {
  final int id;
  final Article article;

  ArticleBookmark({required this.id, required this.article});

  factory ArticleBookmark.fromJson(Map<String, dynamic> json) {
    return ArticleBookmark(
      id: json['id'],
      article: Article.fromJson(json['article_detail']),
    );
  }
}