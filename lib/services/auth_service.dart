import 'dart:convert';
import 'api_client.dart';
import 'token_storage.dart';

class AuthService {
  static Future<String?> login(String username, String password) async {
    final response = await ApiClient.post('token/', {
      'username': username,
      'password': password,
    }, auth: false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await TokenStorage.saveTokens(
        access: data['access'],
        refresh: data['refresh'],
      );
      return null;
    } else {
      return 'Error ${response.statusCode}: ${response.body}';
    }
  }

  static Future<String?> signup({
    required String username,
    required String email,
    required String password,
    required String region,
  }) async {
    final response = await ApiClient.post('signup/', {
      'username': username,
      'email': email,
      'password': password,
      'region': region,
    }, auth: false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      await TokenStorage.saveTokens(
        access: data['access'],
        refresh: data['refresh'],
      );
      return null;
    } else {
      final data = jsonDecode(response.body);
      return data.values.first.toString();
    }
  }

  static Future<void> logout() async {
    await TokenStorage.clearTokens();
  }
}
