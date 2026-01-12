import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/volunteer_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/repositories/volunteer_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create Provider
final logoutVolunteerUsecaseProvider = Provider<VolunteerLogoutUsecase>((ref) {
  final authVolunteerRepository = ref.read(authVolunteerRepositoryProvider);
  return VolunteerLogoutUsecase(authRepository: authVolunteerRepository);
});

class VolunteerLogoutUsecase implements UsecaseWithoutParams<bool> {
  final IVolunteerAuthRepository _authRepository;

  VolunteerLogoutUsecase({required IVolunteerAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call() {
    return _authRepository.logout();
  }
}


