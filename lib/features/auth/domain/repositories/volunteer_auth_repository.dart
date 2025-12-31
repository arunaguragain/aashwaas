import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/auth/domain/entities/volunteer_auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class IVolunteerAuthRepository {
  Future<Either<Failure, bool>> registerVolunteer(VolunteerAuthEntity entity);
  Future<Either<Failure, VolunteerAuthEntity>> loginVolunteer(
    String email,
    String password,
  );
  Future<Either<Failure, VolunteerAuthEntity>> getCurrentVolunteer();
  Future<Either<Failure, bool>> logout();
}
