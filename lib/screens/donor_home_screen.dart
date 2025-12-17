import 'package:aashwaas/screens/bottom_screen_donor/add_donation_screen.dart';
import 'package:aashwaas/screens/bottom_screen_donor/history_screen.dart';
import 'package:aashwaas/screens/bottom_screen_donor/home_screen.dart';
import 'package:aashwaas/screens/bottom_screen_donor/ngo_screen.dart';
import 'package:flutter/material.dart';

import 'bottom_screen_donor/profile_screen.dart';

class DonorHomeScreen extends StatefulWidget {
  const DonorHomeScreen({super.key});

  @override
  State<DonorHomeScreen> createState() => _DonorHomeScreenState();
}

class _DonorHomeScreenState extends State<DonorHomeScreen> {
  int _selectedIndex = 0;

  List<Widget> lstBottomScreen = [
    const HomeScreen(),
    const NgoScreen(),
    const AddDonationScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

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
              ? 'Add Donation'
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
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          Positioned(
            bottom: 27,
            left: 183,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
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
