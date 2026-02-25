import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/donor_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/repositories/donor_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final donorForgotPasswordUsecaseProvider = Provider<DonorForgotPasswordUsecase>(
  (ref) {
    final repo = ref.read(authDonorRepositoryProvider);
    return DonorForgotPasswordUsecase(authRepository: repo);
  },
);

class DonorForgotPasswordUsecase implements UsecaseWithParams<void, String> {
  final IDonorAuthRepository _authRepository;
  DonorForgotPasswordUsecase({required IDonorAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, void>> call(String params) {
    return _authRepository.forgotPassword(params);
  }
}
