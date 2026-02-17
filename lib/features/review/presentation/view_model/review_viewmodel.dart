import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/features/review/domain/usecases/create_review_usecase.dart';
import 'package:aashwaas/features/review/domain/usecases/delete_review_usecase.dart';
import 'package:aashwaas/features/review/domain/usecases/get_all_reviews_usecase.dart';
import 'package:aashwaas/features/review/domain/usecases/get_review_by_id_usecase.dart';
import 'package:aashwaas/features/review/domain/usecases/get_reviews_by_user_usecase.dart';
import 'package:aashwaas/features/review/domain/usecases/update_review_usecase.dart';
import 'package:aashwaas/features/review/presentation/state/review_state.dart';
import 'package:aashwaas/features/review/domain/entities/review_entity.dart';

final reviewViewModelProvider = NotifierProvider<ReviewViewModel, ReviewState>(
  ReviewViewModel.new,
);

class ReviewViewModel extends Notifier<ReviewState> {
  late final GetAllReviewsUsecase _getAllReviewsUsecase;
  late final GetReviewByIdUsecase _getReviewByIdUsecase;
  late final GetReviewsByUserUsecase _getReviewsByUserUsecase;
  late final CreateReviewUsecase _createReviewUsecase;
  late final UpdateReviewUsecase _updateReviewUsecase;
  late final DeleteReviewUsecase _deleteReviewUsecase;

  @override
  ReviewState build() {
    _getAllReviewsUsecase = ref.read(getAllReviewsUsecaseProvider);
    _getReviewByIdUsecase = ref.read(getReviewByIdUsecaseProvider);
    _getReviewsByUserUsecase = ref.read(getReviewsByUserUsecaseProvider);
    _createReviewUsecase = ref.read(createReviewUsecaseProvider);
    _updateReviewUsecase = ref.read(updateReviewUsecaseProvider);
    _deleteReviewUsecase = ref.read(deleteReviewUsecaseProvider);
    return const ReviewState();
  }

  Future<void> createReview({
    required double rating,
    String? comment,
    required String userId,
  }) async {
    state = state.copyWith(status: ReviewViewStatus.loading);

    final result = await _createReviewUsecase(
      CreateReviewParams(rating: rating, comment: comment, userId: userId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ReviewViewStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: ReviewViewStatus.created);
        getAllReviews();
      },
    );
  }

  Future<void> getAllReviews() async {
    state = state.copyWith(status: ReviewViewStatus.loading);

    final result = await _getAllReviewsUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: ReviewViewStatus.error,
        errorMessage: failure.message,
      ),
      (reviews) => state = state.copyWith(
        status: ReviewViewStatus.loaded,
        reviews: reviews,
        totalReviewCount: reviews.length,
      ),
    );
  }

  Future<void> getReviewById(String reviewId) async {
    state = state.copyWith(status: ReviewViewStatus.loading);

    final result = await _getReviewByIdUsecase(
      GetReviewByIdParams(reviewId: reviewId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ReviewViewStatus.error,
        errorMessage: failure.message,
      ),
      (review) => state = state.copyWith(
        status: ReviewViewStatus.loaded,
        selectedReview: review,
      ),
    );
  }

  Future<void> getMyReviews(String userId) async {
    state = state.copyWith(status: ReviewViewStatus.loading);

    final result = await _getReviewsByUserUsecase(
      GetReviewsByUserParams(userId: userId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ReviewViewStatus.error,
        errorMessage: failure.message,
      ),
      (reviews) => state = state.copyWith(
        status: ReviewViewStatus.loaded,
        myReviews: reviews,
        totalReviewCount: reviews.length,
      ),
    );
  }

  Future<void> updateReview({
    String? reviewId,
    required double rating,
    String? comment,
    required String userId,
  }) async {
    state = state.copyWith(status: ReviewViewStatus.loading);

    final result = await _updateReviewUsecase(
      UpdateReviewParams(
        reviewId: reviewId,
        rating: rating,
        comment: comment,
        userId: userId,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ReviewViewStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: ReviewViewStatus.updated);
        getAllReviews();
      },
    );
  }

  Future<void> deleteReview(String reviewId) async {
    state = state.copyWith(status: ReviewViewStatus.loading);

    final result = await _deleteReviewUsecase(
      DeleteReviewParams(reviewId: reviewId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ReviewViewStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: ReviewViewStatus.deleted);
        getAllReviews();
      },
    );
  }

  void clearError() {
    state = state.copyWith(resetErrorMessage: true);
  }

  void clearSelectedReview() {
    state = state.copyWith(resetSelectedReview: true);
  }

  void clearReviewState() {
    state = state.copyWith(
      status: ReviewViewStatus.initial,
      resetErrorMessage: true,
      resetSelectedReview: true,
    );
  }
}
