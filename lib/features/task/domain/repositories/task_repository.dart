import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/features/task/domain/entities/task_entity.dart';
import 'package:dartz/dartz.dart';

abstract interface class ITaskRepository {
  Future<Either<Failure, List<TaskEntity>>> getAllTasks();
  Future<Either<Failure, List<TaskEntity>>> getTasksByVolunteer(
    String volunteerId,
  );
  Future<Either<Failure, bool>> acceptTask(String taskId);
  Future<Either<Failure, bool>> completeTask(String taskId);
  Future<Either<Failure, bool>> cancelTask(String taskId);
  Future<Either<Failure, TaskEntity>> getTaskById(String taskId);
  Future<Either<Failure, List<TaskEntity>>> getMyTasks();
}
