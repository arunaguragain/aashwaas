import 'package:flutter/material.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/features/donation/presentation/widgets/donation_form_field.dart';
import 'package:aashwaas/features/donation/presentation/widgets/category_dropdown.dart';

class AddWishlistPage extends StatefulWidget {
  const AddWishlistPage({super.key});

  @override
  State<AddWishlistPage> createState() => _AddWishlistPageState();
}

class _AddWishlistPageState extends State<AddWishlistPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _plannedController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  String? _selectedCategory;
  final List<String> categories = [
    'Clothes',
    'Books',
    'Toys',
    'Electronics',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _plannedController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Integrate with wishlist ViewModel/provider
      MySnackbar.showSuccess(context, 'Wishlist item added successfully');
      _clearForm();
      Navigator.of(context).pop();
    }
  }

  void _clearForm() {
    _titleController.clear();
    _plannedController.clear();
    _notesController.clear();
    setState(() {
      _selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Add Wishlist Item'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                DonationFormField(
                  label: 'Wishlist Title *',
                  hintText: 'e.g., Winter Blankets',
                  controller: _titleController,
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
                  label: 'Planned Date *',
                  hintText: 'e.g., Dec 2025',
                  controller: _plannedController,
                ),
                const SizedBox(height: 16),
                DonationFormField(
                  label: 'Notes',
                  hintText: 'Any additional notes...',
                  controller: _notesController,
                  isMultiline: true,
                  isRequired: false,
                ),
                const SizedBox(height: 30),
                MyButton(text: 'Add Wishlist', onPressed: _handleSubmit),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
