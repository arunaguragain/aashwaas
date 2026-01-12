import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/donor_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/entities/donor_auth_entity.dart';
import 'package:aashwaas/features/auth/domain/repositories/donor_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create Provider
final getCurrentDonorUsecaseProvider = Provider<GetCurrentDonorUsecase>((ref) {
  final authDonorRepository = ref.read(authDonorRepositoryProvider);
  return GetCurrentDonorUsecase(authDonorRepository: authDonorRepository);
});

class GetCurrentDonorUsecase implements UsecaseWithoutParams<DonorAuthEntity> {
  final IDonorAuthRepository _authRepository;

  GetCurrentDonorUsecase({required IDonorAuthRepository authDonorRepository})
    : _authRepository = authDonorRepository;

  @override
  Future<Either<Failure, DonorAuthEntity>> call() {
    return _authRepository.getCurrentDonor();
  }
}
