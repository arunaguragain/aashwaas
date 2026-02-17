import 'package:aashwaas/features/review/presentation/state/review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/features/review/domain/entities/review_entity.dart';
import 'package:aashwaas/features/review/presentation/view_model/review_viewmodel.dart';
import 'package:aashwaas/features/donation/presentation/widgets/donation_form_field.dart';
import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';

class EditReviewPage extends ConsumerStatefulWidget {
  final ReviewEntity review;
  const EditReviewPage({super.key, required this.review});

  @override
  ConsumerState<EditReviewPage> createState() => _EditReviewPageState();
}

class _EditReviewPageState extends ConsumerState<EditReviewPage> {
  final _formKey = GlobalKey<FormState>();
  late double _rating;
  late TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _rating = widget.review.rating;
    _commentController = TextEditingController(
      text: widget.review.comment ?? '',
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(reviewViewModelProvider.notifier)
        .updateReview(
          reviewId: widget.review.reviewId,
          rating: _rating,
          comment: _commentController.text.isEmpty
              ? null
              : _commentController.text,
          userId: widget.review.userId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reviewViewModelProvider);
    ref.listen(reviewViewModelProvider, (prev, next) {
      if (prev?.status != next.status) {
        if (next.status == ReviewViewStatus.updated) {
          MySnackbar.showSuccess(context, 'Review updated successfully');
          Navigator.of(context).pop();
        } else if (next.status == ReviewViewStatus.error &&
            next.errorMessage != null) {
          MySnackbar.showError(context, next.errorMessage!);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Review')),
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
                      .map(
                        (v) => DropdownMenuItem(
                          value: v,
                          child: Text(v.toString()),
                        ),
                      )
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
                MyButton(
                  text: state.status == ReviewViewStatus.loading
                      ? 'Saving...'
                      : 'Update Review',
                  onPressed: state.status == ReviewViewStatus.loading
                      ? () {}
                      : () {
                          _handleUpdate();
                        },
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
