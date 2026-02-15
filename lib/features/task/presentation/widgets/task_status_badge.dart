import 'package:flutter/material.dart';
import 'package:aashwaas/features/task/domain/entities/task_entity.dart';

class TaskStatusBadge extends StatelessWidget {
  final TaskStatus status;
  const TaskStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _statusText(status),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _statusText(TaskStatus s) {
    switch (s) {
      case TaskStatus.assigned:
        return 'Pending';
      case TaskStatus.accepted:
        return 'Accepted';
      case TaskStatus.rejected:
        return 'Rejected';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  Color _statusColor(TaskStatus s) {
    switch (s) {
      case TaskStatus.assigned:
        return const Color(0xFF7B61FF); // purple
      case TaskStatus.accepted:
        return const Color(0xFF2EAD63); // green
      case TaskStatus.rejected:
        return const Color(0xFFFF6B6B); // red
      case TaskStatus.completed:
        return const Color(0xFF4A90E2); // blue
    }
  }
}
