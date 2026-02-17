import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/features/review/presentation/pages/add_review_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/review_card.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/auth/data/datasources/remote/donor_auth_remote_datasource.dart';
import 'package:aashwaas/features/auth/data/datasources/remote/volunteer_auth_remote_datasource.dart';
import 'package:aashwaas/features/review/presentation/view_model/review_viewmodel.dart';
import 'package:aashwaas/features/review/presentation/state/review_state.dart';
import 'package:aashwaas/features/review/presentation/pages/edit_review_page.dart';

class ReviewPage extends ConsumerStatefulWidget {
  const ReviewPage({super.key});

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  // Simple in-memory cache for user names to avoid duplicate requests
  final Map<String, String?> _nameCache = {};

  Future<void> _fetchNameFor(String userId) async {
    if (userId.isEmpty) return;
    if (_nameCache.containsKey(userId)) return;
    // mark as loading to avoid duplicate fetches
    _nameCache[userId] = null;
    try {
      final donor = await ref
          .read(authDonorRemoteProvider)
          .getDonorById(userId);
      _nameCache[userId] = donor.fullName;
      if (mounted) setState(() {});
      return;
    } catch (_) {}
    try {
      final vol = await ref
          .read(authVolunteerRemoteProvider)
          .getVolunteerById(userId);
      _nameCache[userId] = vol.fullName;
      if (mounted) setState(() {});
      return;
    } catch (_) {}
    // keep null if not found
    _nameCache[userId] = null;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reviewViewModelProvider.notifier).getAllReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userSessionService = ref.read(userSessionServiceProvider);
    final currentUserId = userSessionService.getCurrentUserId();
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
              final isMine = r.userId == currentUserId;
              // Prefer authorName embedded in the review entity
              String authorName = r.authorName ?? '';
              if (authorName.isNotEmpty) {
                // use embedded name
              } else if (isMine) {
                authorName = userSessionService.getUserFullName() ?? 'You';
              } else if (_nameCache.containsKey(r.userId)) {
                authorName = _nameCache[r.userId] ?? 'Unknown user';
              } else {
                authorName = 'Loading...';
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _fetchNameFor(r.userId);
                });
              }
              return ReviewCard(
                rating: r.rating,
                comment: r.comment,
                dateText: dateText,
                authorName: authorName,
                onEdit: isMine
                    ? () {
                        AppRoutes.push(context, EditReviewPage(review: r));
                      }
                    : null,
                onDelete: isMine
                    ? () {
                        if (r.reviewId != null) {
                          ref
                              .read(reviewViewModelProvider.notifier)
                              .deleteReview(r.reviewId!);
                        }
                      }
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
