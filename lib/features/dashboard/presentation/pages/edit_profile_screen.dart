import 'dart:io';

import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/core/widgets/my_textformfield.dart';
import 'package:aashwaas/features/auth/presentation/view_model/donor_auth_viewmodel.dart';
import 'package:aashwaas/features/auth/presentation/view_model/volunteer_auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imagePicker = ImagePicker();

  String? _profileImagePath;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final userSessionService = ref.read(userSessionServiceProvider);
    _fullNameController.text = userSessionService.getUserFullName() ?? '';
    _phoneController.text = userSessionService.getUserPhoneNumber() ?? '';
    _profileImagePath = userSessionService.getUserProfileImage();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      final userSessionService = ref.read(userSessionServiceProvider);
      final userId = userSessionService.getUserId();
      final role = userSessionService.getUserRoleSync() ?? 'donor';

      if (userId == null) {
        if (mounted) {
          MySnackbar.showError(context, 'User not found');
        }
        setState(() => _isSaving = false);
        return;
      }

      String? uploadedProfilePicture;
      if (_profileImagePath != null &&
          _profileImagePath!.trim().isNotEmpty &&
          !_profileImagePath!.startsWith('http')) {
        if (role == 'donor') {
          uploadedProfilePicture = await ref
              .read(authDonorViewmodelProvider.notifier)
              .uploadProfilePhoto(userId: userId, filePath: _profileImagePath!);
        } else {
          uploadedProfilePicture = await ref
              .read(authVolunteerViewmodelProvider.notifier)
              .uploadProfilePhoto(userId: userId, filePath: _profileImagePath!);
        }
        if (uploadedProfilePicture == null) {
          if (mounted) {
            MySnackbar.showError(context, 'Failed to upload photo');
          }
          setState(() => _isSaving = false);
          return;
        }
      }

      final isUpdated = role == 'donor'
          ? await ref
                .read(authDonorViewmodelProvider.notifier)
                .updateProfile(
                  userId: userId,
                  fullName: _fullNameController.text.trim(),
                  phoneNumber: _phoneController.text.trim(),
                  profilePicture: uploadedProfilePicture,
                )
          : await ref
                .read(authVolunteerViewmodelProvider.notifier)
                .updateProfile(
                  userId: userId,
                  fullName: _fullNameController.text.trim(),
                  phoneNumber: _phoneController.text.trim(),
                  profilePicture: uploadedProfilePicture,
                );

      if (!isUpdated) {
        if (mounted) {
          MySnackbar.showError(context, 'Failed to update profile');
        }
        setState(() => _isSaving = false);
        return;
      }

      final displayImage = uploadedProfilePicture == null
          ? userSessionService.getUserProfileImage()
          : (uploadedProfilePicture.startsWith('http')
                ? uploadedProfilePicture
                : ApiEndpoints.profilePicture(uploadedProfilePicture));

      await userSessionService.updateUserProfile(
        fullName: _fullNameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        profileImage: displayImage,
      );

      if (mounted) {
        MySnackbar.showSuccess(context, 'Profile updated');
        Navigator.pop(context);
      }
      setState(() => _isSaving = false);
    }
  }

  Future<void> _pickProfileImage() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _profileImagePath = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userSessionService = ref.watch(userSessionServiceProvider);
    final email = userSessionService.getUserEmail() ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      backgroundColor: const Color(0xFFF4F6FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE3E8EF)),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 44,
                          backgroundColor: const Color(0xFFF3F5F7),
                          backgroundImage: _resolvePreviewImage(
                            _profileImagePath,
                          ),
                          child:
                              _profileImagePath == null ||
                                  _profileImagePath!.trim().isEmpty
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.grey,
                                  size: 40,
                                )
                              : null,
                        ),
                        InkWell(
                          onTap: _pickProfileImage,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x22000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _pickProfileImage,
                      child: const Text('Change Photo'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE3E8EF)),
                ),
                child: Column(
                  children: [
                    MyTextformfield(
                      hintText: 'Enter your full name',
                      controller: _fullNameController,
                      labelText: 'Full Name',
                      errorMessage: 'Full name is required',
                    ),
                    const SizedBox(height: 16),
                    MyTextformfield(
                      hintText: 'Enter your phone number',
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      errorMessage: 'Phone number is required',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              MyButton(
                onPressed: _isSaving ? () {} : _handleSave,
                text: _isSaving ? 'Saving...' : 'Save Changes',
              ),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider<Object>? _resolvePreviewImage(String? imagePath) {
    if (imagePath == null || imagePath.trim().isEmpty) {
      return null;
    }
    final value = imagePath.trim();
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return NetworkImage(value);
    }
    final file = File(value);
    if (file.existsSync()) {
      return FileImage(file);
    }
    return null;
  }
}
