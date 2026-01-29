import 'dart:io';

import 'package:aashwaas/core/api/api_client.dart';
import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:aashwaas/core/services/storage/token_service.dart';
import 'package:aashwaas/features/donation/data/datasources/donation_datasource.dart';
import 'package:aashwaas/features/donation/data/models/donation_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final donationRemoteDataSourceProvider = Provider<IDonationRemoteDataSource>((
  ref,
) {
  return DonationRemoteDataSource(
    apiClient: ref.read(apiClientProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class DonationRemoteDataSource implements IDonationRemoteDataSource {
  final ApiClient _apiClient;
  final TokenService _tokenService;

  DonationRemoteDataSource({
    required ApiClient apiClient,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _tokenService = tokenService;

  @override
  Future<String> uploadPhoto(File photo) async {
    final fileName = photo.path.split('/').last;
    final formData = FormData.fromMap({
      'donationPhoto': await MultipartFile.fromFile(
        photo.path,
        filename: fileName,
      ),
    });
    final token = await _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.donationUploadPhoto,
      formData: formData,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return response.data['data'];
  }

  @override
  Future<DonationApiModel> createDonation(DonationApiModel donation) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.post(
      ApiEndpoints.donations,
      data: donation.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    return DonationApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<DonationApiModel>> getAllDonations() async {
    final response = await _apiClient.get(ApiEndpoints.donations);
    final data = response.data['data'] as List;
    return data.map((json) => DonationApiModel.fromJson(json)).toList();
  }

  @override
  Future<DonationApiModel> getDonationById(String donationId) async {
    final response = await _apiClient.get(
      ApiEndpoints.donationById(donationId),
    );
    return DonationApiModel.fromJson(response.data['data']);
  }

  @override
  Future<List<DonationApiModel>> getDonationsByCategory(String category) async {
    final response = await _apiClient.get(
      ApiEndpoints.donations,
      queryParameters: {'category': category},
    );
    final data = response.data['data'] as List;
    return data.map((json) => DonationApiModel.fromJson(json)).toList();
  }

  @override
  Future<List<DonationApiModel>> getDonationsByStatus(String status) async {
    final response = await _apiClient.get(
      ApiEndpoints.donations,
      queryParameters: {'status': status},
    );
    final data = response.data['data'] as List;
    return data.map((json) => DonationApiModel.fromJson(json)).toList();
  }

  @override
  Future<List<DonationApiModel>> getDonationsByDonor(String donorId) async {
    final response = await _apiClient.get(
      ApiEndpoints.donations,
      queryParameters: {'donorId': donorId},
    );
    final data = response.data['data'] as List;
    return data.map((json) => DonationApiModel.fromJson(json)).toList();
  }

  @override
  Future<bool> updateDonation(DonationApiModel donation) async {
    final token = await _tokenService.getToken();
    await _apiClient.put(
      ApiEndpoints.donationById(donation.id!),
      data: donation.toJson(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return true;
  }

  @override
  Future<bool> deleteDonation(String donationId) async {
    final token = await _tokenService.getToken();
    await _apiClient.delete(
      ApiEndpoints.donationById(donationId),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    return true;
  }
}
