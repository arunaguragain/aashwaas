import 'dart:async';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/dashboard/screens/donor_home_screen.dart';
import 'package:aashwaas/features/dashboard/screens/volunteer_home_screen.dart';
import 'package:aashwaas/features/onboarding/presentation/pages/first_onboading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () async {
      final userSessionService = ref.read(userSessionServiceProvider);
      final isLoggedIn = userSessionService.isLoggedIn();
      
      if (isLoggedIn) {
        final userRole = await userSessionService.getUserRole(); // Get user role
        if (userRole == 'volunteer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const VolunteerHomeScreen(),
            ),
          );
        } else if (userRole == 'donor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const DonorHomeScreen(),
            ),
          );
        } else {
          // Fallback: if no role is found or the role is not set
          Navigator.pushReplacement(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const FirstOnboadingScreen(),
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const FirstOnboadingScreen(),
          ),
        );
      }
    });


    final _gap = SizedBox(height: 25);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade50,
              ),
              child: Image.asset("assets/images/logo.png"),
            ),

            _gap,

            Text(
              "Aashwaas",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),

            _gap,

            Container(
              width: 100,
              height: 5,
              color: Colors.blueAccent,
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
