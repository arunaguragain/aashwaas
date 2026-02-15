import 'dart:io';

import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/core/widgets/my_textformfield.dart';
import 'package:aashwaas/features/auth/presentation/view_model/donor_auth_viewmodel.dart';
import 'package:aashwaas/features/auth/presentation/view_model/volunteer_auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key, this.initialProfileImage});

  final String? initialProfileImage;

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
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();
    final userSessionService = ref.read(userSessionServiceProvider);
    _fullNameController.text = userSessionService.getUserFullName() ?? '';
    _phoneController.text = userSessionService.getUserPhoneNumber() ?? '';
    _profileImagePath =
        widget.initialProfileImage ?? userSessionService.getUserProfileImage();
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
      if (_profileImagePath != null && _profileImagePath!.trim().isNotEmpty) {
        // Only attempt to upload when the path points to a local file that exists.
        final file = File(_profileImagePath!);
        if (file.existsSync()) {
          if (role == 'donor') {
            uploadedProfilePicture = await ref
                .read(authDonorViewmodelProvider.notifier)
                .uploadProfilePhoto(
                  userId: userId,
                  filePath: _profileImagePath!,
                );
          } else {
            uploadedProfilePicture = await ref
                .read(authVolunteerViewmodelProvider.notifier)
                .uploadProfilePhoto(
                  userId: userId,
                  filePath: _profileImagePath!,
                );
          }
          if (uploadedProfilePicture == null) {
            if (mounted) {
              MySnackbar.showError(context, 'Failed to upload photo');
            }
            setState(() => _isSaving = false);
            return;
          }
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

  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    if (status.isDenied) {
      final result = await permission.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog();
      return false;
    }

    return false;
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'This feature requires permission to access your camera. Please enable it in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera() async {
    final hasPermission = await _requestPermission(Permission.camera);
    if (!hasPermission) return;

    await _pickImage(ImageSource.camera);
  }

  Future<void> _pickFromGallery() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_isPickingImage) {
      return;
    }
    setState(() => _isPickingImage = true);
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (picked != null && mounted) {
        setState(() {
          _profileImagePath = picked.path;
        });
      }
    } on PlatformException catch (_) {
      if (mounted) {
        MySnackbar.showError(context, 'Image picker is already open');
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Profile Photo',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.close, color: Colors.red),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userSessionService = ref.watch(userSessionServiceProvider);
    final email = userSessionService.getUserEmail() ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                          onBackgroundImageError: (error, stack) {},
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
                          onTap: _showImagePickerSheet,
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
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _showImagePickerSheet,
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
    if (value.contains('/')) {
      final normalized = value.startsWith('/') ? value.substring(1) : value;
      return NetworkImage('${ApiEndpoints.mediaServerUrl}/$normalized');
    }
    return NetworkImage(ApiEndpoints.profilePicture(value));
  }

  Widget _buildPreviewAvatar(String? imagePath) {
    final provider = _resolvePreviewImage(imagePath);
    if (provider == null) {
      return const Icon(Icons.person, color: Colors.grey, size: 40);
    }

    return ClipOval(
      child: Image(
        image: provider,
        width: 88,
        height: 88,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.person, color: Colors.grey, size: 40),
      ),
    );
  }
}
