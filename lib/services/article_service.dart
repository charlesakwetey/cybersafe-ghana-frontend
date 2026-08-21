import 'dart:convert';
import '../models/article_model.dart';
import 'api_client.dart';

class ArticleService {
  static Future<List<Article>> getArticles() async {
    final response = await ApiClient.get('articles/', auth: false);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load articles');
    }
  }

  static Future<Article> getArticleDetail(int id) async {
    final response = await ApiClient.get('articles/$id/', auth: false);
    if (response.statusCode == 200) {
      return Article.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load article');
    }
  }
}