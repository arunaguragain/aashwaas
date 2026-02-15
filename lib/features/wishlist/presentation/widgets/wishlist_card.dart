import 'package:flutter/material.dart';

class WishlistCard extends StatelessWidget {
  final String title;
  final String category;
  final String planned;
  final String notes;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onDonate;

  const WishlistCard({
    Key? key,
    required this.title,
    required this.category,
    required this.planned,
    required this.notes,
    this.onEdit,
    this.onDelete,
    this.onDonate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: onEdit,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(category, style: const TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 8),
            Text(
              'Planned: $planned',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Notes: $notes',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7CA9F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onDonate,
                child: const Text('Donate Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
