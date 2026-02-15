import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/services/connectivity/network_info.dart';
import 'package:aashwaas/features/task/data/datasources/remote/task_remote_datasource.dart';
import 'package:aashwaas/features/task/data/datasources/task_datasource.dart';
import 'package:aashwaas/features/task/data/models/task_hive_model.dart';
import 'package:aashwaas/features/task/data/datasources/local/task_local_datasource.dart';
import 'package:aashwaas/features/task/domain/entities/task_entity.dart';
import 'package:aashwaas/features/task/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final taskRepositoryProvider = Provider<ITaskRepository>((ref) {
  final remoteDatasource = ref.read(taskRemoteDataSourceProvider);
  final localDatasource = ref.read(taskLocalDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return TaskRepository(
    remoteDatasource: remoteDatasource,
    localDatasource: localDatasource,
    networkInfo: networkInfo,
  );
});

class TaskRepository implements ITaskRepository {
  final ITaskRemoteDataSource _remoteDataSource;
  final TaskLocalDatasource _localDataSource;
  final NetworkInfo _networkInfo;

  TaskRepository({
    required ITaskRemoteDataSource remoteDatasource,
    required TaskLocalDatasource localDatasource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDatasource,
       _localDataSource = localDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<TaskEntity>>> getAllTasks() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getAllTasks();
        final entities = models.map((m) => m.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getTasksByVolunteer(
    String volunteerId,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getTasksByVolunteer(volunteerId);
        final entities = models.map((m) => m.toEntity()).toList();
        // cache locally
        final hiveModels = TaskHiveModel.fromApiModelList(models);
        await _localDataSource.cacheAllTasks(hiveModels);
        return Right(entities);
      } catch (e) {
        // fallback to local
        try {
            final local = await _localDataSource.getTasksByVolunteer(volunteerId);
            final entities = local.map((e) => e.toEntity()).toList();
          return Right(entities);
        } catch (e) {
          return Left(ApiFailure(message: e.toString()));
        }
      }
    } else {
      try {
        final local = await _localDataSource.getTasksByVolunteer(volunteerId);
        final entities = local.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    }
  }

  Future<Either<Failure, bool>> _execBoolRemote(
    Future<bool> Function() op,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final res = await op();
        return Right(res);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    }
    return const Left(NetworkFailure(message: 'No internet connection'));
  }

  @override
  Future<Either<Failure, bool>> acceptTask(String taskId) =>
      _execBoolRemote(() => _remoteDataSource.acceptTask(taskId));

  @override
  Future<Either<Failure, bool>> completeTask(String taskId) =>
      _execBoolRemote(() => _remoteDataSource.completeTask(taskId));

  @override
  Future<Either<Failure, bool>> cancelTask(String taskId) =>
      _execBoolRemote(() => _remoteDataSource.cancelTask(taskId));

  @override
  Future<Either<Failure, TaskEntity>> getTaskById(String taskId) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = await _remoteDataSource.getTaskById(taskId);
        // cache single
        final hiveModel = TaskHiveModel.fromApiModel(model);
        await _localDataSource.updateTask(hiveModel);
        return Right(model.toEntity());
      } catch (e) {
        // fallback to local
        try {
          final local = await _localDataSource.getTaskById(taskId);
          if (local != null) return Right(local.toEntity());
          return Left(ApiFailure(message: e.toString()));
        } catch (e) {
          return Left(ApiFailure(message: e.toString()));
        }
      }
    } else {
      try {
        final local = await _localDataSource.getTaskById(taskId);
        if (local != null) return Right((local).toEntity());
        return const Left(
          LocalDatabaseFailure(message: 'Task not found locally'),
        );
      } catch (e) {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    }
  }

  @override
  Future<Either<Failure, List<TaskEntity>>> getMyTasks() async {
    if (await _networkInfo.isConnected) {
      try {
        final models = await _remoteDataSource.getMyTasks();
        final entities = models.map((m) => m.toEntity()).toList();
        // cache
        final hiveModels = TaskHiveModel.fromApiModelList(models);
        await _localDataSource.cacheAllTasks(hiveModels);
        return Right(entities);
      } catch (e) {
        // fallback to local
        try {
          final local = await _localDataSource.getAllTasks();
            final entities = local.map((e) => e.toEntity()).toList();
          return Right(entities);
        } catch (e) {
          return Left(ApiFailure(message: e.toString()));
        }
      }
    } else {
      try {
        final local = await _localDataSource.getAllTasks();
        final entities = local.map((e) => e.toEntity()).toList();
        return Right(entities);
      } catch (e) {
        return const Left(NetworkFailure(message: 'No internet connection'));
      }
    }
  }
}
