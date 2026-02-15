import 'dart:io';

import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/donation/presentation/view_model/donation_viewmodel.dart';
import 'package:aashwaas/features/donation/presentation/state/donation_state.dart';
import 'package:aashwaas/features/donation/presentation/widgets/donation_form_field.dart';
import 'package:aashwaas/features/donation/presentation/widgets/category_dropdown.dart';
import 'package:aashwaas/features/donation/presentation/widgets/condition_dropdown.dart';
import 'package:aashwaas/features/donation/presentation/widgets/donation_photos_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddDonationScreen extends ConsumerStatefulWidget {
  final String? initialItemName;
  final String? initialCategory;
  final String? initialDescription;
  final String? initialQuantity;
  final String? initialCondition;
  final String? initialPickupLocation;
  final VoidCallback? onDonationCreated;

  const AddDonationScreen({
    super.key,
    this.initialItemName,
    this.initialCategory,
    this.initialDescription,
    this.initialQuantity,
    this.initialCondition,
    this.initialPickupLocation,
    this.onDonationCreated,
  });

  @override
  ConsumerState<AddDonationScreen> createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends ConsumerState<AddDonationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _itemNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedCategory;
  String? _selectedCondition;
  final List<File> _selectedMedia = [];
  final ImagePicker _imagePicker = ImagePicker();
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
    // If initial values provided, populate controllers and selections
    final widgetInitial = widget as AddDonationScreen;
    if (widgetInitial.initialItemName != null) {
      _itemNameController.text = widgetInitial.initialItemName!;
    }
    if (widgetInitial.initialDescription != null) {
      _descriptionController.text = widgetInitial.initialDescription!;
    }
    if (widgetInitial.initialQuantity != null) {
      _quantityController.text = widgetInitial.initialQuantity!;
    }
    if (widgetInitial.initialPickupLocation != null) {
      _locationController.text = widgetInitial.initialPickupLocation!;
    }
    if (widgetInitial.initialCategory != null) {
      _selectedCategory = widgetInitial.initialCategory;
    }
    if (widgetInitial.initialCondition != null) {
      _selectedCondition = widgetInitial.initialCondition;
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
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
        _selectedMedia.add(File(photo.path));
      });
      await ref
          .read(donationViewModelProvider.notifier)
          .uploadPhoto(File(photo.path));
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

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedMedia.clear();
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

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategory == null || _selectedCategory!.isEmpty) {
        MySnackbar.showError(context, 'Please select a category');
        return;
      }

      if (_selectedCondition == null || _selectedCondition!.isEmpty) {
        MySnackbar.showError(context, 'Please select condition');
        return;
      }

      final userSessionService = ref.read(userSessionServiceProvider);
      final donorId = userSessionService.getCurrentUserId();
      final uploadedPhotoUrl = ref
          .read(donationViewModelProvider)
          .uploadedPhotoUrl;

      await ref
          .read(donationViewModelProvider.notifier)
          .createDonation(
            itemName: _itemNameController.text.trim(),
            category: _selectedCategory!,
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            quantity: _quantityController.text.trim(),
            condition: _selectedCondition!,
            pickupLocation: _locationController.text.trim(),
            media: uploadedPhotoUrl,
            donorId: donorId,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final donationState = ref.watch(donationViewModelProvider);

    ref.listen<DonationState>(donationViewModelProvider, (previous, next) {
      if (next.status == DonationStatus.created) {
        MySnackbar.showSuccess(context, 'Donation submitted successfully');
        _clearForm();
        // notify caller (e.g., wishlist) that a donation was created
        if (widget.onDonationCreated != null) {
          widget.onDonationCreated!();
        }
        Navigator.of(context).pop();
      } else if (next.status == DonationStatus.error &&
          next.errorMessage != null) {
        MySnackbar.showError(context, next.errorMessage!);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Add Donation')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox.expand(
        child: SingleChildScrollView(
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
                    controller: _itemNameController,
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
                    controller: _descriptionController,
                    isMultiline: true,
                    isRequired: false,
                  ),
                  const SizedBox(height: 16),
                  DonationFormField(
                    label: 'Quantity *',
                    hintText: 'e.g., 5 pieces',
                    controller: _quantityController,
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
                    controller: _locationController,
                  ),
                  const SizedBox(height: 16),
                  DonationPhotosSection(
                    selectedMedia: _selectedMedia,
                    onAddPhoto: _showMediaPicker,
                    onRemovePhoto: () {
                      setState(() => _selectedMedia.clear());
                    },
                  ),
                  const SizedBox(height: 30),
                  MyButton(text: 'Submit Donation', onPressed: _handleSubmit),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _clearForm() {
    _itemNameController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    _locationController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedCondition = null;
      _selectedMedia.clear();
    });
  }
}
