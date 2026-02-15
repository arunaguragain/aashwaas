import 'package:aashwaas/features/dashboard/presentation/pages/bottom_screen_volunteer/history_screen.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/bottom_screen_volunteer/home_screen.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/bottom_screen_volunteer/profile_screen.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/bottom_screen_volunteer/task_screen.dart';
import 'package:flutter/material.dart';

typedef VolunteerTabChange = void Function(int index);

class VolunteerHomeScreen extends StatefulWidget {
  final VolunteerTabChange? onTabChange;
  const VolunteerHomeScreen({super.key, this.onTabChange});

  @override
  State<VolunteerHomeScreen> createState() => _VolunteerHomeScreenState();
}

class _VolunteerHomeScreenState extends State<VolunteerHomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> lstBottomScreen;

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
}
