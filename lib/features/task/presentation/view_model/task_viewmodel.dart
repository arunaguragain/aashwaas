import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/features/task/presentation/state/task_state.dart';
import 'package:aashwaas/features/task/domain/usecases/get_all_tasks_usecase.dart';
import 'package:aashwaas/features/task/domain/usecases/get_tasks_by_volunteer_usecase.dart';
import 'package:aashwaas/features/task/domain/usecases/accept_task_usecase.dart';
import 'package:aashwaas/features/task/domain/usecases/complete_task_usecase.dart';
import 'package:aashwaas/features/task/domain/usecases/cancel_task_usecase.dart';
import 'package:aashwaas/features/task/domain/usecases/get_task_by_id_usecase.dart';
import 'package:aashwaas/features/task/domain/usecases/get_my_tasks_usecase.dart';

final taskViewModelProvider = NotifierProvider<TaskViewModel, TaskState>(
  TaskViewModel.new,
);

class TaskViewModel extends Notifier<TaskState> {
  late final GetAllTasksUsecase _getAllTasksUsecase;
  late final GetTasksByVolunteerUsecase _getTasksByVolunteerUsecase;
  late final AcceptTaskUsecase _acceptTaskUsecase;
  late final CompleteTaskUsecase _completeTaskUsecase;
  late final CancelTaskUsecase _cancelTaskUsecase;
  late final GetTaskByIdUsecase _getTaskByIdUsecase;
  late final GetMyTasksUsecase _getMyTasksUsecase;

  @override
  TaskState build() {
    _getAllTasksUsecase = ref.read(getAllTasksUsecaseProvider);
    _getTasksByVolunteerUsecase = ref.read(getTasksByVolunteerUsecaseProvider);
    _acceptTaskUsecase = ref.read(acceptTaskUsecaseProvider);
    _completeTaskUsecase = ref.read(completeTaskUsecaseProvider);
    _cancelTaskUsecase = ref.read(cancelTaskUsecaseProvider);
    _getTaskByIdUsecase = ref.read(getTaskByIdUsecaseProvider);
    _getMyTasksUsecase = ref.read(getMyTasksUsecaseProvider);
    return const TaskState();
  }

  Future<void> getAllTasks() async {
    state = state.copyWith(status: TaskViewStatus.loading);

    final result = await _getAllTasksUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: TaskViewStatus.error,
        errorMessage: failure.message,
      ),
      (tasks) => state = state.copyWith(
        status: TaskViewStatus.loaded,
        tasks: tasks,
        totalTaskCount: tasks.length,
      ),
    );
  }

  Future<void> getTasksByVolunteer(String volunteerId) async {
    state = state.copyWith(status: TaskViewStatus.loading);

    final result = await _getTasksByVolunteerUsecase(
      GetTasksByVolunteerParams(volunteerId: volunteerId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: TaskViewStatus.error,
        errorMessage: failure.message,
      ),
      (tasks) => state = state.copyWith(
        status: TaskViewStatus.loaded,
        tasks: tasks,
        totalTaskCount: tasks.length,
      ),
    );
  }

  Future<void> acceptTask(String taskId) async {
    state = state.copyWith(status: TaskViewStatus.loading);

    final result = await _acceptTaskUsecase(AcceptTaskParams(taskId: taskId));

    result.fold(
      (failure) => state = state.copyWith(
        status: TaskViewStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: TaskViewStatus.accepted);
        getAllTasks();
      },
    );
  }

  Future<void> completeTask(String taskId) async {
    state = state.copyWith(status: TaskViewStatus.loading);

    final result = await _completeTaskUsecase(
      CompleteTaskParams(taskId: taskId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: TaskViewStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: TaskViewStatus.completed);
        getAllTasks();
      },
    );
  }

  Future<void> cancelTask(String taskId) async {
    state = state.copyWith(status: TaskViewStatus.loading);

    final result = await _cancelTaskUsecase(CancelTaskParams(taskId: taskId));

    result.fold(
      (failure) => state = state.copyWith(
        status: TaskViewStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        state = state.copyWith(status: TaskViewStatus.cancelled);
        getAllTasks();
      },
    );
  }

  Future<void> getTaskById(String taskId) async {
    state = state.copyWith(status: TaskViewStatus.loading);

    final result = await _getTaskByIdUsecase(GetTaskByIdParams(taskId: taskId));

    result.fold(
      (failure) => state = state.copyWith(
        status: TaskViewStatus.error,
        errorMessage: failure.message,
      ),
      (task) => state = state.copyWith(
        status: TaskViewStatus.loaded,
        selectedTask: task,
      ),
    );
  }

  Future<void> getMyTasks() async {
    state = state.copyWith(status: TaskViewStatus.loading);

    final result = await _getMyTasksUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: TaskViewStatus.error,
        errorMessage: failure.message,
      ),
      (tasks) => state = state.copyWith(
        status: TaskViewStatus.loaded,
        myTasks: tasks,
        totalTaskCount: tasks.length,
      ),
    );
  }

  void clearError() {
    state = state.copyWith(resetErrorMessage: true);
  }

  void clearSelectedTask() {
    state = state.copyWith(resetSelectedTask: true);
  }

  void clearTaskState() {
    state = state.copyWith(
      status: TaskViewStatus.initial,
      resetErrorMessage: true,
      resetSelectedTask: true,
    );
  }
}
