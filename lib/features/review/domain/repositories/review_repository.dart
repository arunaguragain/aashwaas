import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/review/domain/entities/review_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IReviewRepository {
  Future<Either<Failure, List<ReviewEntity>>> getAllReviews();
  Future<Either<Failure, List<ReviewEntity>>> getReviewsByUser(String userId);
  Future<Either<Failure, ReviewEntity>> getReviewById(String reviewId);
  Future<Either<Failure, bool>> createReview(ReviewEntity entity);
  Future<Either<Failure, bool>> updateReview(ReviewEntity entity);
  Future<Either<Failure, bool>> deleteReview(String reviewId);
}
