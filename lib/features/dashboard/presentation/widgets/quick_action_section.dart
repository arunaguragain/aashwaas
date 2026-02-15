import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/bottom_screen_donor/ngo_page.dart';
import 'package:aashwaas/features/donation/presentation/pages/add_donation_page.dart';
import 'package:flutter/material.dart';
import 'quick_action_button.dart';

typedef TabChangeCallback = void Function(int index);

class QuickActionsSection extends StatelessWidget {
  final TabChangeCallback? onTabChange;
  const QuickActionsSection({super.key, this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
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
                  onTap: () {
                    AppRoutes.push(context, const AddDonationScreen());
                  },
                ),
                QuickActionButton(
                  label: 'Find NGOs',
                  icon: Icons.location_on_outlined,
                  onTap: () {
                    if (onTabChange != null) {
                      onTabChange!(1); // NGOs tab
                    }
                  },
                ),
                // TODO: Replace with actual Wishlist page if available
                QuickActionButton(
                  label: 'My Wishlist',
                  icon: Icons.bookmark_border,
                  onTap: () {
                    // Add navigation to Wishlist page if implemented
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Wishlist page coming soon!'),
                      ),
                    );
                  },
                ),
                // TODO: Replace with actual Reviews page if available
                QuickActionButton(
                  label: 'My Reviews',
                  icon: Icons.star_border,
                  onTap: () {
                    // Add navigation to Reviews page if implemented
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Reviews page coming soon!'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
