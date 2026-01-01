import 'package:aashwaas/features/auth/domain/usecases/volunteer_login_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/volunteer_register_usecase.dart';
import 'package:aashwaas/features/auth/presentation/state/volunteer_auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authVolunteerViewmodelProvider = NotifierProvider<VolunteerAuthViewmodel, VolunteerAuthState>(
  () => VolunteerAuthViewmodel(),
);

class VolunteerAuthViewmodel extends Notifier<VolunteerAuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;

  @override
  VolunteerAuthState build() {
    _registerUsecase = ref.read(registerVolunteerUsecaseProvider);
    _loginUsecase = ref.read(volunteerLoginUsecaseProvider);
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
}
