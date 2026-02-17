import 'package:aashwaas/core/api/api_client.dart';
import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:aashwaas/core/services/storage/token_service.dart';
import 'package:aashwaas/features/review/data/datasources/review_datasource.dart';
import 'package:aashwaas/features/review/data/models/review_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewRemoteDataSourceProvider = Provider<IReviewRemoteDataSource>((ref) {
  return ReviewRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class ReviewRemoteDataSource implements IReviewRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  ReviewRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<ReviewApiModel> createReview(ReviewApiModel review) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.reviewCreate,
      data: review.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ReviewApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<ReviewApiModel>> getAllReviews() async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.reviews,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((e) => ReviewApiModel.fromJson(e)).toList();
  }

  @override
  Future<List<ReviewApiModel>> getReviewsByUser(String userId) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.reviewsByUser(userId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((e) => ReviewApiModel.fromJson(e)).toList();
  }

  @override
  Future<ReviewApiModel> getReviewById(String reviewId) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.reviewById(reviewId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return ReviewApiModel.fromJson(response.data['data']);
  }

  @override
  Future<bool> updateReview(ReviewApiModel review) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.put(
      ApiEndpoints.reviewUpdate(review.id!),
      data: review.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['success'] == true;
  }

  @override
  Future<bool> deleteReview(String reviewId) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.delete(
      ApiEndpoints.reviewDelete(reviewId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['success'] == true;
  }
}
