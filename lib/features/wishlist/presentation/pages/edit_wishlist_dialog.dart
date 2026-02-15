import 'package:flutter/material.dart';
import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/features/donation/presentation/widgets/donation_form_field.dart';
import 'package:aashwaas/features/donation/presentation/widgets/category_dropdown.dart';

class EditWishlistDialog extends StatefulWidget {
  final String initialTitle;
  final String initialCategory;
  final String initialPlanned;
  final String initialNotes;
  final void Function(String, String, String, String) onEdit;
  const EditWishlistDialog({
    super.key,
    required this.initialTitle,
    required this.initialCategory,
    required this.initialPlanned,
    required this.initialNotes,
    required this.onEdit,
  });

  @override
  State<EditWishlistDialog> createState() => _EditWishlistDialogState();
}

class _EditWishlistDialogState extends State<EditWishlistDialog> {
  late TextEditingController _titleController;
  late TextEditingController _plannedController;
  late TextEditingController _notesController;
  String? _selectedCategory;
  final _formKey = GlobalKey<FormState>();
  final List<String> categories = [
    'Clothes',
    'Books',
    'Toys',
    'Electronics',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _plannedController = TextEditingController(text: widget.initialPlanned);
    _notesController = TextEditingController(text: widget.initialNotes);
    _selectedCategory = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Wishlist Item'),
      content: SizedBox(
        width: 350,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        MyButton(
          text: 'Save',
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onEdit(
                _titleController.text,
                _selectedCategory ?? '',
                _plannedController.text,
                _notesController.text,
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
