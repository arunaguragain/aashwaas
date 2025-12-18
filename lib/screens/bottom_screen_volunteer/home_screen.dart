import 'package:aashwaas/widgets/home_header.dart';
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
              role: 'volunteer',
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatsCard(
                  label: 'Active Task',
                  value: '0',
                  icon: Icons.list_alt,
                ),
                StatsCard(
                  label: 'Task Completed',
                  value: '10',
                  icon: Icons.check_circle_outline,
                  cardColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
