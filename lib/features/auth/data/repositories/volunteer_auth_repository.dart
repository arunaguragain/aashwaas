import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/services/connectivity/network_info.dart';
import 'package:aashwaas/features/auth/data/datasources/local/volunteer_auth_local_datasource.dart';
import 'package:aashwaas/features/auth/data/datasources/remote/volunteer_auth_remote_datasource.dart';
import 'package:aashwaas/features/auth/data/datasources/volunteer_auth_datasource.dart';
import 'package:aashwaas/features/auth/data/models/volunteer_auth_api_model.dart';
import 'package:aashwaas/features/auth/data/models/volunteer_auth_hive_model.dart';
import 'package:aashwaas/features/auth/domain/entities/volunteer_auth_entity.dart';
import 'package:aashwaas/features/auth/domain/repositories/volunteer_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authVolunteerRepositoryProvider = Provider<IVolunteerAuthRepository>((ref) {
  final authVolunteerLocalDataSource = ref.read(authVolunteerLocalDatasourceProvider);
  final authVolunteerRemoteDataSource = ref.read(authVolunteerRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return VolunteerAuthRepository(
    authVolunteerDataSource: authVolunteerLocalDataSource,
    authVolunteerRemoteDataSource: authVolunteerRemoteDataSource,
    networkInfo: networkInfo,
  );
});

class VolunteerAuthRepository implements IVolunteerAuthRepository {
  final IVolunteerAuthLocalDataSource _authVolunteerDataSource;
  final IVolunteerAuthRemoteDataSource _authVolunteerRemoteDataSource;
  final NetworkInfo _networkInfo;

  VolunteerAuthRepository({
    required IVolunteerAuthLocalDataSource authVolunteerDataSource,
    required IVolunteerAuthRemoteDataSource authVolunteerRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _authVolunteerDataSource = authVolunteerDataSource,
       _authVolunteerRemoteDataSource = authVolunteerRemoteDataSource,
       _networkInfo = networkInfo;
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
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authVolunteerRemoteDataSource.loginVolunteer(
          email,
          password,
        );
        if (apiModel != null) {
          final entity = apiModel.toEntity();
          return Right(entity);
        }
        return const Left(ApiFailure(message: 'Invalid credentials'));
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Login Failed',
            statuscode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _authVolunteerDataSource.loginVolunteer(email, password);
        if (model != null) {
          final entity = model.toEntity();
          return Right(entity);
        }
        return const Left(
          LocalDatabaseFailure(message: 'Invalid email or password'),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
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
  Future<Either<Failure, bool>> registerVolunteer(VolunteerAuthEntity volunteer,) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = VolunteerAuthApiModel.fromEntity(volunteer);
        await _authVolunteerRemoteDataSource.registerVolunteer(apiModel);
        return const Right(true);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            message: e.response?.data['message'] ?? 'Registration Failed',
            statuscode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final exisitingUser = await _authVolunteerDataSource.getVolunteerByEmail(volunteer.email);
        if (exisitingUser != null) {
          return const Left(
            LocalDatabaseFailure(message: "Email already registered"),
          );
        }

        final authModel = VolunteerAuthHiveModel(
          fullName: volunteer.fullName,
          email: volunteer.email,
          phoneNumber: volunteer.phoneNumber,
          password: volunteer.password,
          profilePicture: volunteer.profilePicture,
        );
        await _authVolunteerDataSource.registerVolunteer(authModel);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
