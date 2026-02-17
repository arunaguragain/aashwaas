import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/services/connectivity/network_info.dart';
import 'package:aashwaas/features/review/data/datasources/local/review_local_datasource.dart';
import 'package:aashwaas/features/review/data/datasources/remote/review_remote_datasource.dart';
import 'package:aashwaas/features/review/data/datasources/review_datasource.dart';
import 'package:aashwaas/features/review/data/models/review_api_model.dart';
import 'package:aashwaas/features/review/data/models/review_hive_model.dart';
import 'package:aashwaas/features/review/domain/entities/review_entity.dart';
import 'package:aashwaas/features/review/domain/repositories/review_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewRepositoryProvider = Provider<IReviewRepository>((ref) {
  final localDatasource = ref.read(reviewLocalDatasourceProvider);
  final remoteDatasource = ref.read(reviewRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return ReviewRepository(
    localDatasource: localDatasource,
    remoteDatasource: remoteDatasource,
    networkInfo: networkInfo,
  );
});

class ReviewRepository implements IReviewRepository {
  final ReviewLocalDatasource _localDataSource;
  final IReviewRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  ReviewRepository({
    required ReviewLocalDatasource localDatasource,
    required IReviewRemoteDataSource remoteDatasource,
    required NetworkInfo networkInfo,
  }) : _localDataSource = localDatasource,
       _remoteDataSource = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<ReviewEntity>>> getAllReviews() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAllReviews();
        final hiveModels = ReviewHiveModel.fromApiModelList(models);
        await _localDataSource.cacheAllReviews(hiveModels);
        final entities = ReviewApiModel.toEntityList(models);
        return Right(entities);
      } catch (e) {
        return _getCachedReviews();
      }
    } else {
      return _getCachedReviews();
    }
  }

  Future<Either<Failure, List<ReviewEntity>>> _getCachedReviews() async {
    try {
      final models = await _localDataSource.getAllReviews();
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviewsByUser(
    String userId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getReviewsByUser(userId);
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final models = await _localDataSource.getReviewsByUser(userId);
        final entities = models.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> getReviewById(String reviewId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getReviewById(reviewId);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final model = await _localDataSource.getReviewById(reviewId);
        if (model != null) {
          return Right(model.toEntity());
        }
        return const Left(LocalDatabaseFailure(message: 'Review not found'));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> createReview(ReviewEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final reviewApiModel = ReviewApiModel.fromEntity(entity);
        await _remoteDataSource.createReview(reviewApiModel);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, bool>> updateReview(ReviewEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final reviewApiModel = ReviewApiModel.fromEntity(entity);
        await _remoteDataSource.updateReview(reviewApiModel);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final reviewModel = ReviewHiveModel.fromEntity(entity);
        final result = await _localDataSource.updateReview(reviewModel);
        if (result) {
          return const Right(true);
        }
        return const Left(
          LocalDatabaseFailure(message: "Failed to update review"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> deleteReview(String reviewId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteReview(reviewId);
        return const Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final result = await _localDataSource.deleteReview(reviewId);
        if (result) {
          return const Right(true);
        }
        return const Left(
          LocalDatabaseFailure(message: "Failed to delete review"),
        );
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}
