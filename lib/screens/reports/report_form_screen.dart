import 'package:flutter/material.dart';
import '../../models/report_model.dart';
import '../../services/report_service.dart';
import '../../utils/constants.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ReportFormScreen extends StatefulWidget {
  final Report? existingReport;

  const ReportFormScreen({super.key, this.existingReport});

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
  File? _pickedImage;
  bool _isUploadingEvidence = false;

  bool get _isEditing => widget.existingReport != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingReport;
    if (existing != null) {
      _descriptionController.text = existing.description;
      _suspectContactController.text = existing.suspectContact;
      _selectedScamType = existing.scamType;
      _selectedRegion = existing.region;
      _isAnonymous = existing.isAnonymous;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

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

      int reportId;
      if (_isEditing) {
        final updated = await ReportService.updateReport(
          widget.existingReport!.id!,
          report,
        );
        reportId = updated.id!;
      } else {
        final created = await ReportService.createReport(report);
        reportId = created.id!;
      }

      if (_pickedImage != null) {
        setState(() {
          _isUploadingEvidence = true;
        });
        await ReportService.uploadEvidence(reportId, _pickedImage!);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = _isEditing
            ? 'Failed to update report. Please try again.'
            : 'Failed to submit report. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _isUploadingEvidence = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Report' : 'Report a Scam')),
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
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Evidence Photo (optional)',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ),
              const SizedBox(height: 8),
              if (_pickedImage != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _pickedImage!,
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _pickedImage = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              else
                OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: const Text('Add Evidence Photo'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: AppColors.navy),
                  ),
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
                    : Text(_isEditing ? 'Save Changes' : 'Submit Report'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
