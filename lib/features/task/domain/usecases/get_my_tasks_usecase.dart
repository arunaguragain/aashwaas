import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/task/data/repositories/task_repository.dart';
import 'package:aashwaas/features/task/domain/entities/task_entity.dart';
import 'package:aashwaas/features/task/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getMyTasksUsecaseProvider = Provider<GetMyTasksUsecase>((ref) {
  final taskRepository = ref.read(taskRepositoryProvider);
  return GetMyTasksUsecase(taskRepository: taskRepository);
});

class GetMyTasksUsecase implements UsecaseWithoutParams<List<TaskEntity>> {
  final ITaskRepository _taskRepository;

  GetMyTasksUsecase({required ITaskRepository taskRepository})
    : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, List<TaskEntity>>> call() {
    return _taskRepository.getMyTasks();
  }
}
