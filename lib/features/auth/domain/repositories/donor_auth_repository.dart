import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/auth/domain/entities/donor_auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IDonorAuthRepository {
  Future<Either<Failure, bool>> registerDonor(DonorAuthEntity entity);
  Future<Either<Failure, DonorAuthEntity>> loginDonor(
    String email,
    String password,
  );
  Future<Either<Failure, DonorAuthEntity>> getCurrentDonor();
  Future<Either<Failure, bool>> logout();
}
