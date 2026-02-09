import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/home_header.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/stats_card.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/task_card.dart';
import 'package:aashwaas/features/settings/presentation/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSessionService = ref.watch(userSessionServiceProvider);
    final userName = userSessionService.getUserFullName() ?? 'Volunteer';
    final profileImage = userSessionService.getUserProfileImage();

    return SizedBox.expand(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(
              userName: userName,
              profileImageUrl: profileImage,
              onNotificationPressed: () {},
              onMenuPressed: () {
                AppRoutes.push(context, const SettingsScreen());
              },
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

            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pending Review",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TaskCard(
                      title: "Medical Books Collection",
                      pickup: "Boudha Police Station",
                      drop: "Moonlight Foundation",
                      date: "2024-11-19",
                      phone: "+977 9800000000",
                      status: TaskStatus.pendingReview,
                      onAccept: () {},
                      onDecline: () {},
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Active Task",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "View All",
                            selectionColor: Colors.blue,
                            style: TextStyle(fontFamily: 'OpenSans Bold'),
                          ),
                        ),
                      ],
                    ),
                    TaskCard(
                      title: "Medical Books Collection",
                      pickup: "Boudha Police Station",
                      drop: "Moonlight Foundation",
                      date: "2024-11-19",
                      phone: "+977 9800000000",
                      status: TaskStatus.pending,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
