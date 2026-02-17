import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/review/data/repositories/review_repository.dart';
import 'package:aashwaas/features/review/domain/entities/review_entity.dart';
import 'package:aashwaas/features/review/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllReviewsUsecaseProvider = Provider<GetAllReviewsUsecase>((ref) {
  final reviewRepository = ref.read(reviewRepositoryProvider);
  return GetAllReviewsUsecase(reviewRepository: reviewRepository);
});

class GetAllReviewsUsecase implements UsecaseWithoutParams<List<ReviewEntity>> {
  final IReviewRepository _reviewRepository;

  GetAllReviewsUsecase({required IReviewRepository reviewRepository})
    : _reviewRepository = reviewRepository;

  @override
  Future<Either<Failure, List<ReviewEntity>>> call() {
    return _reviewRepository.getAllReviews();
  }
}
