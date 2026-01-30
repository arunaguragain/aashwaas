import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_login_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_logout_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_register_usecase.dart';
import 'package:aashwaas/features/auth/presentation/state/volunteer_auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authVolunteerViewmodelProvider =
    NotifierProvider<VolunteerAuthViewmodel, VolunteerAuthState>(
      () => VolunteerAuthViewmodel(),
    );

class VolunteerAuthViewmodel extends Notifier<VolunteerAuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final VolunteerLogoutUsecase _logoutUsecase;

  @override
  VolunteerAuthState build() {
    _registerUsecase = ref.read(registerVolunteerUsecaseProvider);
    _loginUsecase = ref.read(volunteerLoginUsecaseProvider);
    _logoutUsecase = ref.read(logoutVolunteerUsecaseProvider);
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
}
