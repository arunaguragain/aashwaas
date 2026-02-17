import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/review/data/repositories/review_repository.dart';
import 'package:aashwaas/features/review/domain/entities/review_entity.dart';
import 'package:aashwaas/features/review/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateReviewParams extends Equatable {
  final String? reviewId;
  final double rating;
  final String? comment;
  final String userId;

  const UpdateReviewParams({
    this.reviewId,
    required this.rating,
    this.comment,
    required this.userId,
  });

  @override
  List<Object?> get props => [reviewId, rating, comment, userId];
}

final updateReviewUsecaseProvider = Provider<UpdateReviewUsecase>((ref) {
  final reviewRepository = ref.read(reviewRepositoryProvider);
  return UpdateReviewUsecase(reviewRepository: reviewRepository);
});

class UpdateReviewUsecase
    implements UsecaseWithParams<bool, UpdateReviewParams> {
  final IReviewRepository _reviewRepository;

  UpdateReviewUsecase({required IReviewRepository reviewRepository})
    : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, bool>> call(UpdateReviewParams params) {
    final entity = ReviewEntity(
      reviewId: params.reviewId,
      userId: params.userId,
      rating: params.rating,
      comment: params.comment,
    );

    return _reviewRepository.updateReview(entity);
  }
}
