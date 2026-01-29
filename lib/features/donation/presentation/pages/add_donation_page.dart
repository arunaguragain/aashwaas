import 'dart:io';

import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/features/donation/presentation/widgets/donation_form_field.dart';
import 'package:aashwaas/features/donation/presentation/widgets/category_dropdown.dart';
import 'package:aashwaas/features/donation/presentation/widgets/condition_dropdown.dart';
import 'package:aashwaas/features/donation/presentation/widgets/donation_photos_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDonationScreen extends ConsumerStatefulWidget {
  const AddDonationScreen({super.key});

  @override
  ConsumerState<AddDonationScreen> createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends ConsumerState<AddDonationScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _itemNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late TextEditingController _locationController;

  String? _selectedCategory;
  String? _selectedCondition;
  List<File> _selectedMedia = [];
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
    _itemNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _quantityController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Donation')),
      backgroundColor: Colors.white,
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
                  const DonationPhotosSection(),
                  const SizedBox(height: 30),
                  MyButton(text: 'Submit Donation', onPressed: () {}),
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
