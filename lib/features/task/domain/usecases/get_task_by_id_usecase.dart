import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/task/data/repositories/task_repository.dart';
import 'package:aashwaas/features/task/domain/entities/task_entity.dart';
import 'package:aashwaas/features/task/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetTaskByIdParams extends Equatable {
  final String taskId;

  const GetTaskByIdParams({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

final getTaskByIdUsecaseProvider = Provider<GetTaskByIdUsecase>((ref) {
  final taskRepository = ref.read(taskRepositoryProvider);
  return GetTaskByIdUsecase(taskRepository: taskRepository);
});

class GetTaskByIdUsecase
    implements UsecaseWithParams<TaskEntity, GetTaskByIdParams> {
  final ITaskRepository _taskRepository;

  GetTaskByIdUsecase({required ITaskRepository taskRepository})
    : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, TaskEntity>> call(GetTaskByIdParams params) {
    return _taskRepository.getTaskById(params.taskId);
  }
}
