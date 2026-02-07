import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/auth/domain/usecases/donor_login_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/donor_logout_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/donor_register_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/donor_update_profile_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/donor_upload_profile_photo_usecase.dart';
import 'package:aashwaas/features/auth/presentation/state/donor_auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authDonorViewmodelProvider =
    NotifierProvider<DonorAuthViewmodel, DonorAuthState>(
      () => DonorAuthViewmodel(),
    );

class DonorAuthViewmodel extends Notifier<DonorAuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final DonorLogoutUsecase _logoutUsecase;
  late final UpdateDonorProfileUsecase _updateProfileUsecase;
  late final UploadDonorProfilePhotoUsecase _uploadProfilePhotoUsecase;

  @override
  DonorAuthState build() {
    _registerUsecase = ref.read(registerDonorUsecaseProvider);
    _loginUsecase = ref.read(donorLoginUsecaseProvider);
    _logoutUsecase = ref.read(logoutDonorUsecaseProvider);
    _updateProfileUsecase = ref.read(updateDonorProfileUsecaseProvider);
    _uploadProfilePhotoUsecase = ref.read(
      uploadDonorProfilePhotoUsecaseProvider,
    );
    return DonorAuthState();
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

    if (result.isRight()) {
      // Clear user session on successful logout
      final userSessionService = ref.read(userSessionServiceProvider);
      await userSessionService.clearUserSession();

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        authEntity: null,
      );
    } else {
      result.fold(
        (failure) => state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ),
        (_) {},
      );
    }
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
      UploadDonorProfilePhotoParams(userId: userId, filePath: filePath),
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

  Future<bool> updateProfile({
    required String userId,
    required String fullName,
    required String phoneNumber,
    String? profilePicture,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _updateProfileUsecase(
      UpdateDonorProfileParams(
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
