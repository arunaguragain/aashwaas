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
