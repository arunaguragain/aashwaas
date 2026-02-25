import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/features/task/presentation/view_model/task_viewmodel.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';
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
            horizontalGap: 4,
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
                                                ? () async {
                                                    final id =
                                                        selected!.taskId!;
                                                    await ref
                                                        .read(
                                                          taskViewModelProvider
                                                              .notifier,
                                                        )
                                                        .acceptTask(id);
                                                    if (mounted) {
                                                      MySnackbar.showSuccess(
                                                        context,
                                                        'Task accepted',
                                                      );
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    }
                                                  }
                                                : null,
                                            child: const Text('Accept'),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: selected?.taskId != null
                                                ? () async {
                                                    final id =
                                                        selected!.taskId!;
                                                    await ref
                                                        .read(
                                                          taskViewModelProvider
                                                              .notifier,
                                                        )
                                                        .completeTask(id);
                                                    if (mounted) {
                                                      MySnackbar.showSuccess(
                                                        context,
                                                        'Task completed',
                                                      );
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    }
                                                  }
                                                : null,
                                            child: const Text('Complete'),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: selected?.taskId != null
                                                ? () async {
                                                    final id =
                                                        selected!.taskId!;
                                                    final shouldCancel =
                                                        await showDialog<bool>(
                                                          context: context,
                                                          builder: (ctx) => AlertDialog(
                                                            title: const Text(
                                                              'Cancel task',
                                                            ),
                                                            content: const Text(
                                                              'Are you sure you want to cancel this task?',
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                      ctx,
                                                                      false,
                                                                    ),
                                                                child:
                                                                    const Text(
                                                                      'No',
                                                                    ),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.pop(
                                                                      ctx,
                                                                      true,
                                                                    ),
                                                                child:
                                                                    const Text(
                                                                      'Cancel',
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        );

                                                    if (shouldCancel == true) {
                                                      await ref
                                                          .read(
                                                            taskViewModelProvider
                                                                .notifier,
                                                          )
                                                          .cancelTask(id);
                                                      if (mounted) {
                                                        MySnackbar.showInfo(
                                                          context,
                                                          'Task declined',
                                                        );
                                                      }
                                                    }

                                                    if (mounted) {
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    }
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
                            ? () async {
                                final id = t.taskId!;
                                await ref
                                    .read(taskViewModelProvider.notifier)
                                    .acceptTask(id);
                                if (mounted) {
                                  MySnackbar.showSuccess(
                                    context,
                                    'Task accepted',
                                  );
                                }
                              }
                            : null,
                        onComplete: t.taskId != null
                            ? () async {
                                final id = t.taskId!;
                                await ref
                                    .read(taskViewModelProvider.notifier)
                                    .completeTask(id);
                                if (mounted) {
                                  MySnackbar.showSuccess(
                                    context,
                                    'Task completed',
                                  );
                                }
                              }
                            : null,
                        onCancel: t.taskId != null
                            ? () async {
                                final id = t.taskId!;
                                final shouldCancel = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Cancel task'),
                                    content: const Text(
                                      'Are you sure you want to cancel this task?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  ),
                                );

                                if (shouldCancel == true) {
                                  await ref
                                      .read(taskViewModelProvider.notifier)
                                      .cancelTask(id);
                                  if (mounted) {
                                    MySnackbar.showInfo(
                                      context,
                                      'Task declined',
                                    );
                                  }
                                }
                              }
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
