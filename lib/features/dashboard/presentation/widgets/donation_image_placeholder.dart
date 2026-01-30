import 'package:aashwaas/core/api/api_endpoints.dart';
import 'package:flutter/material.dart';

class DonationImagePlaceholder extends StatelessWidget {
  final String? imageUrl;
  final String category;

  const DonationImagePlaceholder({
    super.key,
    required this.imageUrl,
    required this.category,
  });

  Color _getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'clothes':
        return const Color(0xFFBCAAA4);
      case 'books':
        return const Color(0xFF90CAF9);
      case 'electronics':
        return const Color(0xFFFFCC80);
      case 'food':
        return const Color(0xFFA5D6A7);
      case 'furniture':
        return const Color(0xFFCE93D8);
      default:
        return const Color(0xFFB0BEC5);
    }
  }

  IconData _getCategoryIcon() {
    switch (category.toLowerCase()) {
      case 'clothes':
        return Icons.checkroom;
      case 'books':
        return Icons.menu_book;
      case 'electronics':
        return Icons.devices;
      case 'food':
        return Icons.fastfood;
      case 'furniture':
        return Icons.chair;
      default:
        return Icons.inventory_2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? fullImageUrl = imageUrl != null && imageUrl!.isNotEmpty
        ? ApiEndpoints.donationPicture(imageUrl!)
        : null;

    return Container(
      height: 74,
      width: 74,
      decoration: BoxDecoration(
        color: _getCategoryColor(),
        borderRadius: BorderRadius.circular(10),
        image: fullImageUrl != null
            ? DecorationImage(
                image: NetworkImage(fullImageUrl),
                fit: BoxFit.cover,
                onError: (error, stackTrace) {
                  debugPrint('Error loading image: $error');
                },
              )
            : null,
      ),
      child: fullImageUrl == null
          ? Icon(_getCategoryIcon(), color: Colors.white, size: 36)
          : null,
    );
  }
}
