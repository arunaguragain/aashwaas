import 'package:aashwaas/core/api/api_client.dart';
import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/core/services/storage/token_service.dart';
import 'package:aashwaas/features/auth/data/datasources/donor_auth_datasource.dart';
import 'package:aashwaas/features/auth/data/models/donor_auth_api_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authDonorRemoteProvider = Provider<IDonorAuthRemoteDataSource>((ref) {
  return AuthDonorRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
    tokenService: ref.read(tokenServiceProvider),
  );
});

class AuthDonorRemoteDatasource implements IDonorAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthDonorRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService,
       _tokenService = tokenService;

  @override
  Future<DonorAuthApiModel> getDonorById(String authId) async {
    final response = await _apiClient.get(ApiEndpoints.donorById(authId));
    final payload = response.data;
    if (payload is Map<String, dynamic>) {
      final data = payload['data'] ?? payload;
      if (data is Map<String, dynamic>) {
        return DonorAuthApiModel.fromJson(data);
      }
    }
    throw Exception('Invalid donor profile response');
  }

  @override
  Future<DonorAuthApiModel?> loginDonor(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.donorLogin,
      data: {'email': email, 'password': password, 'role': 'donor'},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = DonorAuthApiModel.fromJson(data);

      // Extract and save JWT token
      final token = response.data['token'] as String?;
      if (token != null) {
        await _tokenService.saveToken(token);
      }

      //Save user session
      await _userSessionService.saveUserSession(
        userId: user.id!,
        email: user.email,
        fullName: user.fullName,
        phoneNumber: user.phoneNumber,
        createdAt: user.createdAt?.toIso8601String(),
        role: 'donor',
      );
      return user;
    }
    return null;
  }

  @override
  Future<DonorAuthApiModel> registerDonor(DonorAuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.donor,
      data: {
        ...user.toJson(),
        'confirmPassword': user.password,
        'role': 'donor',
      },
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = DonorAuthApiModel.fromJson(data);

      // Extract and save JWT token
      final token = response.data['token'] as String?;
      if (token != null) {
        await _tokenService.saveToken(token);
      }

      return registeredUser;
    }

    return user;
  }

  @override
  Future<DonorAuthApiModel> updateDonorProfile(
    String authId,
    Map<String, dynamic> payload,
  ) async {
    final token = await _tokenService.getToken();
    final response = await _apiClient.put(
      ApiEndpoints.donorById(authId),
      data: payload,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return DonorAuthApiModel.fromJson(data);
  }

  @override
  Future<String> uploadDonorPhoto(String authId, String filePath) async {
    final fileName = filePath.split('/').last;
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    final token = await _tokenService.getToken();
    final response = await _apiClient.uploadFile(
      ApiEndpoints.donorPhoto(authId),
      formData: formData,
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
        contentType: 'multipart/form-data',
      ),
      method: 'PUT',
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data['data'] is String) {
        return data['data'] as String;
      } else if (data['data'] is Map) {
        final map = data['data'] as Map;
        return map['profilePicture'] as String? ??
            map['url'] as String? ??
            map['filename'] as String;
      }
      if (data['profilePicture'] is String) {
        return data['profilePicture'] as String;
      }
    }
    return fileName;
  }
}
