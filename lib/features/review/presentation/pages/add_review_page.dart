import 'package:flutter/material.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/features/donation/presentation/widgets/donation_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/features/review/presentation/view_model/review_viewmodel.dart';

class AddReviewPage extends ConsumerStatefulWidget {
  const AddReviewPage({super.key});

  @override
  ConsumerState<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends ConsumerState<AddReviewPage> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 5.0;
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final userId = 'unknown';
      ref.read(reviewViewModelProvider.notifier).createReview(
            rating: _rating,
            comment: _commentController.text.isEmpty ? null : _commentController.text,
            userId: userId,
          );

      MySnackbar.showSuccess(context, 'Review submitted');
      _clearForm();
      Navigator.of(context).pop();
    }
  }

  void _clearForm() {
    setState(() {
      _rating = 5.0;
    });
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Add Review'),
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
                DropdownButtonFormField<double>(
                  value: _rating,
                  decoration: const InputDecoration(labelText: 'Rating *'),
                  items: List.generate(5, (i) => (i + 1).toDouble())
                      .map((v) => DropdownMenuItem(value: v, child: Text(v.toString())))
                      .toList(),
                  onChanged: (v) => setState(() => _rating = v ?? _rating),
                ),
                const SizedBox(height: 16),
                DonationFormField(
                  label: 'Comment',
                  hintText: 'Write your review...',
                  controller: _commentController,
                  isMultiline: true,
                  isRequired: false,
                ),
                const SizedBox(height: 30),
                MyButton(text: 'Submit Review', onPressed: _handleSubmit),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
