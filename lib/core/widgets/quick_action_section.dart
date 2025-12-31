import 'package:flutter/material.dart';
import 'quick_action_button.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 90,
              ),
              children: [
                QuickActionButton(
                  label: 'Donate Item',
                  icon: Icons.add,
                  onTap: () {},
                ),
                QuickActionButton(
                  label: 'Find NGOs',
                  icon: Icons.location_on_outlined,
                  onTap: () {},
                ),
                QuickActionButton(
                  label: 'My Wishlist',
                  icon: Icons.bookmark_border,
                  onTap: () {},
                ),
                QuickActionButton(
                  label: 'My Reviews',
                  icon: Icons.star_border,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
