import 'package:aashwaas/core/api/api_client.dart';
import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:aashwaas/core/services/storage/token_service.dart';
import 'package:aashwaas/features/wishlist/data/datasources/wishlist_datasource.dart';
import 'package:aashwaas/features/wishlist/data/models/wishlist_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishlistRemoteDataSourceProvider = Provider<IWishlistRemoteDataSource>((ref) {
  return WishlistRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class WishlistRemoteDataSource implements IWishlistRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  WishlistRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  })  : _apiClient = apiClient,
        _tokenService = tokenService;

  @override
  Future<WishlistApiModel> createWishlist(WishlistApiModel wishlist) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.wishlistCreate,
      data: wishlist.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return WishlistApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<WishlistApiModel>> getAllWishlists() async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.wishlistAll,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((e) => WishlistApiModel.fromJson(e)).toList();
  }

  @override
  Future<List<WishlistApiModel>> getWishlistsByDonor(String donorId) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.wishlistByDonor(donorId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((e) => WishlistApiModel.fromJson(e)).toList();
  }

  @override
  Future<WishlistApiModel> getWishlistById(String wishlistId) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.wishlistById(wishlistId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return WishlistApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<WishlistApiModel>> getWishlistsByCategory(String category) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.wishlistByCategory(category),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((e) => WishlistApiModel.fromJson(e)).toList();
  }

  @override
  Future<List<WishlistApiModel>> getWishlistsByStatus(String status) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.get(
      ApiEndpoints.wishlistByStatus(status),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data['data'] as List;
    return data.map((e) => WishlistApiModel.fromJson(e)).toList();
  }

  @override
  Future<bool> updateWishlist(WishlistApiModel wishlist) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.put(
      ApiEndpoints.wishlistUpdate(wishlist.id!),
      data: wishlist.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['success'] == true;
  }

  @override
  Future<bool> deleteWishlist(String wishlistId) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.delete(
      ApiEndpoints.wishlistDelete(wishlistId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return response.data['success'] == true;
  }
}
