import 'package:aashwaas/screens/second_onboading_screen.dart';
import 'package:aashwaas/widgets/my_button.dart';
import 'package:flutter/material.dart';

class FifthOnboardingScreen extends StatefulWidget {
  const FifthOnboardingScreen({super.key});

  @override
  State<FifthOnboardingScreen> createState() => _FifthOnboardingScreenState();
}

class _FifthOnboardingScreenState extends State<FifthOnboardingScreen> {

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

              Text(
                " Welcome",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

              Container(
                height: 340,
                width: double.infinity,
                child: Image.asset("assets/images/logo.png"),
              ),

              _gap,

              Text(
                "Nurturing Compassion, \n Inspiring Change.",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),

              _gap,
              _gap,


              MyButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const SecondOnboadingScreen(),
                    ),
                  );
                },
                text: 'Login',
              ),

              _gap,

              MyButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const SecondOnboadingScreen(),
                    ),
                  );
                },
                text: 'Register',
                textColor: Colors.blueAccent,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
