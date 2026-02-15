import 'package:flutter/material.dart';

class WishlistStatCard extends StatelessWidget {
  final String title;
  final String value;

  const WishlistStatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor),
          boxShadow: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(title, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(value, style: theme.textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
