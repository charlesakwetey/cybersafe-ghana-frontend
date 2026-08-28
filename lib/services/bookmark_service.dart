import 'dart:convert';
import '../models/bookmark_model.dart';
import 'api_client.dart';

class BookmarkService {
  static Future<List<ArticleBookmark>> getBookmarks() async {
    final response = await ApiClient.get('bookmarks/');
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => ArticleBookmark.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookmarks');
    }
  }

  static Future<int?> addBookmark(int articleId) async {
    final response = await ApiClient.post('bookmarks/', {'article': articleId});
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'];
    }
    return null;
  }

  static Future<bool> removeBookmark(int bookmarkId) async {
    final response = await ApiClient.delete('bookmarks/$bookmarkId/');
    return response.statusCode == 204;
  }
}