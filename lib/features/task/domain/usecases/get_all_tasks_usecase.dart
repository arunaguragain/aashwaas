import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/task/data/repositories/task_repository.dart';
import 'package:aashwaas/features/task/domain/entities/task_entity.dart';
import 'package:aashwaas/features/task/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllTasksUsecaseProvider = Provider<GetAllTasksUsecase>((ref) {
  final taskRepository = ref.read(taskRepositoryProvider);
  return GetAllTasksUsecase(taskRepository: taskRepository);
});

class GetAllTasksUsecase implements UsecaseWithoutParams<List<TaskEntity>> {
  final ITaskRepository _taskRepository;

  GetAllTasksUsecase({required ITaskRepository taskRepository})
    : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, List<TaskEntity>>> call() {
    return _taskRepository.getAllTasks();
  }
}
