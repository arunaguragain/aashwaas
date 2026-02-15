import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/task/data/repositories/task_repository.dart';
import 'package:aashwaas/features/task/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcceptTaskParams extends Equatable {
  final String taskId;

  const AcceptTaskParams({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

final acceptTaskUsecaseProvider = Provider<AcceptTaskUsecase>((ref) {
  final taskRepository = ref.read(taskRepositoryProvider);
  return AcceptTaskUsecase(taskRepository: taskRepository);
});

class AcceptTaskUsecase implements UsecaseWithParams<bool, AcceptTaskParams> {
  final ITaskRepository _taskRepository;

  AcceptTaskUsecase({required ITaskRepository taskRepository})
    : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, bool>> call(AcceptTaskParams params) {
    return _taskRepository.acceptTask(params.taskId);
  }
}
