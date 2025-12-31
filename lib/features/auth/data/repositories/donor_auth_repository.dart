import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/auth/data/datasources/donor_auth_datasource.dart';
import 'package:aashwaas/features/auth/data/datasources/local/donor_auth_local_datasource.dart';
import 'package:aashwaas/features/auth/data/models/donor_auth_hive_model.dart';
import 'package:aashwaas/features/auth/domain/entities/donor_auth_entity.dart';
import 'package:aashwaas/features/auth/domain/repositories/donor_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authDonorRepositoryProvider = Provider<IDonorAuthRepository>((ref) {
  return DonorAuthRepository(authDonorDataSource: ref.read(authDonorLocalDatasourceProvider));
});

class DonorAuthRepository implements IDonorAuthRepository {
  final IDonorAuthDataSource _authDonorDataSource;

  DonorAuthRepository({required IDonorAuthDataSource authDonorDataSource})
    : _authDonorDataSource = authDonorDataSource;
  @override
  Future<Either<Failure, DonorAuthEntity>> getCurrentDonor() async {
    try {
      final donor = await _authDonorDataSource.getCurrentDonor();
      if (donor != null) {
        final entity = donor.toEntity();
        return Right(entity);
      }
      return Left(LocalDatabaseFailure(message: 'No user logged in'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DonorAuthEntity>> loginDonor(
    String email,
    String password,
  ) async {
    try {
      final donor = await _authDonorDataSource.loginDonor(email, password);
      if (donor != null) {
        final entity = donor.toEntity();
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
      final result = await _authDonorDataSource.logout();
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: 'Failed to logout user'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> registerDonor(DonorAuthEntity entity) async {
    try {
      //model ma convert gara
      final model = DonorAuthHiveModel.fromEntity(entity);
      final result = await _authDonorDataSource.registerDonor(model);
      if (result) {
        return Right(true);
      }
      return Left(LocalDatabaseFailure(message: 'Failed to register User'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
