import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/donor_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/entities/donor_auth_entity.dart';
import 'package:aashwaas/features/auth/domain/repositories/donor_auth_repository.dart';
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
final donorLoginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authDonorRepository = ref.read(authDonorRepositoryProvider);
  return LoginUsecase(authDonorRepository: authDonorRepository);
});

class LoginUsecase
    implements UsecaseWithParams<DonorAuthEntity, LoginUsecaseParams> {
  final IDonorAuthRepository _authDonorRepository;

  LoginUsecase({required IDonorAuthRepository authDonorRepository})
    : _authDonorRepository = authDonorRepository;

  @override
  Future<Either<Failure, DonorAuthEntity>> call(LoginUsecaseParams params) {
    return _authDonorRepository.loginDonor(params.email, params.password);
  }
}
