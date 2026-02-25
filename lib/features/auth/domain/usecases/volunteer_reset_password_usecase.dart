import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/volunteer_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/repositories/volunteer_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VolunteerResetPasswordParams extends Equatable {
  final String token;
  final String newPassword;
  const VolunteerResetPasswordParams({
    required this.token,
    required this.newPassword,
  });
  @override
  List<Object?> get props => [token, newPassword];
}

final volunteerResetPasswordUsecaseProvider =
    Provider<VolunteerResetPasswordUsecase>((ref) {
      final repo = ref.read(authVolunteerRepositoryProvider);
      return VolunteerResetPasswordUsecase(authRepository: repo);
    });

class VolunteerResetPasswordUsecase
    implements UsecaseWithParams<bool, VolunteerResetPasswordParams> {
  final IVolunteerAuthRepository _authRepository;
  VolunteerResetPasswordUsecase({
    required IVolunteerAuthRepository authRepository,
  }) : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(VolunteerResetPasswordParams params) {
    return _authRepository.resetPassword(params.token, params.newPassword);
  }
}
