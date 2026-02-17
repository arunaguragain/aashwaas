import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/review/data/repositories/review_repository.dart';
import 'package:aashwaas/features/review/domain/entities/review_entity.dart';
import 'package:aashwaas/features/review/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateReviewParams extends Equatable {
  final double rating;
  final String? comment;
  final String userId;

  const CreateReviewParams({
    required this.rating,
    this.comment,
    required this.userId,
  });

  @override
  List<Object?> get props => [rating, comment, userId];
}

final createReviewUsecaseProvider = Provider<CreateReviewUsecase>((ref) {
  final reviewRepository = ref.read(reviewRepositoryProvider);
  return CreateReviewUsecase(reviewRepository: reviewRepository);
});

class CreateReviewUsecase
    implements UsecaseWithParams<bool, CreateReviewParams> {
  final IReviewRepository _reviewRepository;

  CreateReviewUsecase({required IReviewRepository reviewRepository})
    : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, bool>> call(CreateReviewParams params) {
    final entity = ReviewEntity(
      userId: params.userId,
      rating: params.rating,
      comment: params.comment,
    );

    return _reviewRepository.createReview(entity);
  }
}
