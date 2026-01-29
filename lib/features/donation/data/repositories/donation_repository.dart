import 'dart:io';

import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/services/connectivity/network_info.dart';
import 'package:aashwaas/features/donation/data/datasources/donation_datasource.dart';
import 'package:aashwaas/features/donation/data/datasources/local/donation_local_datasource.dart';
import 'package:aashwaas/features/donation/data/datasources/remote/donation_remote_datasource.dart';
import 'package:aashwaas/features/donation/data/models/donation_api_model.dart';
import 'package:aashwaas/features/donation/data/models/donatioin_hive_model.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:aashwaas/features/donation/domain/repositories/donation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final donationRepositoryProvider = Provider<IDonationRepository>((ref) {
  final localDatasource = ref.read(donationLocalDatasourceProvider);
  final remoteDatasource = ref.read(donationRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return DonationRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class DonationRepository implements IDonationRepository {
  final DonationLocalDatasource _localDataSource;
  final IDonationRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  DonationRepository({
    required DonationLocalDatasource localDatasource,
    required IDonationRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _localDataSource = localDatasource,
       _remoteDataSource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<DonationEntity>>> getAllDonations() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAllDonations();
        final hiveModels = DonationHiveModel.fromApiModelList(models);
        await _localDataSource.cacheAllDonations(hiveModels);
        final entities = DonationApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {

        return _getCachedDonations();
      }
    } else {
      return _getCachedDonations();
    }
  }

  /// Helper method to get cached donations
  Future<Either<Failure, List<DonationEntity>>> _getCachedDonations() async {
    try {
      final models = await _localDataSource.getAllDonations();
      final entities = DonationHiveModel.toEntityList(models);
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DonationEntity>>> getItemsByUser(String donorId,) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getDonationsByDonor(donorId);
        final entities = DonationApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getDonationsByDonor(donorId);
        final entities = DonationHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<DonationEntity>>> getDonationsByCategory(String category,) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getDonationsByCategory(category);
        final entities = DonationApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getDonationsByCategory(category);
        final entities = DonationHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<DonationEntity>>> getDonationsByStatus(String status,) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getDonationsByStatus(status);
        final entities = DonationApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getDonationsByStatus(status);
        final entities = DonationHiveModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, DonationEntity>> getDonationById(String donationId,) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getDonationById(donationId);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _localDataSource.getDonationById(donationId);
        if (model != null) {
          return Right(model.toEntity());
        }
        return const Left(LocalDatabaseFailure(message: 'Donation not found'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> createDonation(DonationEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final donationApiModel = DonationApiModel.fromEntity(entity);
        await _remoteDataSource.createDonation(donationApiModel);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> updateDonation(DonationEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final donationApiModel = DonationApiModel.fromEntity(entity);
        await _remoteDataSource.updateDonation(donationApiModel);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final donationModel = DonationHiveModel.fromEntity(entity);
        final result = await _localDataSource.updateDonation(donationModel);
        if (result) {
          return const Right(true);
        }
        return const Left(
          LocalDatabaseFailure(message: "Failed to update donation"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteDonation(String donationId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteDonation(donationId);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _localDataSource.deleteDonation(donationId);
        if (result) {
          return const Right(true);
        }
        return const Left(
          LocalDatabaseFailure(message: "Failed to delete donation"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, String>> uploadPhoto(File photo) async {
    if (await _networkInfo.isConnected) {
      try {
        final url = await _remoteDataSource.uploadPhoto(photo);
        return Right(url);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
