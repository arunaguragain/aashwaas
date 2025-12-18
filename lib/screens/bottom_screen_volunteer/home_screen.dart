import 'package:aashwaas/widgets/home_header.dart';
import 'package:aashwaas/widgets/stats_card.dart';
import 'package:aashwaas/widgets/task_card.dart';
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

            TaskCard(
              title: "Medical Books Collection",
              pickup: "Boudha Police Station",
              drop: "Moonlight Foundation",
              date: "2024-11-19",
              phone: "+977 9800000000",
              status: TaskStatus.pendingReview,
              onAccept: () {
              },
              onDecline: () {
              },
            ),

            
          ],
        ),
      ),
    );
  }
}
