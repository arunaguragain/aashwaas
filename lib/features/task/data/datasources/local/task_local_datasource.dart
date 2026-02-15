import 'package:aashwaas/core/constants/hive_table_constant.dart';
import 'package:aashwaas/features/task/data/models/task_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final taskLocalDatasourceProvider = Provider<TaskLocalDatasource>((ref) {
  return TaskLocalDatasource();
});

class TaskLocalDatasource {
  Box<TaskHiveModel> get _box =>
      Hive.box<TaskHiveModel>(HiveTableConstant.taskTable);

  Future<void> cacheAllTasks(List<TaskHiveModel> tasks) async {
    await _box.clear();
    for (var t in tasks) {
      await _box.put(t.taskId, t);
    }
  }

  Future<List<TaskHiveModel>> getAllTasks() async {
    return _box.values.cast<TaskHiveModel>().toList();
  }

  Future<TaskHiveModel?> getTaskById(String id) async {
    return _box.get(id);
  }

  Future<List<TaskHiveModel>> getTasksByVolunteer(String volunteerId) async {
    return _box.values
        .where((t) => t.volunteerId == volunteerId)
        .cast<TaskHiveModel>()
        .toList();
  }

  Future<bool> updateTask(TaskHiveModel model) async {
    await _box.put(model.taskId, model);
    return true;
  }
}
