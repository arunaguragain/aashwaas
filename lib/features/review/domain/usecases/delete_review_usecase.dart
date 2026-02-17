import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/review/data/repositories/review_repository.dart';
import 'package:aashwaas/features/review/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteReviewParams extends Equatable {
  final String reviewId;

  const DeleteReviewParams({required this.reviewId});

  @override
  List<Object?> get props => [reviewId];
}

final deleteReviewUsecaseProvider = Provider<DeleteReviewUsecase>((ref) {
  final reviewRepository = ref.read(reviewRepositoryProvider);
  return DeleteReviewUsecase(reviewRepository: reviewRepository);
});

class DeleteReviewUsecase
    implements UsecaseWithParams<bool, DeleteReviewParams> {
  final IReviewRepository _reviewRepository;

  DeleteReviewUsecase({required IReviewRepository reviewRepository})
    : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, bool>> call(DeleteReviewParams params) {
    return _reviewRepository.deleteReview(params.reviewId);
  }
}
