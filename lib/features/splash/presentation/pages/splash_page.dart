import 'dart:async';
import 'package:aashwaas/features/onboarding/presentation/pages/first_onboading_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => const FirstOnboadingScreen(),
        ),
      );
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
