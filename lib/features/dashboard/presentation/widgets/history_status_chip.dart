import 'package:flutter/material.dart';

class HistoryStatusChip extends StatelessWidget {
  final String status;

  const HistoryStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status.toLowerCase()) {
      case 'completed':
        color = const Color(0xFF4CAF50);
        text = 'Completed';
        break;
      case 'pending':
        color = const Color(0xFFFFA726);
        text = 'Pending';
        break;
      case 'assigned':
        color = const Color(0xFF26A69A);
        text = 'Assigned';
        break;
      case 'cancelled':
        color = Colors.red;
        text = 'Cancelled';
        break;
      case 'approved':
        color = Colors.blue;
        text = 'Approved';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, color: color)),
    );
  }
}
