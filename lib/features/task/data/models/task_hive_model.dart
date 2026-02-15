import 'package:aashwaas/core/constants/hive_table_constant.dart';
import 'package:aashwaas/features/task/domain/entities/task_entity.dart';
import 'package:aashwaas/features/task/data/models/task_api_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'task_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.taskTypeId)
class TaskHiveModel extends HiveObject {
  @HiveField(0)
  final String? taskId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? donationId;

  @HiveField(3)
  final String? volunteerId;

  @HiveField(4)
  final String? ngoId;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final DateTime? assignedAt;

  @HiveField(7)
  final DateTime? acceptedAt;

  @HiveField(8)
  final DateTime? completedAt;

  @HiveField(9)
  final DateTime? createdAt;

  @HiveField(10)
  final DateTime? updatedAt;

  TaskHiveModel({
    String? taskId,
    required this.title,
    this.donationId,
    this.volunteerId,
    this.ngoId,
    String? status,
    this.assignedAt,
    this.acceptedAt,
    this.completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : taskId = taskId ?? const Uuid().v4(),
        status = status ?? 'assigned',
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt;

  factory TaskHiveModel.fromEntity(TaskEntity entity) {
    return TaskHiveModel(
      taskId: entity.taskId,
      title: entity.title,
      donationId: entity.donationId,
      volunteerId: entity.volunteerId,
      ngoId: entity.ngoId,
      status: entity.status.toString().split('.').last,
      assignedAt: entity.assignedAt,
      acceptedAt: entity.acceptedAt,
      completedAt: entity.completedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  TaskEntity toEntity() {
    // Map status string back to enum if possible; default to assigned
    TaskStatus statusEnum;
    switch (status) {
      case 'accepted':
        statusEnum = TaskStatus.accepted;
        break;
      case 'rejected':
        statusEnum = TaskStatus.rejected;
        break;
      case 'completed':
        statusEnum = TaskStatus.completed;
        break;
      case 'assigned':
      default:
        statusEnum = TaskStatus.assigned;
    }

    return TaskEntity(
      taskId: taskId,
      title: title,
      donationId: donationId ?? '',
      volunteerId: volunteerId ?? '',
      ngoId: ngoId,
      status: statusEnum,
      assignedAt: assignedAt,
      acceptedAt: acceptedAt,
      completedAt: completedAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory TaskHiveModel.fromApiModel(TaskApiModel apiModel) {
    return TaskHiveModel(
      taskId: apiModel.id,
      title: apiModel.title,
      donationId: apiModel.donationId,
      volunteerId: apiModel.volunteerId,
      ngoId: apiModel.ngoId,
      status: apiModel.status.toString().split('.').last,
      assignedAt: apiModel.assignedAt,
      acceptedAt: apiModel.acceptedAt,
      completedAt: apiModel.completedAt,
      createdAt: apiModel.createdAt,
      updatedAt: apiModel.updatedAt,
    );
  }

  static List<TaskHiveModel> fromApiModelList(List<TaskApiModel> apiModels) {
    return apiModels.map((m) => TaskHiveModel.fromApiModel(m)).toList();
  }
}
