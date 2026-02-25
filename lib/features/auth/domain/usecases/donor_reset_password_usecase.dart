import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/donor_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/repositories/donor_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DonorResetPasswordParams extends Equatable {
  final String token;
  final String newPassword;
  const DonorResetPasswordParams({
    required this.token,
    required this.newPassword,
  });
  @override
  List<Object?> get props => [token, newPassword];
}

final donorResetPasswordUsecaseProvider = Provider<DonorResetPasswordUsecase>((
  ref,
) {
  final repo = ref.read(authDonorRepositoryProvider);
  return DonorResetPasswordUsecase(authRepository: repo);
});

class DonorResetPasswordUsecase
    implements UsecaseWithParams<bool, DonorResetPasswordParams> {
  final IDonorAuthRepository _authRepository;
  DonorResetPasswordUsecase({required IDonorAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(DonorResetPasswordParams params) {
    return _authRepository.resetPassword(params.token, params.newPassword);
  }
}
