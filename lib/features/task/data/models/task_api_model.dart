import 'package:json_annotation/json_annotation.dart';
import 'package:aashwaas/features/task/domain/entities/task_entity.dart';

part 'task_api_model.g.dart';

String? _extractId(dynamic value) {
  if (value == null) return null;
  if (value is Map) return value['_id'] as String?;
  return value as String?;
}

TaskStatus _statusFromString(String? status) {
  switch (status) {
    case 'accepted':
      return TaskStatus.accepted;
    case 'rejected':
      return TaskStatus.rejected;
    case 'completed':
      return TaskStatus.completed;
    case 'assigned':
    default:
      return TaskStatus.assigned;
  }
}

String _statusToString(TaskStatus status) {
  switch (status) {
    case TaskStatus.accepted:
      return 'accepted';
    case TaskStatus.rejected:
      return 'rejected';
    case TaskStatus.completed:
      return 'completed';
    case TaskStatus.assigned:
    return 'assigned';
  }
}

@JsonSerializable()
class TaskApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String title;
  @JsonKey(fromJson: _extractId)
  final String? donationId;
  @JsonKey(fromJson: _extractId)
  final String? volunteerId;
  @JsonKey(fromJson: _extractId)
  final String? ngoId;
  @JsonKey(fromJson: _statusFromString, toJson: _statusToString)
  final TaskStatus status;
  final DateTime? assignedAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskApiModel({
    this.id,
    required this.title,
    this.donationId,
    this.volunteerId,
    this.ngoId,
    this.status = TaskStatus.assigned,
    this.assignedAt,
    this.acceptedAt,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory TaskApiModel.fromJson(Map<String, dynamic> json) =>
      _$TaskApiModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskApiModelToJson(this);

  TaskEntity toEntity() => TaskEntity(
        taskId: id,
        title: title,
        donationId: donationId ?? '',
        volunteerId: volunteerId ?? '',
        ngoId: ngoId,
        status: status,
        assignedAt: assignedAt,
        acceptedAt: acceptedAt,
        completedAt: completedAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory TaskApiModel.fromEntity(TaskEntity entity) => TaskApiModel(
    id: entity.taskId,
    title: entity.title,
    donationId: entity.donationId,
    volunteerId: entity.volunteerId,
    ngoId: entity.ngoId,
    status: TaskStatus.values[entity.status.index],
    assignedAt: entity.assignedAt,
    acceptedAt: entity.acceptedAt,
    completedAt: entity.completedAt,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );

  static List<TaskEntity> toEntityList(List<TaskApiModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }
}
