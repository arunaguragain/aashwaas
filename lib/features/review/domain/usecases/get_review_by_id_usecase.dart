import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/review/data/repositories/review_repository.dart';
import 'package:aashwaas/features/review/domain/entities/review_entity.dart';
import 'package:aashwaas/features/review/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetReviewByIdParams extends Equatable {
  final String reviewId;

  const GetReviewByIdParams({required this.reviewId});

  @override
  List<Object?> get props => [reviewId];
}

final getReviewByIdUsecaseProvider = Provider<GetReviewByIdUsecase>((ref) {
  final reviewRepository = ref.read(reviewRepositoryProvider);
  return GetReviewByIdUsecase(reviewRepository: reviewRepository);
});

class GetReviewByIdUsecase
    implements UsecaseWithParams<ReviewEntity, GetReviewByIdParams> {
  final IReviewRepository _reviewRepository;

  GetReviewByIdUsecase({required IReviewRepository reviewRepository})
    : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, ReviewEntity>> call(GetReviewByIdParams params) {
    return _reviewRepository.getReviewById(params.reviewId);
  }
}
