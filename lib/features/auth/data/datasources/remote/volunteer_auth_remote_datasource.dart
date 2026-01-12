import 'package:aashwaas/core/api/api_client.dart';
import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/auth/data/datasources/volunteer_auth_datasource.dart';
import 'package:aashwaas/features/auth/data/models/volunteer_auth_api_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//provider
final authVolunteerRemoteProvider = Provider<IVolunteerAuthRemoteDataSource>((
  ref,
) {
  return AuthVolunteerRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthVolunteerRemoteDatasource implements IVolunteerAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthVolunteerRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<VolunteerAuthApiModel> getVolunteerById(String authId) {
    throw UnimplementedError();
  }

  @override
  Future<VolunteerAuthApiModel?> loginVolunteer(
    String email,
    String password,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.volunteerLogin,
      data: {'email': email, 'password': password},
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final user = VolunteerAuthApiModel.fromJson(data);

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
  Future<VolunteerAuthApiModel> registerVolunteer(
    VolunteerAuthApiModel user,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.volunteer,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;
      final registeredUser = VolunteerAuthApiModel.fromJson(data);
      return registeredUser;
    }

    return user;
  }
}
