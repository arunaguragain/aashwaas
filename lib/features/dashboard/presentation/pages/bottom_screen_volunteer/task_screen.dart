import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/features/task/presentation/view_model/task_viewmodel.dart';
import 'package:aashwaas/features/task/presentation/state/task_state.dart';
import 'package:aashwaas/features/task/domain/entities/task_entity.dart';
import 'package:aashwaas/features/task/presentation/widgets/task_card.dart';
import 'package:aashwaas/features/task/presentation/widgets/task_stats_card.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskViewModelProvider.notifier).getMyTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskViewModelProvider);

    if (state.status == TaskViewStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == TaskViewStatus.error) {
      return Center(child: Text(state.errorMessage ?? 'Something went wrong'));
    }

    final all = state.myTasks;
    final items = all
        .where(
          (t) =>
              t.status == TaskStatus.assigned ||
              t.status == TaskStatus.accepted,
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TaskStatsCard(
            total: all.length,
            assigned: all.where((t) => t.status == TaskStatus.assigned).length,
            accepted: all.where((t) => t.status == TaskStatus.accepted).length,
            completed: all
                .where((t) => t.status == TaskStatus.completed)
                .length,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('No tasks available'))
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final t = items[index];
                      return TaskCard(
                        task: t,
                        onTap: () {
                          if (t.taskId != null) {
                            ref
                                .read(taskViewModelProvider.notifier)
                                .getTaskById(t.taskId!);
                            showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                final selected = ref
                                    .read(taskViewModelProvider)
                                    .selectedTask;
                                return Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        selected?.title ?? t.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Donation: ${selected?.donationId ?? t.donationId}',
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Volunteer: ${selected?.volunteerId ?? t.volunteerId}',
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            onPressed: selected?.taskId != null
                                                ? () {
                                                    ref
                                                        .read(
                                                          taskViewModelProvider
                                                              .notifier,
                                                        )
                                                        .acceptTask(
                                                          selected!.taskId!,
                                                        );
                                                    Navigator.of(context).pop();
                                                  }
                                                : null,
                                            child: const Text('Accept'),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: selected?.taskId != null
                                                ? () {
                                                    ref
                                                        .read(
                                                          taskViewModelProvider
                                                              .notifier,
                                                        )
                                                        .completeTask(
                                                          selected!.taskId!,
                                                        );
                                                    Navigator.of(context).pop();
                                                  }
                                                : null,
                                            child: const Text('Complete'),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: selected?.taskId != null
                                                ? () {
                                                    ref
                                                        .read(
                                                          taskViewModelProvider
                                                              .notifier,
                                                        )
                                                        .cancelTask(
                                                          selected!.taskId!,
                                                        );
                                                    Navigator.of(context).pop();
                                                  }
                                                : null,
                                            child: const Text('Cancel'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                        onAccept: t.taskId != null
                            ? () => ref
                                  .read(taskViewModelProvider.notifier)
                                  .acceptTask(t.taskId!)
                            : null,
                        onComplete: t.taskId != null
                            ? () => ref
                                  .read(taskViewModelProvider.notifier)
                                  .completeTask(t.taskId!)
                            : null,
                        onCancel: t.taskId != null
                            ? () => ref
                                  .read(taskViewModelProvider.notifier)
                                  .cancelTask(t.taskId!)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
