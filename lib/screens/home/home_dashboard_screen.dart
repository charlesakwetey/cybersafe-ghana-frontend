import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/report_model.dart';
import '../../services/stats_service.dart';
import '../../utils/constants.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  List<Map<String, dynamic>>? _typeStats;
  List<Report>? _verifiedReports;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final results = await Future.wait([
        StatsService.getStatsByType(),
        StatsService.getVerifiedReports(),
      ]);
      setState(() {
        _typeStats = results[0] as List<Map<String, dynamic>>;
        _verifiedReports = results[1] as List<Report>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load dashboard data';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CyberSafe Ghana'),
      ),
      body: RefreshIndicator(onRefresh: _loadData, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: AppColors.danger),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Reported Scams by Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.ghanaGold
                : AppColors.navy,
          ),
        ),
        const SizedBox(height: 12),
        _buildChart(),
        const SizedBox(height: 28),
        Text(
          'Recently Verified Scams',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.ghanaGold
                : AppColors.navy,
          ),
        ),
        const SizedBox(height: 12),
        _buildVerifiedFeed(),
      ],
    );
  }

  Color _colorFor(String category) {
    switch (category) {
      case 'mobile_money':
        return AppColors.danger;
      case 'phishing':
        return AppColors.warning;
      case 'sim_swap':
        return AppColors.navy;
      case 'romance_scam':
        return AppColors.success;
      case 'job_scam':
        return AppColors.jobScamPurple;
      default:
        return AppColors.charcoal;
    }
  }

  Widget _buildChart() {
    if (_typeStats == null || _typeStats!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text('No report data yet.')),
      );
    }

    final maxCount = _typeStats!
        .map((s) => s['count'] as int)
        .reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (maxCount + 1).toDouble(),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  if (value != value.roundToDouble()) return const SizedBox.shrink();
                  final textColor = Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87;
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(fontSize: 11, color: textColor),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= _typeStats!.length) {
                    return const SizedBox.shrink();
                  }
                  final label = ScamTypes.labelFor(
                    _typeStats![index]['scam_type'],
                  );
                  final shortLabel = label.split(' ').first;
                  final textColor = Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black87;
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(shortLabel, style: TextStyle(fontSize: 10, color: textColor)),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: List.generate(_typeStats!.length, (index) {
            final count = _typeStats![index]['count'] as int;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: count.toDouble(),
                  color: _colorFor(_typeStats![index]['scam_type'] as String),
                  width: 22,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildVerifiedFeed() {
    if (_verifiedReports == null || _verifiedReports!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text('No verified scams reported yet.'),
      );
    }

    return Column(
      children: _verifiedReports!
          .map((report) => _VerifiedReportCard(report: report))
          .toList(),
    );
  }
}

class _VerifiedReportCard extends StatelessWidget {
  final Report report;

  const _VerifiedReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified, color: AppColors.success, size: 18),
                const SizedBox(width: 6),
                Text(
                  ScamTypes.labelFor(report.scamType),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              report.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  report.region,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (report.suspectContact.isNotEmpty) ...[
                  const Text(' • ', style: TextStyle(color: Colors.grey)),
                  Expanded(
                    child: Text(
                      report.suspectContact,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
