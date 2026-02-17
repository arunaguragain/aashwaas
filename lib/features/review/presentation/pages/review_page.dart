import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/features/review/presentation/pages/add_review_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/review_card.dart';
import 'package:aashwaas/features/review/presentation/view_model/review_viewmodel.dart';
import 'package:aashwaas/features/review/presentation/state/review_state.dart';
import 'package:aashwaas/features/review/presentation/pages/edit_review_page.dart';

class ReviewPage extends ConsumerStatefulWidget {
  const ReviewPage({super.key});

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewViewModelProvider.notifier).getAllReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(reviewViewModelProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Reviews'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add', style: TextStyle(color: Colors.white)),
              onPressed: () {
                AppRoutes.push(context, const AddReviewPage());
              },
            ),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.status == ReviewViewStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == ReviewViewStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'Something went wrong'),
            );
          }

          final items = state.reviews;

          if (items.isEmpty) {
            return const Center(child: Text('No reviews found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final r = items[index];
              final dateText = r.createdAt != null
                  ? r.createdAt!.toLocal().toString().split(' ')[0]
                  : null;
              return ReviewCard(
                rating: r.rating,
                comment: r.comment,
                dateText: dateText,
                onEdit: () {
                  AppRoutes.push(context, EditReviewPage(review: r));
                },
                onDelete: () {
                  if (r.reviewId != null) {
                    ref
                        .read(reviewViewModelProvider.notifier)
                        .deleteReview(r.reviewId!);
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
