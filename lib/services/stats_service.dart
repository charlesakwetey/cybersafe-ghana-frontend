import 'dart:convert';
import '../models/report_model.dart';
import 'api_client.dart';

class StatsService {
  static Future<List<Map<String, dynamic>>> getStatsByType() async {
    final response = await ApiClient.get('stats/', auth: false);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load stats');
    }
  }

  static Future<List<Map<String, dynamic>>> getStatsByRegion() async {
    final response = await ApiClient.get('stats/by-region/', auth: false);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load region stats');
    }
  }

  static Future<List<Report>> getVerifiedReports() async {
    final response = await ApiClient.get('verified-reports/', auth: false);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Report.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load verified reports');
    }
  }
}