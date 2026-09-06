import 'package:flutter/material.dart';
import '../../models/report_model.dart';
import '../../services/admin_service.dart';
import '../../utils/constants.dart';

class AdminReportDetailScreen extends StatefulWidget {
  final Report report;

  const AdminReportDetailScreen({super.key, required this.report});

  @override
  State<AdminReportDetailScreen> createState() =>
      _AdminReportDetailScreenState();
}

class _AdminReportDetailScreenState extends State<AdminReportDetailScreen> {
  late Report _report;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _report = widget.report;
  }

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

  Future<void> _handleVerify() async {
    setState(() => _isProcessing = true);
    final success = await AdminService.verifyReport(_report.id!);
    if (success && mounted) {
      Navigator.pop(context, true);
    } else {
      setState(() => _isProcessing = false);
    }
  }

  Future<void> _handleReject() async {
    setState(() => _isProcessing = true);
    final success = await AdminService.rejectReport(_report.id!);
    if (success && mounted) {
      Navigator.pop(context, true);
    } else {
      setState(() => _isProcessing = false);
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
                    ScamTypes.labelFor(_report.scamType),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(_report.status).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _report.status.toUpperCase(),
                    style: TextStyle(
                      color: _statusColor(_report.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  _report.reporterUsername ?? 'Unknown user',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_report.isAnonymous) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Anonymous to public',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            _DetailRow(label: 'Description', value: _report.description),
            const SizedBox(height: 16),
            _DetailRow(label: 'Region', value: _report.region),
            if (_report.suspectContact.isNotEmpty) ...[
              const SizedBox(height: 16),
              _DetailRow(
                label: 'Suspect / Business Details',
                value: _report.suspectContact,
              ),
            ],
            if (_report.createdAt != null) ...[
              const SizedBox(height: 16),
              _DetailRow(
                label: 'Submitted on',
                value:
                    '${_report.createdAt!.day}/${_report.createdAt!.month}/${_report.createdAt!.year}',
              ),
            ],
            if (_report.evidenceUrl != null) ...[
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Evidence Photo',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  _report.evidenceUrl!,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const SizedBox(
                      height: 240,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 240,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.broken_image_outlined),
                    ),
                  ),
                ),
              ),
            ],
            if (_report.status == 'pending') ...[
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isProcessing ? null : _handleReject,
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: AppColors.danger,
                      ),
                      label: Text(
                        'Reject',
                        style: TextStyle(color: AppColors.danger),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.danger),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _handleVerify,
                      icon: const Icon(
                        Icons.check,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: _isProcessing
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Verify',
                              style: TextStyle(color: Colors.white),
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
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
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}
