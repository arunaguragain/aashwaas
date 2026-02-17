import 'package:aashwaas/features/review/domain/entities/review_entity.dart';
import 'package:equatable/equatable.dart';

enum ReviewViewStatus {
  initial,
  loading,
  loaded,
  error,
  created,
  updated,
  deleted,
}

class ReviewState extends Equatable {
  final ReviewViewStatus status;
  final List<ReviewEntity> reviews;
  final List<ReviewEntity> myReviews;
  final ReviewEntity? selectedReview;
  final String? errorMessage;
  final int totalReviewCount;

  const ReviewState({
    this.status = ReviewViewStatus.initial,
    this.reviews = const [],
    this.myReviews = const [],
    this.selectedReview,
    this.errorMessage,
    this.totalReviewCount = 0,
  });

  ReviewState copyWith({
    ReviewViewStatus? status,
    List<ReviewEntity>? reviews,
    List<ReviewEntity>? myReviews,
    ReviewEntity? selectedReview,
    bool resetSelectedReview = false,
    String? errorMessage,
    bool resetErrorMessage = false,
    int? totalReviewCount,
  }) {
    return ReviewState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      myReviews: myReviews ?? this.myReviews,
      selectedReview: resetSelectedReview
          ? null
          : (selectedReview ?? this.selectedReview),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      totalReviewCount: totalReviewCount ?? this.totalReviewCount,
    );
  }

  @override
  List<Object?> get props => [
    status,
    reviews,
    myReviews,
    selectedReview,
    errorMessage,
    totalReviewCount,
  ];
}
