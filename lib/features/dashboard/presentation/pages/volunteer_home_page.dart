import 'package:aashwaas/features/dashboard/presentation/pages/bottom_screen_volunteer/history_screen.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/bottom_screen_volunteer/home_screen.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/bottom_screen_volunteer/profile_screen.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/bottom_screen_volunteer/task_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aashwaas/core/utils/my_snackbar.dart';
import 'package:aashwaas/features/task/presentation/view_model/task_viewmodel.dart';
import 'package:aashwaas/features/task/presentation/state/task_state.dart';
import 'package:aashwaas/features/sensor/presentation/providers/rotation_navigator.dart';

typedef VolunteerTabChange = void Function(int index);

class VolunteerHomeScreen extends ConsumerStatefulWidget {
  final VolunteerTabChange? onTabChange;
  const VolunteerHomeScreen({super.key, this.onTabChange});

  @override
  ConsumerState<VolunteerHomeScreen> createState() =>
      _VolunteerHomeScreenState();
}

class _VolunteerHomeScreenState extends ConsumerState<VolunteerHomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> lstBottomScreen;

  // rotation navigator for gyroscope gestures
  RotationNavigator? _rotNav;

  @override
  void initState() {
    super.initState();
    lstBottomScreen = [
      HomeScreen(
        onTabChange: (index) {
          if (widget.onTabChange != null) {
            widget.onTabChange!(index);
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
      const TaskScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
    ];

    // start gyro-based navigation (quick twist left/right)
    _rotNav = RotationNavigator(
      onNext: () => _changeTab(_selectedIndex + 1),
      onPrevious: () => _changeTab(_selectedIndex - 1),
    )..start();

    // ensure we fetch tasks and show snackbars from a single top-level listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskViewModelProvider.notifier).getMyTasks();
      ref.listen<TaskState>(taskViewModelProvider, (previous, next) {
        if (!mounted) return;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? ''
              : _selectedIndex == 1
              ? 'My Tasks'
              : _selectedIndex == 2
              ? 'Task History'
              : 'My Profile',
        ),
      ),
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Task'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (widget.onTabChange != null) {
            widget.onTabChange!(index);
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _rotNav?.stop();
    super.dispose();
  }

  void _changeTab(int newIndex) {
    if (newIndex < 0) newIndex = lstBottomScreen.length - 1;
    if (newIndex >= lstBottomScreen.length) newIndex = 0;

    if (widget.onTabChange != null) {
      widget.onTabChange!(newIndex);
    } else {
      setState(() => _selectedIndex = newIndex);
    }
  }
}
