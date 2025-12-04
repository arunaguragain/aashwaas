import 'package:aashwaas/screens/splash_screen.dart';
import 'package:aashwaas/widgets/my_button.dart';
import 'package:flutter/material.dart';

class FouthOnboardingScreen extends StatelessWidget {
  const FouthOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _gap = SizedBox(height: 25);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 211, 227, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 100),

              Container(
                height: 290,
                width: double.infinity,
                child: Image.asset("assets/icons/icon_tick.png"),
              ),

              Text(
                "Ready to Start?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              _gap,

              Text(
                "Choose Your Role",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),

              _gap,

              Text(
                "Whether you're donating items or volunteering your time, we're here to help.",
                style: TextStyle(fontSize: 17, color: Colors.black87),
                textAlign: TextAlign.center,
              ),

              _gap,
              _gap,

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: 20,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: 20,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: 20,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    width: 20,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),

              _gap,

              MyButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const SplashScreen(),
                    ),
                  );
                },
                text: 'Get Started',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
