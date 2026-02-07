import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/services/connectivity/network_info.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/auth/data/datasources/donor_auth_datasource.dart';
import 'package:aashwaas/features/auth/data/datasources/local/donor_auth_local_datasource.dart';
import 'package:aashwaas/features/auth/data/datasources/remote/donor_auth_remote_datasource.dart';
import 'package:aashwaas/features/auth/data/models/donor_auth_api_model.dart';
import 'package:aashwaas/features/auth/data/models/donor_auth_hive_model.dart';
import 'package:aashwaas/features/auth/domain/entities/donor_auth_entity.dart';
import 'package:aashwaas/features/auth/domain/repositories/donor_auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authDonorRepositoryProvider = Provider<IDonorAuthRepository>((ref) {
  final authDonorLocalDataSource = ref.read(authDonorLocalDatasourceProvider);
  final authDonorRemoteDataSource = ref.read(authDonorRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return DonorAuthRepository(
    authDonorDataSource: authDonorLocalDataSource,
    authDonorRemoteDataSource: authDonorRemoteDataSource,
    networkInfo: networkInfo,
    userSessionService: userSessionService,
  );
});

class DonorAuthRepository implements IDonorAuthRepository {
  final IDonorAuthLocalDataSource _authDonorDataSource;
  final IDonorAuthRemoteDataSource _authDonorRemoteDataSource;
  final NetworkInfo _networkInfo;
  final UserSessionService _userSessionService;

  DonorAuthRepository({
    required IDonorAuthLocalDataSource authDonorDataSource,
    required IDonorAuthRemoteDataSource authDonorRemoteDataSource,
    required NetworkInfo networkInfo,
    required UserSessionService userSessionService,
  }) : _authDonorDataSource = authDonorDataSource,
       _authDonorRemoteDataSource = authDonorRemoteDataSource,
       _networkInfo = networkInfo,
       _userSessionService = userSessionService;
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
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authDonorRemoteDataSource.loginDonor(
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
        final model = await _authDonorDataSource.loginDonor(email, password);
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
  Future<Either<Failure, bool>> registerDonor(DonorAuthEntity donor) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = DonorAuthApiModel.fromEntity(donor);
        await _authDonorRemoteDataSource.registerDonor(apiModel);
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
        final exisitingUser = await _authDonorDataSource.getDonorByEmail(donor.email);
        if (exisitingUser != null) {
          return const Left(
            LocalDatabaseFailure(message: "Email already registered"),
          );
        }

        final authModel = DonorAuthHiveModel(
          fullName: donor.fullName,
          email: donor.email,
          phoneNumber: donor.phoneNumber,
          password: donor.password,
          profilePicture: donor.profilePicture,
        );
        await _authDonorDataSource.registerDonor(authModel);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, DonorAuthEntity>> updateDonorProfile(
    String userId,
    String fullName,
    String phoneNumber,
    String? profilePicture,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final payload = <String, dynamic>{
          'name': fullName,
          'phoneNumber': phoneNumber,
        };
        if (profilePicture != null && profilePicture.trim().isNotEmpty) {
          payload['profilePicture'] = profilePicture;
        }
        final updated = await _authDonorRemoteDataSource.updateDonorProfile(
          userId,
          payload,
        );
        return Right(updated.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadDonorProfilePhoto(
    String userId,
    String filePath,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final result = await _authDonorRemoteDataSource.uploadDonorPhoto(
          userId,
          filePath,
        );
        return Right(result);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
