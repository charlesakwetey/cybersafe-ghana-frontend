import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'token_storage.dart';
import '../main.dart';
import '../screens/auth/login_screen.dart';
import 'package:flutter/material.dart';

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

  /// Tries to get a new access token using the stored refresh token.
  /// Returns true if it succeeded, false otherwise.
  static Future<bool> _refreshToken() async {
    final refresh = await TokenStorage.getRefreshToken();
    if (refresh == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/token/refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refresh}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccess = data['access'];
        await TokenStorage.saveTokens(access: newAccess, refresh: refresh);
        return true;
      }
    } catch (e) {
      // network error while refreshing, treat as failure
    }
    return false;
  }

  /// Called when the refresh token itself is no longer valid.
  /// Clears local tokens and forces the user back to the login screen.
  static Future<void> _forceLogout() async {
    await TokenStorage.clearTokens();
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  /// Wraps any request. If it comes back 401 (token expired), tries to
  /// refresh the token once and retries. If refresh also fails, logs out.
  static Future<http.Response> _sendWithRefresh(
    Future<http.Response> Function() sendRequest,
  ) async {
    var response = await sendRequest();

    if (response.statusCode == 401) {
      final refreshed = await _refreshToken();
      if (refreshed) {
        response = await sendRequest();
      } else {
        await _forceLogout();
      }
    }

    return response;
  }

  static Future<http.Response> get(String endpoint, {bool auth = true}) async {
    return _sendWithRefresh(() async {
      final headers = await _headers(auth: auth);
      return http.get(Uri.parse('$baseUrl/$endpoint'), headers: headers);
    });
  }

  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    return _sendWithRefresh(() async {
      final headers = await _headers(auth: auth);
      return http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
    });
  }

  static Future<http.Response> patch(
    String endpoint,
    Map<String, dynamic> body, {
    bool auth = true,
  }) async {
    return _sendWithRefresh(() async {
      final headers = await _headers(auth: auth);
      return http.patch(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );
    });
  }

  static Future<http.Response> delete(
    String endpoint, {
    bool auth = true,
  }) async {
    return _sendWithRefresh(() async {
      final headers = await _headers(auth: auth);
      return http.delete(Uri.parse('$baseUrl/$endpoint'), headers: headers);
    });
  }

  static Future<http.Response> uploadFile(
    String endpoint,
    String fieldName,
    File file,
  ) async {
    return _sendWithRefresh(() async {
      final token = await TokenStorage.getAccessToken();
      final uri = Uri.parse('$baseUrl/$endpoint');
      final request = http.MultipartRequest('PATCH', uri);
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.files.add(
        await http.MultipartFile.fromPath(fieldName, file.path),
      );
      final streamedResponse = await request.send();
      return http.Response.fromStream(streamedResponse);
    });
  }
}
