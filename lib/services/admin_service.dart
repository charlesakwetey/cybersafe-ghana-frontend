import 'dart:convert';
import '../models/report_model.dart';
import 'api_client.dart';

class AdminStats {
  final int total;
  final int pending;
  final int verified;
  final int rejected;

  AdminStats({
    required this.total,
    required this.pending,
    required this.verified,
    required this.rejected,
  });

  factory AdminStats.fromJson(Map<String, dynamic> json) {
    return AdminStats(
      total: json['total'],
      pending: json['pending'],
      verified: json['verified'],
      rejected: json['rejected'],
    );
  }
}

class AdminService {
  static Future<AdminStats> getStats() async {
    final response = await ApiClient.get('admin/stats/');
    if (response.statusCode == 200) {
      return AdminStats.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load admin stats');
    }
  }

  static Future<List<Report>> getReports({String? status}) async {
    final endpoint = status != null
        ? 'admin/reports/?status=$status'
        : 'admin/reports/';
    final response = await ApiClient.get(endpoint);
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Report.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reports');
    }
  }

  static Future<bool> verifyReport(int id) async {
    final response = await ApiClient.post('admin/reports/$id/verify/', {});
    return response.statusCode == 200;
  }

  static Future<bool> rejectReport(int id) async {
    final response = await ApiClient.post('admin/reports/$id/reject/', {});
    return response.statusCode == 200;
  }
}
