import 'package:aashwaas/core/api/api_client.dart';
import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/auth/data/datasources/donor_auth_datasource.dart';
import 'package:aashwaas/features/auth/data/models/donor_auth_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


//provider
final authDonorRemoteProvider = Provider<IDonorAuthRemoteDataSource>((ref) {
  return AuthDonorRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthDonorRemoteDatasource implements IDonorAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthDonorRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;
  
  @override
  Future<DonorAuthApiModel> getDonorById(String authId) {
    // TODO: implement getDonorById
    throw UnimplementedError();
  }
  
  @override
  Future<DonorAuthApiModel?> loginDonor(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.donorLogin,
      data: {'email': email, 'password': password},
    );
    
    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = DonorAuthApiModel.fromJson(data);

      //Save user session
      await _userSessionService.saveUserSession(
        userId: user.id!,
        email: user.email,
        fullName: user.fullName,
        phoneNumber: user.phoneNumber,
      );
      return user;
    }
    return null;
  }
  
  @override
  Future<DonorAuthApiModel> registerDonor(DonorAuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.donor,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = DonorAuthApiModel.fromJson(data);
      return registeredUser;
    }

    return user;
  }
}
