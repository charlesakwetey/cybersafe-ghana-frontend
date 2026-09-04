import 'dart:convert';
import '../models/report_model.dart';
import 'api_client.dart';
import 'dart:io';

class ReportService {
  static Future<List<Report>> getReports() async {
    final response = await ApiClient.get('reports/');
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Report.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reports');
    }
  }

  static Future<Report> createReport(Report report) async {
    final response = await ApiClient.post('reports/', report.toJson());
    if (response.statusCode == 201) {
      return Report.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create report: ${response.body}');
    }
  }

  static Future<void> deleteReport(int id) async {
    final response = await ApiClient.delete('reports/$id/');
    if (response.statusCode != 204) {
      throw Exception('Failed to delete report');
    }
  }

  static Future<Report> updateReport(int id, Report report) async {
    final response = await ApiClient.patch('reports/$id/', report.toJson());
    if (response.statusCode == 200) {
      return Report.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update report: ${response.body}');
    }
  }

  static Future<bool> uploadEvidence(int reportId, File imageFile) async {
    final response = await ApiClient.uploadFile(
      'reports/$reportId/',
      'evidence',
      imageFile,
    );
    return response.statusCode == 200;
  }
}
