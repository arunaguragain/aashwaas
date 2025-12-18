import 'package:aashwaas/widgets/home_header.dart';
import 'package:aashwaas/widgets/quick_action_section.dart';
import 'package:aashwaas/widgets/stats_card.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(
              userName: 'Aruna',
              onNotificationPressed: () {},
              onMenuPressed: () {},
              isVerified: true,
              role: 'donor',
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatsCard(
                    label: 'Items Donated',
                    value: '20',
                    icon: Icons.card_giftcard,
                  ),
                  StatsCard(
                    label: 'Active Listings',
                    value: '3',
                    icon: Icons.list_alt,
                    cardColor: Colors.green,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: 14),
                  QuickActionsSection(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Recent Donations",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "View All",
                            selectionColor: Colors.blue,
                            style: TextStyle(fontFamily: 'OpenSans Bold'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
