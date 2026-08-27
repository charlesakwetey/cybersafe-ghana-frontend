import 'dart:convert';
import 'package:http/http.dart' as http;
import 'token_storage.dart';
import 'dart:io';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static Future<Map<String, String>> _headers({bool auth = true}) async {
    final headers = {'Content-Type': 'application/json'};
    if (auth) {
      final token = await TokenStorage.getAccessToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static Future<http.Response> get(String endpoint, {bool auth = true}) async {
    final headers = await _headers(auth: auth);
    return http.get(Uri.parse('$baseUrl/$endpoint'), headers: headers);
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body, {bool auth = true}) async {
    final headers = await _headers(auth: auth);
    return http.post(Uri.parse('$baseUrl/$endpoint'), headers: headers, body: jsonEncode(body));
  }

  static Future<http.Response> patch(String endpoint, Map<String, dynamic> body, {bool auth = true}) async {
    final headers = await _headers(auth: auth);
    return http.patch(Uri.parse('$baseUrl/$endpoint'), headers: headers, body: jsonEncode(body));
  }

  static Future<http.Response> delete(String endpoint, {bool auth = true}) async {
    final headers = await _headers(auth: auth);
    return http.delete(Uri.parse('$baseUrl/$endpoint'), headers: headers);
  }

  static Future<http.Response> uploadFile(
    String endpoint,
    String fieldName,
    File file,
  ) async {
    final token = await TokenStorage.getAccessToken();
    final uri = Uri.parse('$baseUrl/$endpoint');
    final request = http.MultipartRequest('PATCH', uri);
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));
    final streamedResponse = await request.send();
    return http.Response.fromStream(streamedResponse);
  }
}
