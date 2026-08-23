import 'package:flutter/material.dart';
import '../../models/report_model.dart';
import '../../services/report_service.dart';
import '../../utils/constants.dart';

class ReportFormScreen extends StatefulWidget {
  const ReportFormScreen({super.key});

  @override
  State<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends State<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _suspectContactController = TextEditingController();

  String? _selectedScamType;
  String? _selectedRegion;
  bool _isAnonymous = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedScamType == null || _selectedRegion == null) {
      setState(() {
        _errorMessage = 'Please select a scam type and region';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final report = Report(
        scamType: _selectedScamType!,
        description: _descriptionController.text.trim(),
        suspectContact: _suspectContactController.text.trim(),
        region: _selectedRegion!,
        isAnonymous: _isAnonymous,
      );
      await ReportService.createReport(report);

      if (mounted) {
        Navigator.pop(context, true); // true signals "a report was created"
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to submit report. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report a Scam'),
     ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedScamType,
                decoration: const InputDecoration(
                  labelText: 'Scam Type',
                  border: OutlineInputBorder(),
                ),
                items: ScamTypes.all
                    .map(
                      (type) => DropdownMenuItem(
                        value: type['value'],
                        child: Text(type['label']!),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedScamType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'What happened?',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please describe what happened';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _suspectContactController,
                decoration: const InputDecoration(
                  labelText: 'Suspect Phone/Account (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedRegion,
                decoration: const InputDecoration(
                  labelText: 'Region',
                  border: OutlineInputBorder(),
                ),
                items: GhanaRegions.all
                    .map(
                      (region) =>
                          DropdownMenuItem(value: region, child: Text(region)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRegion = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Submit anonymously'),
                subtitle: const Text(
                  'Your identity will be hidden from the public feed',
                ),
                value: _isAnonymous,
                activeThumbColor: AppColors.navy,
                onChanged: (value) {
                  setState(() {
                    _isAnonymous = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: AppColors.danger),
                  ),
                ),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Submit Report'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}