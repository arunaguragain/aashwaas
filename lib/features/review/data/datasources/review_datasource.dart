import 'package:aashwaas/features/review/data/models/review_api_model.dart';
import 'package:aashwaas/features/review/data/models/review_hive_model.dart';

abstract interface class IReviewLocalDataSource {
  Future<List<ReviewHiveModel>> getAllReviews();
  Future<void> cacheAllReviews(List<ReviewHiveModel> reviews);
  Future<List<ReviewHiveModel>> getReviewsByUser(String userId);
  Future<ReviewHiveModel?> getReviewById(String reviewId);
  Future<bool> createReview(ReviewHiveModel review);
  Future<bool> updateReview(ReviewHiveModel review);
  Future<bool> deleteReview(String reviewId);
}

abstract interface class IReviewRemoteDataSource {
  Future<ReviewApiModel> createReview(ReviewApiModel review);
  Future<List<ReviewApiModel>> getAllReviews();
  Future<List<ReviewApiModel>> getReviewsByUser(String userId);
  Future<ReviewApiModel> getReviewById(String reviewId);
  Future<bool> updateReview(ReviewApiModel review);
  Future<bool> deleteReview(String reviewId);
}
