import 'package:aashwaas/screens/fifth_onboarding_screen.dart';
import 'package:aashwaas/screens/fouth_onboarding_screen.dart';
import 'package:aashwaas/widgets/my_button.dart';
import 'package:flutter/material.dart';

class ThirdOnboardingScreen extends StatelessWidget {
  const ThirdOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _gap = SizedBox(height: 25);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 55,
                    width: 85,
                    child: MyButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const FifthOnboardingScreen(),
                          ),
                        );
                      },
                      text: 'Skip',
                      textColor: Colors.deepPurple,
                      color: const Color.fromARGB(255, 211, 227, 255),
                    ),
                  ),
                ],
              ),

              _gap,
              _gap,

              Container(
                height: 290,
                width: double.infinity,
                child: Image.asset("assets/icons/icon_volunteer.png"),
              ),

              Text(
                "Volunteer and Connect",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              _gap,

              Text(
                "Be Part of the Change",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),

              _gap,

              Text(
                "Join as a volunteer to collect and deliver donations, and help manage NGO operations. Your time can make a real difference!",
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
                      color: Colors.blueAccent,
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
                ],
              ),

              _gap,

              MyButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const FouthOnboardingScreen(),
                    ),
                  );
                },
                text: 'Next',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
