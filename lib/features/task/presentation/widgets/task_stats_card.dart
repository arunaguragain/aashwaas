import 'package:flutter/material.dart';

class TaskStatsCard extends StatelessWidget {
  final int total;
  final int assigned;
  final int accepted;
  final int completed;
  final double horizontalGap;

  const TaskStatsCard({
    super.key,
    required this.total,
    required this.assigned,
    required this.accepted,
    required this.completed,
    this.horizontalGap = 6,
  });

  Widget _buildStat(
    BuildContext context,
    String label,
    int value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalGap),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$value',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _buildStat(context, 'Total', total, theme.primaryColor),
          _buildStat(context, 'Assigned', assigned, Colors.orange),
          _buildStat(context, 'Accepted', accepted, Colors.blue),
          _buildStat(context, 'Completed', completed, Colors.green),
        ],
      ),
    );
  }
}
