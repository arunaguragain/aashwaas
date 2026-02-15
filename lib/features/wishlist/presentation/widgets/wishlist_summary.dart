import 'package:aashwaas/features/wishlist/presentation/widgets/wishlist_stat_card.dart';
import 'package:flutter/material.dart';

class WishlistSummary extends StatelessWidget {
  final int total;
  final int active;
  final int fulfilled;

  const WishlistSummary({
    super.key,
    required this.total,
    required this.active,
    required this.fulfilled,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          WishlistStatCard(title: 'Total', value: total.toString()),
          const SizedBox(width: 8),
          WishlistStatCard(title: 'Active', value: active.toString()),
          const SizedBox(width: 8),
          WishlistStatCard(title: 'Fulfilled', value: fulfilled.toString()),
        ],
      ),
    );
  }
}


