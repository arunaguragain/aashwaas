import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/features/task/presentation/view_model/task_viewmodel.dart';
import 'package:aashwaas/features/task/presentation/state/task_state.dart';
import 'package:aashwaas/features/task/presentation/widgets/task_card.dart';
import 'package:aashwaas/features/task/presentation/widgets/task_stats_card.dart';
import 'package:aashwaas/features/task/domain/entities/task_entity.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
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
    final items = all.where((t) => t.status == TaskStatus.completed).toList();

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
          if (items.isEmpty)
            const Expanded(child: Center(child: Text('No history available')))
          else
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final t = items[index];
                  return TaskCard(task: t);
                },
              ),
            ),
        ],
      ),
    );
  }
}
