import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/volunteer_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/repositories/volunteer_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final volunteerForgotPasswordUsecaseProvider =
    Provider<VolunteerForgotPasswordUsecase>((ref) {
      final repo = ref.read(authVolunteerRepositoryProvider);
      return VolunteerForgotPasswordUsecase(authRepository: repo);
    });

class VolunteerForgotPasswordUsecase
    implements UsecaseWithParams<void, String> {
  final IVolunteerAuthRepository _authRepository;
  VolunteerForgotPasswordUsecase({
    required IVolunteerAuthRepository authRepository,
  }) : _authRepository = authRepository;

  @override
  Future<Either<Failure, void>> call(String params) {
    return _authRepository.forgotPassword(params);
  }
}
