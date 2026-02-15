import 'package:aashwaas/features/task/domain/entities/task_entity.dart';
import 'package:equatable/equatable.dart';

enum TaskViewStatus {
  initial,
  loading,
  loaded,
  error,
  accepted,
  completed,
  cancelled,
}

class TaskState extends Equatable {
  final TaskViewStatus status;
  final List<TaskEntity> tasks;
  final List<TaskEntity> myTasks;
  final TaskEntity? selectedTask;
  final String? errorMessage;
  final int totalTaskCount;

  const TaskState({
    this.status = TaskViewStatus.initial,
    this.tasks = const [],
    this.myTasks = const [],
    this.selectedTask,
    this.errorMessage,
    this.totalTaskCount = 0,
  });

  TaskState copyWith({
    TaskViewStatus? status,
    List<TaskEntity>? tasks,
    List<TaskEntity>? myTasks,
    TaskEntity? selectedTask,
    bool resetSelectedTask = false,
    String? errorMessage,
    bool resetErrorMessage = false,
    int? totalTaskCount,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      myTasks: myTasks ?? this.myTasks,
      selectedTask: resetSelectedTask
          ? null
          : (selectedTask ?? this.selectedTask),
      errorMessage: resetErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
      totalTaskCount: totalTaskCount ?? this.totalTaskCount,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tasks,
    myTasks,
    selectedTask,
    errorMessage,
    totalTaskCount,
  ];
}
