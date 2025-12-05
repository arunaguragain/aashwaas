import 'package:aashwaas/screens/donor_login_screen.dart';
import 'package:aashwaas/screens/donor_register_screen.dart';
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
    final _gap = SizedBox(height: 20);

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
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

              Container(
                height: 320,
                width: double.infinity,
                child: Image.asset("assets/images/logo.png"),
              ),

              _gap,

              Text(
                "Nurturing Compassion, \n Inspiring Change.",
                style: TextStyle(
                  fontSize: 28,
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
                      builder: (context) => const DonorLoginScreen(),
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
                      builder: (context) => const DonorRegisterScreen(),
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
