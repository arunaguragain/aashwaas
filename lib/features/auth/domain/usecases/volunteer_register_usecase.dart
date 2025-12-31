import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/volunteer_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/entities/volunteer_auth_entity.dart';
import 'package:aashwaas/features/auth/domain/repositories/volunteer_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterUsecaseParams extends Equatable {
  final String fullName;
  final String email;
  final String password;

  const RegisterUsecaseParams({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}

//provider
final registerVolunteerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authVolunteerRepository = ref.read(authVolunteerRepositoryProvider);
  return RegisterUsecase(authVolunteerRepository: authVolunteerRepository);
});

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IVolunteerAuthRepository _authVolunteerRepository;

  RegisterUsecase({required IVolunteerAuthRepository authVolunteerRepository})
    : _authVolunteerRepository = authVolunteerRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = VolunteerAuthEntity(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
    return _authVolunteerRepository.registerVolunteer(entity);
  }
}
