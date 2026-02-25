import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/home_header.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/stats_card.dart';
import 'package:aashwaas/features/task/domain/entities/task_entity.dart';
import 'package:aashwaas/features/task/presentation/state/task_state.dart';
// import 'package:aashwaas/features/dashboard/presentation/widgets/task_card.dart';
import 'package:aashwaas/features/task/presentation/widgets/task_card.dart';
import 'package:aashwaas/features/settings/presentation/pages/settings_screen.dart';
import 'package:aashwaas/features/task/presentation/view_model/task_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';

typedef VolunteerTabChange = void Function(int index);

class HomeScreen extends ConsumerWidget {
  final VolunteerTabChange? onTabChange;
  const HomeScreen({super.key, this.onTabChange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userSessionService = ref.watch(userSessionServiceProvider);
    final userName = userSessionService.getUserFullName() ?? 'Volunteer';
    final profileImage = userSessionService.getUserProfileImage();

    final state = ref.watch(taskViewModelProvider);
    ref.listen<TaskState>(taskViewModelProvider, (previous, next) {
      if (next.status == TaskViewStatus.accepted) {
        MySnackbar.showSuccess(context, 'Task accepted');
      } else if (next.status == TaskViewStatus.completed) {
        MySnackbar.showSuccess(context, 'Task completed');
      } else if (next.status == TaskViewStatus.cancelled) {
        MySnackbar.showInfo(context, 'Task cancelled');
      } else if (next.status == TaskViewStatus.error) {
        MySnackbar.showError(
          context,
          next.errorMessage ?? 'Something went wrong',
        );
      }
    });
    final myTasks = state.myTasks;
    final activeTasks = myTasks
        .where(
          (t) =>
              t.status == TaskStatus.assigned ||
              t.status == TaskStatus.accepted,
        )
        .toList();
    final completedTasks = myTasks
        .where((t) => t.status == TaskStatus.completed)
        .toList();
    final pendingReviewTasks = myTasks
        .where((t) => t.status == TaskStatus.assigned)
        .toList();
    final recentlyCompleted = completedTasks.isNotEmpty
        ? completedTasks.last
        : null;

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
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatsCard(
                  label: 'Active Task',
                  value: activeTasks.length.toString(),
                  icon: Icons.list_alt,
                ),
                StatsCard(
                  label: 'Task Completed',
                  value: completedTasks.length.toString(),
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (pendingReviewTasks.isNotEmpty)
                      TaskCard(
                        task: pendingReviewTasks.first,
                        onAccept: () async {
                          if (pendingReviewTasks.first.taskId != null) {
                            final id = pendingReviewTasks.first.taskId!;
                            await ref
                                .read(taskViewModelProvider.notifier)
                                .acceptTask(id);
                            MySnackbar.showSuccess(context, 'Task accepted');
                          }
                        },
                        onCancel: () async {
                          final id = pendingReviewTasks.first.taskId;
                          if (id == null) return;
                          final shouldCancel = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Cancel task'),
                              content: const Text(
                                'Are you sure you want to cancel this task?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ),
                          );

                          if (shouldCancel == true) {
                            await ref
                                .read(taskViewModelProvider.notifier)
                                .cancelTask(id);
                            MySnackbar.showInfo(context, 'Task declined');
                          }
                        },
                      )
                    else
                      const Text("No tasks pending review."),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Recently Completed",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (onTabChange != null) {
                              onTabChange!(2); // Switch to history tab
                            }
                          },
                          child: const Text(
                            "View All",
                            style: TextStyle(fontFamily: 'OpenSans Bold'),
                          ),
                        ),
                      ],
                    ),
                    if (recentlyCompleted != null)
                      TaskCard(task: recentlyCompleted)
                    else
                      const Text("No recently completed tasks."),
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
