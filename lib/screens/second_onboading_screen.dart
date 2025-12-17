import 'package:aashwaas/screens/fifth_onboarding_screen.dart';
import 'package:aashwaas/screens/third_onboarding_screen.dart';
import 'package:aashwaas/widgets/my_button.dart';
import 'package:flutter/material.dart';

class SecondOnboadingScreen extends StatelessWidget {
  const SecondOnboadingScreen({super.key});

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
                 TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const FifthOnboardingScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Skip", 
                      selectionColor: Colors.deepPurple, 
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),

              _gap,
              _gap,

              Container(
                height: 290,
                width: double.infinity,
                child: Image.asset("assets/icons/icon_giftbox.png"),
              ),

              Text(
                " Donate with Purpose",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),

              _gap,

              Text(
                "Give Items That Matter ",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),

              _gap,

              Text(
                "Donate clothes ,stationery, toys, and furniture to verified NGOs. Track your donations and see the impact you create.",
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                ),
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
                      builder: (context) => const ThirdOnboardingScreen(),
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
