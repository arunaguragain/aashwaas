import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/donor_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/repositories/donor_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create Provider
final logoutDonorUsecaseProvider = Provider<DonorLogoutUsecase>((ref) {
  final authDonorRepository = ref.read(authDonorRepositoryProvider);
  return DonorLogoutUsecase(authRepository: authDonorRepository);
});

class DonorLogoutUsecase implements UsecaseWithoutParams<bool> {
  final IDonorAuthRepository _authRepository;

  DonorLogoutUsecase({required IDonorAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call() {
    return _authRepository.logout();
  }
}


