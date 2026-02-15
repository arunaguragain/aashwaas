import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/task/data/repositories/task_repository.dart';
import 'package:aashwaas/features/task/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CancelTaskParams extends Equatable {
  final String taskId;

  const CancelTaskParams({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

final cancelTaskUsecaseProvider = Provider<CancelTaskUsecase>((ref) {
  final taskRepository = ref.read(taskRepositoryProvider);
  return CancelTaskUsecase(taskRepository: taskRepository);
});

class CancelTaskUsecase implements UsecaseWithParams<bool, CancelTaskParams> {
  final ITaskRepository _taskRepository;

  CancelTaskUsecase({required ITaskRepository taskRepository})
    : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, bool>> call(CancelTaskParams params) {
    return _taskRepository.cancelTask(params.taskId);
  }
}
