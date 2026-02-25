import 'package:equatable/equatable.dart';

enum TaskStatus { assigned, accepted, rejected, completed }

class TaskEntity extends Equatable {
  final String? taskId;
  final String title;
  final String donationId;
  final String volunteerId;
  final String? ngoId;
  final TaskStatus status;
  final DateTime? assignedAt;
  final DateTime? acceptedAt;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TaskEntity({
    this.taskId,
    required this.title,
    required this.donationId,
    required this.volunteerId,
    this.ngoId,
    this.status = TaskStatus.assigned,
    this.assignedAt,
    this.acceptedAt,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
  });

  TaskEntity copyWith({
    String? taskId,
    String? title,
    String? donationId,
    String? volunteerId,
    String? ngoId,
    TaskStatus? status,
    DateTime? assignedAt,
    DateTime? acceptedAt,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TaskEntity(
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      donationId: donationId ?? this.donationId,
      volunteerId: volunteerId ?? this.volunteerId,
      ngoId: ngoId ?? this.ngoId,
      status: status ?? this.status,
      assignedAt: assignedAt ?? this.assignedAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    taskId,
    title,
    donationId,
    volunteerId,
    ngoId,
    status,
    assignedAt,
    acceptedAt,
    completedAt,
    createdAt,
    updatedAt,
  ];
}
