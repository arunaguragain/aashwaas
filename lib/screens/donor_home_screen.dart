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
      appBar: AppBar(),
      body: lstBottomScreen[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'NGOs',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.add), label: ''),
          // BottomNavigationBarItem(icon:Container(
          //   height: 45,width: 45,decoration:
          //   const BoxDecoration(
          //     color: Colors.blue,shape: BoxShape.circle,),
          //     child: const Icon(Icons.add, color: Colors.white),),
          //     label: '',),
          const BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
