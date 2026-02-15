import 'package:aashwaas/core/error/failures.dart';
import 'package:aashwaas/core/usecases/app_usecase.dart';
import 'package:aashwaas/features/task/data/repositories/task_repository.dart';
import 'package:aashwaas/features/task/domain/entities/task_entity.dart';
import 'package:aashwaas/features/task/domain/repositories/task_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GetTasksByVolunteerParams extends Equatable {
  final String volunteerId;

  const GetTasksByVolunteerParams({required this.volunteerId});

  @override
  List<Object?> get props => [volunteerId];
}

final getTasksByVolunteerUsecaseProvider = Provider<GetTasksByVolunteerUsecase>(
  (ref) {
    final taskRepository = ref.read(taskRepositoryProvider);
    return GetTasksByVolunteerUsecase(taskRepository: taskRepository);
  },
);

class GetTasksByVolunteerUsecase
    implements UsecaseWithParams<List<TaskEntity>, GetTasksByVolunteerParams> {
  final ITaskRepository _taskRepository;

  GetTasksByVolunteerUsecase({required ITaskRepository taskRepository})
    : _taskRepository = taskRepository;

  @override
  Future<Either<Failure, List<TaskEntity>>> call(
    GetTasksByVolunteerParams params,
  ) {
    return _taskRepository.getTasksByVolunteer(params.volunteerId);
  }
}
