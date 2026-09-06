import 'package:flutter/material.dart';
import '../../models/report_model.dart';
import '../../utils/constants.dart';

class PublicReportDetailScreen extends StatelessWidget {
  final Report report;

  const PublicReportDetailScreen({super.key, required this.report});

  Color _statusColor(String status) {
    switch (status) {
      case 'verified':
        return AppColors.success;
      case 'rejected':
        return AppColors.danger;
      default:
        return AppColors.warning;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Report Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    ScamTypes.labelFor(report.scamType),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor(report.status).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.verified, size: 14, color: _statusColor(report.status)),
                      const SizedBox(width: 4),
                      Text(
                        report.status.toUpperCase(),
                        style: TextStyle(
                          color: _statusColor(report.status),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  report.isAnonymous ? Icons.visibility_off_outlined : Icons.person_outline,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  report.isAnonymous
                      ? 'Reported anonymously'
                      : 'Reported by ${report.reporterUsername ?? "a user"}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _DetailRow(label: 'Description', value: report.description),
            const SizedBox(height: 16),
            _DetailRow(label: 'Region', value: report.region),
            if (report.suspectContact.isNotEmpty) ...[
              const SizedBox(height: 16),
              _DetailRow(label: 'Suspect Contact', value: report.suspectContact),
            ],
            if (report.createdAt != null) ...[
              const SizedBox(height: 16),
              _DetailRow(
                label: 'Reported on',
                value: '${report.createdAt!.day}/${report.createdAt!.month}/${report.createdAt!.year}',
              ),
            ],
            if (report.evidenceUrl != null) ...[
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Evidence Photo',
                  style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  report.evidenceUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey.shade300,
                      child: const Center(child: Icon(Icons.broken_image_outlined)),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}