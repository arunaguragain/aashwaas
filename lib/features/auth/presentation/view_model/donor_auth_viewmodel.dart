import 'package:aashwaas/features/auth/domain/usecases/donor_login_usecase.dart';
import 'package:aashwaas/features/auth/domain/usecases/donor_register_usecase.dart';
import 'package:aashwaas/features/auth/presentation/state/donor_auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authDonorViewmodelProvider = NotifierProvider<DonorAuthViewmodel, DonorAuthState>(
  () => DonorAuthViewmodel(),
);

class DonorAuthViewmodel extends Notifier<DonorAuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;

  @override
  DonorAuthState build() {
    _registerUsecase = ref.read(registerDonorUsecaseProvider);
    _loginUsecase = ref.read(donorLoginUsecaseProvider);
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
}
