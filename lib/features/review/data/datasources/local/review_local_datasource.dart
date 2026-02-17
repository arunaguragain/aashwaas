import 'package:aashwaas/features/review/data/datasources/review_datasource.dart';
import 'package:aashwaas/features/review/data/models/review_hive_model.dart';
import 'package:aashwaas/core/services/hive/hive_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewLocalDatasourceProvider = Provider<ReviewLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  return ReviewLocalDatasource(hiveService: hiveService);
});

class ReviewLocalDatasource implements IReviewLocalDataSource {
  final HiveService _hiveService;

  ReviewLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<bool> createReview(ReviewHiveModel review) async {
    try {
      await _hiveService.createReview(review);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteReview(String reviewId) async {
    try {
      await _hiveService.deleteReview(reviewId);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ReviewHiveModel>> getAllReviews() async {
    try {
      return _hiveService.getAllReviews();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> cacheAllReviews(List<ReviewHiveModel> reviews) async {
    try {
      await _hiveService.cacheAllReviews(reviews);
    } catch (_) {}
  }

  @override
  Future<ReviewHiveModel?> getReviewById(String reviewId) async {
    try {
      return _hiveService.getReviewById(reviewId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ReviewHiveModel>> getReviewsByUser(String userId) async {
    try {
      return _hiveService.getReviewsByUser(userId);
    } catch (e) {
      return [];
    }
  }

  @override
  Future<bool> updateReview(ReviewHiveModel review) async {
    try {
      await _hiveService.updateReview(review);
      return true;
    } catch (e) {
      return false;
    }
  }
}
