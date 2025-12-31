import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/auth/data/datasources/local/volunteer_auth_local_datasource.dart';
import 'package:aashwaas/features/auth/data/datasources/volunteer_auth_datasource.dart';
import 'package:aashwaas/features/auth/data/models/volunteer_auth_hive_model.dart';
import 'package:aashwaas/features/auth/domain/entities/volunteer_auth_entity.dart';
import 'package:aashwaas/features/auth/domain/repositories/volunteer_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authVolunteerRepositoryProvider = Provider<IVolunteerAuthRepository>((
  ref,
) {
  return VolunteerAuthRepository(
    authVolunteerDataSource: ref.read(authVolunteerLocalDatasourceProvider),
  );
});

class VolunteerAuthRepository implements IVolunteerAuthRepository {
  final IVolunteerAuthDataSource _authVolunteerDataSource;

  VolunteerAuthRepository({
    required IVolunteerAuthDataSource authVolunteerDataSource,
  }) : _authVolunteerDataSource = authVolunteerDataSource;
  @override
  Future<Either<Failure, VolunteerAuthEntity>> getCurrentVolunteer() async {
    try {
      final volunteer = await _authVolunteerDataSource.getCurrentVolunteer();
      if (volunteer != null) {
        final entity = volunteer.toEntity();
        return Right(entity);
      }
      return Left(LocalDatabaseFailure(message: 'No user logged in'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, VolunteerAuthEntity>> loginVolunteer(
    String email,
    String password,
  ) async {
    try {
      final volunteer = await _authVolunteerDataSource.loginVolunteer(
        email,
        password,
      );
      if (volunteer != null) {
        final entity = volunteer.toEntity();
        return Right(entity);
      }
      return Left(LocalDatabaseFailure(message: 'Invalid email or password'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authVolunteerDataSource.logout();
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: 'Failed to logout user'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> registerVolunteer(
    VolunteerAuthEntity entity,
  ) async {
    try {
      //model ma convert gara
      final model = VolunteerAuthHiveModel.fromEntity(entity);
      final result = await _authVolunteerDataSource.registerVolunteer(model);
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: 'Failed to register User'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
