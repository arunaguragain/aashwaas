import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/volunteer_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/entities/volunteer_auth_entity.dart';
import 'package:aashwaas/features/auth/domain/repositories/volunteer_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Create Provider
final getCurrentVolunteerUsecaseProvider = Provider<GetCurrentVolunteerUsecase>((ref) {
  final authVolunteerRepository = ref.read(authVolunteerRepositoryProvider);
  return GetCurrentVolunteerUsecase(authVolunteerRepository: authVolunteerRepository);
});

class GetCurrentVolunteerUsecase implements UsecaseWithoutParams<VolunteerAuthEntity> {
  final IVolunteerAuthRepository _authRepository;

  GetCurrentVolunteerUsecase({required IVolunteerAuthRepository authVolunteerRepository})
    : _authRepository = authVolunteerRepository;

  @override
  Future<Either<Failure, VolunteerAuthEntity>> call() {
    return _authRepository.getCurrentVolunteer();
  }
}
