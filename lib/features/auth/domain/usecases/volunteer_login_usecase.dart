import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/volunteer_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/entities/volunteer_auth_entity.dart';
import 'package:aashwaas/features/auth/domain/repositories/volunteer_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginUsecaseParams extends Equatable {
  final String email;
  final String password;

  const LoginUsecaseParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

//provider fpr loginusecase
final volunteerLoginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authVolunteerRepository = ref.read(authVolunteerRepositoryProvider);
  return LoginUsecase(authVolunteerRepository: authVolunteerRepository);
});

class LoginUsecase
    implements UsecaseWithParams<VolunteerAuthEntity, LoginUsecaseParams> {
  final IVolunteerAuthRepository _authVolunteerRepository;

  LoginUsecase({required IVolunteerAuthRepository authVolunteerRepository})
    : _authVolunteerRepository = authVolunteerRepository;

  @override
  Future<Either<Failure, VolunteerAuthEntity>> call(LoginUsecaseParams params) {
    return _authVolunteerRepository.loginVolunteer(params.email, params.password);
  }
}
