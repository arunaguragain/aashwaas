import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_login_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_logout_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_register_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_update_profile_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_upload_profile_photo_usecase.dart';
import 'package:aashwaas/features/auth/presentation/state/volunteer_auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/core/api/api_client.dart';
import 'package:aashwaas/core/services/storage/token_service.dart';
import 'package:aashwaas/features/auth/data/models/volunteer_auth_api_model.dart';
import 'package:aashwaas/features/auth/data/datasources/remote/google_sign_in_remote.dart';
import 'package:aashwaas/core/api/api_endpoints.dart';

final authVolunteerViewmodelProvider =
    NotifierProvider<VolunteerAuthViewmodel, VolunteerAuthState>(
      () => VolunteerAuthViewmodel(),
    );

class VolunteerAuthViewmodel extends Notifier<VolunteerAuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final VolunteerLogoutUsecase _logoutUsecase;
  late final UpdateVolunteerProfileUsecase _updateProfileUsecase;
  late final UploadVolunteerProfilePhotoUsecase _uploadProfilePhotoUsecase;

  @override
  VolunteerAuthState build() {
    _registerUsecase = ref.read(registerVolunteerUsecaseProvider);
    _loginUsecase = ref.read(volunteerLoginUsecaseProvider);
    _logoutUsecase = ref.read(logoutVolunteerUsecaseProvider);
    _updateProfileUsecase = ref.read(updateVolunteerProfileUsecaseProvider);
    _uploadProfilePhotoUsecase = ref.read(
      uploadVolunteerProfilePhotoUsecaseProvider,
    );
    return VolunteerAuthState();
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    //wait for 2 sec
    await Future.delayed(const Duration(seconds: 2));
    final params = RegisterUsecaseParams(
      fullName: fullName,
      email: email,
      password: password,
    );
    final result = await _registerUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (isRegistered) {
        state = state.copyWith(status: AuthStatus.registered);
      },
    );
  }

  //login
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading);
    final params = LoginUsecaseParams(email: email, password: password);
    await Future.delayed(const Duration(seconds: 2));
    final result = await _loginUsecase(params);
    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
      },
      (authEntity) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: authEntity,
        );
      },
    );
  }

  // logout
  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _logoutUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) async {
        // Clear user session on successful logout
        final userSessionService = ref.read(userSessionServiceProvider);
        await userSessionService.clearUserSession();

        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          authEntity: null,
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  Future<String?> uploadProfilePhoto({
    required String userId,
    required String filePath,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _uploadProfilePhotoUsecase(
      UploadVolunteerProfilePhotoParams(userId: userId, filePath: filePath),
    );
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (url) {
        state = state.copyWith(status: AuthStatus.authenticated);
        return url;
      },
    );
  }

  // Sign in with Google and exchange idToken with backend
  /// If [registerMode] is true, backend should reject existing email addresses.
  Future<void> googleSignIn({bool registerMode = false}) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final googleService = GoogleSignInRemote();
      // Force account chooser to appear
      final idToken = await googleService.signInAndGetIdToken(
        forceAccountSelection: true,
      );
      if (idToken == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return;
      }

      final apiClient = ref.read(apiClientProvider);
      final tokenService = ref.read(tokenServiceProvider);
      final userSessionService = ref.read(userSessionServiceProvider);

      final response = await apiClient.post(
        ApiEndpoints.googleAuth,
        data: {'idToken': idToken, if (registerMode) 'action': 'register'},
      );

      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final userModel = VolunteerAuthApiModel.fromJson(data);

        final token = response.data['token'] as String?;
        if (token != null) await tokenService.saveToken(token);

        await userSessionService.saveUserSession(
          userId: userModel.id!,
          email: userModel.email,
          fullName: userModel.fullName,
          phoneNumber: userModel.phoneNumber,
          profileImage: userModel.profilePicture,
          createdAt: userModel.createdAt?.toIso8601String(),
          role: 'volunteer',
        );

        state = state.copyWith(
          status: AuthStatus.authenticated,
          authEntity: userModel.toEntity(),
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: response.data['message'] ?? 'Google login failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> updateProfile({
    required String userId,
    required String fullName,
    required String phoneNumber,
    String? profilePicture,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _updateProfileUsecase(
      UpdateVolunteerProfileParams(
        userId: userId,
        fullName: fullName,
        phoneNumber: phoneNumber,
        profilePicture: profilePicture,
      ),
    );
    return result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        );
        return false;
      },
      (_) {
        state = state.copyWith(status: AuthStatus.authenticated);
        return true;
      },
    );
  }
}
