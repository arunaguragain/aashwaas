import 'dart:io';

import 'package:aashwaas/features/donation/presentation/state/donation_state.dart';
import 'package:aashwaas/features/donation/presentation/widgets/donation_photos_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:aashwaas/features/donation/presentation/widgets/donation_form_field.dart';
import 'package:aashwaas/features/donation/presentation/widgets/category_dropdown.dart';
import 'package:aashwaas/features/donation/presentation/widgets/condition_dropdown.dart';
import 'package:aashwaas/features/donation/presentation/view_model/donation_viewmodel.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:aashwaas/core/widgets/my_button.dart';

class EditDonationPage extends ConsumerStatefulWidget {
  final DonationEntity donation;
  const EditDonationPage({Key? key, required this.donation}) : super(key: key);

  @override
  ConsumerState<EditDonationPage> createState() => _EditDonationPageState();
}

class _EditDonationPageState extends ConsumerState<EditDonationPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController itemNameController;
  late TextEditingController descriptionController;
  late TextEditingController quantityController;
  late TextEditingController locationController;
  String? _selectedCategory;
  String? _selectedCondition;
  final List<File> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();
  bool _existingMediaCleared = false;

  List<String> categories = [
    'Clothes',
    'Books',
    'Electronics',
    'Furniture',
    'Food',
    'Other',
  ];
  List<String> conditions = ['New', 'Like New', 'Good', 'Fair'];

  @override
  void initState() {
    super.initState();
    final d = widget.donation;
    itemNameController = TextEditingController(text: d.itemName);
    descriptionController = TextEditingController(text: d.description ?? '');
    quantityController = TextEditingController(text: d.quantity);
    locationController = TextEditingController(text: d.pickupLocation);
    _selectedCategory = d.category;
    _selectedCondition = d.condition;
    // no local file initially; existing image available via widget.donation.media
  }

  @override
  void dispose() {
    itemNameController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    locationController.dispose();
    super.dispose();
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
        title: const Text("Permission Required"),
        content: const Text(
          "This feature requires permission to access your camera or gallery. Please enable it in your device settings.",
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

    final XFile? photo = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (photo != null) {
      setState(() {
        _selectedMedia.clear();
        _existingMediaCleared = true;
        _selectedMedia.add(File(photo.path));
      });
      await ref
          .read(donationViewModelProvider.notifier)
          .uploadPhoto(File(photo.path));
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedMedia.clear();
          _existingMediaCleared = true;
          _selectedMedia.add(File(image.path));
        });
        await ref
            .read(donationViewModelProvider.notifier)
            .uploadPhoto(File(image.path));
      }
    } catch (e) {
      debugPrint('Gallery Error $e');
      if (mounted) {
        MySnackbar.showError(
          context,
          'Unable to access gallery. Please try using the camera instead.',
        );
      }
    }
  }

  void _showMediaPicker() {
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
              'Add Photo',
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

  Future<void> _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      await ref
          .read(donationViewModelProvider.notifier)
          .updateDonation(
            donationId: widget.donation.donationId!,
            itemName: itemNameController.text.trim(),
            category: _selectedCategory!,
            description: descriptionController.text.trim(),
            quantity: quantityController.text.trim(),
            condition: _selectedCondition!,
            pickupLocation: locationController.text.trim(),
            media:
                ref.read(donationViewModelProvider).uploadedPhotoUrl ??
                widget.donation.media,
            donorId: widget.donation.donorId,
            status: widget.donation.status,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final donationState = ref.watch(donationViewModelProvider);
    ref.listen(donationViewModelProvider, (prev, next) {
      if (prev?.status != next.status) {
        if (next.status == DonationStatus.updated) {
          MySnackbar.showSuccess(context, 'Donation updated successfully');
          Navigator.of(context).pop();
        } else if (next.status == DonationStatus.error &&
            next.errorMessage != null) {
          MySnackbar.showError(context, next.errorMessage!);
        }
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Donation')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                DonationFormField(
                  label: 'Item Name *',
                  hintText: 'e.g., Winter Clothes Bundle',
                  controller: itemNameController,
                ),
                const SizedBox(height: 16),
                DonationCategoryDropdown(
                  label: 'Category *',
                  selectedCategory: _selectedCategory,
                  categories: categories,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DonationFormField(
                  label: 'Description',
                  hintText: 'Describe the items in detail...',
                  controller: descriptionController,
                  isMultiline: true,
                  isRequired: false,
                ),
                const SizedBox(height: 16),
                DonationFormField(
                  label: 'Quantity *',
                  hintText: 'e.g., 5 pieces',
                  controller: quantityController,
                ),
                const SizedBox(height: 16),
                DonationConditionDropdown(
                  label: 'Condition *',
                  selectedCondition: _selectedCondition,
                  conditions: conditions,
                  onChanged: (value) {
                    setState(() {
                      _selectedCondition = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DonationFormField(
                  label: 'Pickup Location *',
                  hintText: 'Enter your address...',
                  controller: locationController,
                ),
                const SizedBox(height: 16),
                DonationPhotosSection(
                  selectedMedia: _selectedMedia,
                  existingMediaUrl: _existingMediaCleared
                      ? null
                      : widget.donation.media,
                  onAddPhoto: _showMediaPicker,
                  onRemovePhoto: () {
                    setState(() {
                      _selectedMedia.clear();
                      _existingMediaCleared = true;
                    });
                    // Optionally clear uploaded URL in viewmodel if you add that action.
                  },
                ),
                const SizedBox(height: 30),
                MyButton(
                  text: 'Update Donation',
                  onPressed: donationState.status == DonationStatus.loading
                      ? null
                      : _handleUpdate,
                  isLoading: donationState.status == DonationStatus.loading,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
