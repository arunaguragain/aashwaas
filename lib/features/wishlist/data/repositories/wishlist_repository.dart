import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/services/connectivity/network_info.dart';
import 'package:aashwaas/features/wishlist/data/datasources/wishlist_datasource.dart';
import 'package:aashwaas/features/wishlist/data/datasources/local/wishlist_local_datasource.dart';
import 'package:aashwaas/features/wishlist/data/datasources/remote/wishlist_remote_datasource.dart';
import 'package:aashwaas/features/wishlist/data/models/wishlist_api_model.dart';
import 'package:aashwaas/features/wishlist/data/models/wishlist_hive_model.dart';
import 'package:aashwaas/features/wishlist/domain/entities/wishlist_entity.dart';
import 'package:aashwaas/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final wishlistRepositoryProvider = Provider<IWishlistRepository>((ref) {
  final localDatasource = ref.read(wishlistLocalDatasourceProvider);
  final remoteDatasource = ref.read(wishlistRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return WishlistRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class WishlistRepository implements IWishlistRepository {
  final WishlistLocalDatasource _localDataSource;
  final IWishlistRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  WishlistRepository({
    required WishlistLocalDatasource localDatasource,
    required IWishlistRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _localDataSource = localDatasource,
       _remoteDataSource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<WishlistEntity>>> getAllWishlists() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAllWishlists();
        final hiveModels = WishlistHiveModel.fromApiModelList(models);
        await _localDataSource.cacheAllWishlists(hiveModels);
        final entities = WishlistApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return _getCachedWishlists();
      }
    } else {
      return _getCachedWishlists();
    }
  }

  Future<Either<Failure, List<WishlistEntity>>> _getCachedWishlists() async {
    try {
      final models = await _localDataSource.getAllWishlists();
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WishlistEntity>>> getWishlistsByDonor(
    String donorId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getWishlistsByDonor(donorId);
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getWishlistsByDonor(donorId);
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<WishlistEntity>>> getWishlistsByCategory(
    String category,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getWishlistsByCategory(category);
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getWishlistsByCategory(category);
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<WishlistEntity>>> getWishlistsByStatus(
    String status,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getWishlistsByStatus(status);
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getWishlistsByStatus(status);
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, WishlistEntity>> getWishlistById(
    String wishlistId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getWishlistById(wishlistId);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _localDataSource.getWishlistById(wishlistId);
        if (model != null) {
          return Right(model.toEntity());
        }
        return const Left(LocalDatabaseFailure(message: 'Wishlist not found'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> createWishlist(WishlistEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final wishlistApiModel = WishlistApiModel.fromEntity(entity);
        await _remoteDataSource.createWishlist(wishlistApiModel);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> updateWishlist(WishlistEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final wishlistApiModel = WishlistApiModel.fromEntity(entity);
        await _remoteDataSource.updateWishlist(wishlistApiModel);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final wishlistModel = WishlistHiveModel.fromEntity(entity);
        final result = await _localDataSource.updateWishlist(wishlistModel);
        if (result) {
          return const Right(true);
        }
        return const Left(
          LocalDatabaseFailure(message: "Failed to update wishlist"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteWishlist(String wishlistId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteWishlist(wishlistId);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _localDataSource.deleteWishlist(wishlistId);
        if (result) {
          return const Right(true);
        }
        return const Left(
          LocalDatabaseFailure(message: "Failed to delete wishlist"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
