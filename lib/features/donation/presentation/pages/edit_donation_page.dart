import 'package:aashwaas/features/donation/presentation/state/donation_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:aashwaas/features/donation/presentation/widgets/donation_form_field.dart';
import 'package:aashwaas/features/donation/presentation/widgets/category_dropdown.dart';
import 'package:aashwaas/features/donation/presentation/widgets/condition_dropdown.dart';
import 'package:aashwaas/features/donation/presentation/view_model/donation_viewmodel.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';

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
  }

  @override
  void dispose() {
    itemNameController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    locationController.dispose();
    super.dispose();
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
            media: widget.donation.media,
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
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: donationState.status == DonationStatus.loading
                      ? null
                      : _handleUpdate,
                  child: donationState.status == DonationStatus.loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Update Donation'),
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
