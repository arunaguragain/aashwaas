import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/auth/data/repositories/donor_auth_repository.dart';
import 'package:aashwaas/features/auth/domain/entities/donor_auth_entity.dart';
import 'package:aashwaas/features/auth/domain/repositories/donor_auth_repository.dart';
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
  List<Object?> get props => [
    fullName,
    email,
    password,
  ];
}

//provider
final registerDonorUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authDonorRepository = ref.read(authDonorRepositoryProvider);
  return RegisterUsecase(authDonorRepository: authDonorRepository);
});

class RegisterUsecase
    implements UsecaseWithParams<bool, RegisterUsecaseParams> {
  final IDonorAuthRepository _authDonorRepository;

  RegisterUsecase({required IDonorAuthRepository authDonorRepository})
    : _authDonorRepository = authDonorRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = DonorAuthEntity(
      fullName: params.fullName,
      email: params.email,
      password: params.password,
    );
    return _authDonorRepository.registerDonor(entity);
  }
}
