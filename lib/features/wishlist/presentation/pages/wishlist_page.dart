import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/features/wishlist/presentation/pages/add_wishlist_page.dart';
import 'package:flutter/material.dart';
import '../widgets/wishlist_card.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD2ECEF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFD2ECEF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('My Wishlist'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7CA9F3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add', style: TextStyle(color: Colors.white)),
              onPressed: () {
                AppRoutes.push(context, AddWishlistPage());
              },
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          WishlistCard(
            title: 'Winter Blankets',
            category: 'Clothes',
            planned: 'Dec 2025',
            notes: 'For winter donation drive',
          ),
          WishlistCard(
            title: "Children's Books",
            category: 'Books',
            planned: 'Feb 2026',
            notes: 'School semester donations',
          ),
          WishlistCard(
            title: 'Educational Toys',
            category: 'Clothes',
            planned: 'Jun 2026',
            notes: 'Birthday month giving',
          ),
        ],
      ),
    );
  }
}
