import 'package:flutter/material.dart';

enum TaskStatus { completed, pendingReview, pending }

class TaskCard extends StatelessWidget {
  final String title;
  final String pickup;
  final String drop;
  final String date;
  final String phone;
  final TaskStatus status;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const TaskCard({
    super.key,
    required this.title,
    required this.pickup,
    required this.drop,
    required this.date,
    required this.phone,
    required this.status,
    this.onAccept,
    this.onDecline,
  });

  Color get statusColor {
    switch (status) {
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.pendingReview:
        return Colors.orange;
      case TaskStatus.pending:
        return Colors.blue;
    }
  }

  String get statusText {
    switch (status) {
      case TaskStatus.completed:
        return "Completed";
      case TaskStatus.pendingReview:
        return "Pending Review";
      case TaskStatus.pending:
        return "Pending";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            _infoRow(Icons.location_on, "Pick up: $pickup"),
            _infoRow(Icons.flag, "Drop: $drop"),
            _infoRow(Icons.calendar_today, date),
            _infoRow(Icons.phone, phone),

            if (status == TaskStatus.pendingReview) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Accept",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onDecline,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Decline"),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
