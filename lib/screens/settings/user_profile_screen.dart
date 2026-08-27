import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../../utils/constants.dart';

class UserProfileScreen extends StatefulWidget {
  final AppUser user;

  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late String _selectedRegion;
  bool _isSaving = false;
  bool _isUploadingPhoto = false;
  File? _pickedImage;
  String? _message;

  @override
  void initState() {
    super.initState();
    _selectedRegion = widget.user.region.isNotEmpty
        ? widget.user.region
        : GhanaRegions.all.first;
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      imageQuality: 80,
    );
    if (picked == null) return;

    setState(() {
      _pickedImage = File(picked.path);
      _isUploadingPhoto = true;
      _message = null;
    });

    final error = await AuthService.uploadAvatar(_pickedImage!);

    setState(() {
      _isUploadingPhoto = false;
      _message = error ?? 'Photo updated!';
    });
  }

  Future<void> _saveRegion() async {
    setState(() {
      _isSaving = true;
      _message = null;
    });

    final error = await AuthService.updateRegion(_selectedRegion);

    setState(() {
      _isSaving = false;
      _message = error ?? 'Region updated!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: _pickedImage != null
                      ? FileImage(_pickedImage!)
                      : (widget.user.avatarUrl != null
                          ? NetworkImage(widget.user.avatarUrl!)
                          : null) as ImageProvider?,
                  child: (_pickedImage == null && widget.user.avatarUrl == null)
                      ? const Icon(Icons.person, size: 56, color: Colors.white)
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _isUploadingPhoto ? null : _pickAndUploadImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: _isUploadingPhoto
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _ProfileField(label: 'Username', value: widget.user.username),
            const SizedBox(height: 16),
            _ProfileField(
              label: 'Email',
              value: widget.user.email.isNotEmpty ? widget.user.email : 'Not set',
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Region',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: _selectedRegion,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: GhanaRegions.all
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRegion = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            if (_message != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(_message!),
              ),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveRegion,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
              ),
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}