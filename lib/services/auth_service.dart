import 'dart:convert';
import 'api_client.dart';
import 'token_storage.dart';
import '../models/user_model.dart';
import 'dart:io';


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

  static Future<AppUser?> getCurrentUser() async {
    final response = await ApiClient.get('me/');
    if (response.statusCode == 200) {
      return AppUser.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<String?> uploadAvatar(File imageFile) async {
    final response = await ApiClient.uploadFile('me/avatar/', 'avatar', imageFile);
    if (response.statusCode == 200) {
      return null;
    } else {
      return 'Failed to upload photo';
    }
  }

  static Future<String?> updateRegion(String region) async {
    final response = await ApiClient.patch('me/', {'region': region});
    if (response.statusCode == 200) {
      return null;
    } else {
      return 'Failed to update region';
    }
  }
}
