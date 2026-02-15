import 'package:aashwaas/features/task/data/models/task_api_model.dart';
import 'package:aashwaas/features/task/data/models/task_hive_model.dart';

abstract interface class ITaskRemoteDataSource {
  Future<TaskApiModel> getTaskById(String taskId);
  Future<List<TaskApiModel>> getAllTasks();
  Future<List<TaskApiModel>> getTasksByVolunteer(String volunteerId);
  Future<List<TaskApiModel>> getMyTasks();
  Future<bool> acceptTask(String taskId);
  Future<bool> completeTask(String taskId);
  Future<bool> cancelTask(String taskId);
}

abstract interface class ITaskLocalDataSource {
  Future<void> cacheAllTasks(List<TaskHiveModel> tasks);
  Future<List<TaskHiveModel>> getAllTasks();
  Future<TaskHiveModel?> getTaskById(String id);
  Future<List<TaskHiveModel>> getTasksByVolunteer(String volunteerId);
  Future<bool> updateTask(TaskHiveModel model);
}
