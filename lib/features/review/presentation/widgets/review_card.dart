import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final double rating;
  final String? comment;
  final String? dateText;
  final String? authorName;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ReviewCard({
    super.key,
    required this.rating,
    this.comment,
    this.dateText,
    this.authorName,
    this.onEdit,
    this.onDelete,
  });

  Widget _buildStars() {
    final filled = rating.floor();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        if (i < filled) {
          return const Icon(Icons.star, size: 16, color: Colors.orange);
        }
        return const Icon(Icons.star_border, size: 16, color: Colors.orange);
      }),
    );
  }

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
                Row(
                  children: [
                    _buildStars(),
                    const SizedBox(width: 8),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (onEdit != null)
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: onEdit,
                      ),
                    if (onDelete != null)
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
            const SizedBox(height: 8),
            if (comment != null && comment!.isNotEmpty) Text(comment!),
            if (authorName != null && authorName!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'By $authorName',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            if (dateText != null) ...[
              const SizedBox(height: 8),
              Text(
                dateText!,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
