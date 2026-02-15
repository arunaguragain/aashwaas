import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/task/data/repositories/task_repository.dart';
import 'package:aashwaas/features/task/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompleteTaskParams extends Equatable {
  final String taskId;

  const CompleteTaskParams({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

final completeTaskUsecaseProvider = Provider<CompleteTaskUsecase>((ref) {
  final taskRepository = ref.read(taskRepositoryProvider);
  return CompleteTaskUsecase(taskRepository: taskRepository);
});

class CompleteTaskUsecase
    implements UsecaseWithParams<bool, CompleteTaskParams> {
  final ITaskRepository _taskRepository;

  CompleteTaskUsecase({required ITaskRepository taskRepository})
    : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, bool>> call(CompleteTaskParams params) {
    return _taskRepository.completeTask(params.taskId);
  }
}
