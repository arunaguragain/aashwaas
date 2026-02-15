import 'package:aashwaas/features/donation/presentation/pages/add_donation_page.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/bottom_screen_donor/history_screen.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/bottom_screen_donor/home_page.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/bottom_screen_donor/ngo_page.dart';
import 'package:flutter/material.dart';

import 'bottom_screen_donor/profile_screen.dart';


class DonorHomeScreen extends StatefulWidget {
  const DonorHomeScreen({super.key});

  @override
  State<DonorHomeScreen> createState() => _DonorHomeScreenState();
}

class _DonorHomeScreenState extends State<DonorHomeScreen> {
  int _selectedIndex = 0;


  late final List<Widget> lstBottomScreen;

  @override
  void initState() {
    super.initState();
    lstBottomScreen = [
      HomeScreen(
        onTabChange: (index) {
          if (index != 2) {
            setState(() {
              _selectedIndex = index;
            });
          } else {
            _onDonationPressed();
          }
        },
      ),
      const NgoScreen(),
      const SizedBox.shrink(),
      const HistoryScreen(),
      const ProfileScreen(),
    ];
  }

  void _onDonationPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDonationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedIndex == 0
              ? ''
              : _selectedIndex == 1
              ? 'NGOs & Instituitions'
              : _selectedIndex == 2
              ? ''
              : _selectedIndex == 3
              ? 'Donation History'
              : 'My Profile',
        ),
      ),
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'NGOs',
              ),
              const BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
              const BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],

            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == 2) {
                _onDonationPressed();
                return;
              }
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Positioned(
            bottom: 40,
            left: MediaQuery.of(context).size.width * 0.5 - 35,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: FloatingActionButton(
                onPressed: _onDonationPressed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
