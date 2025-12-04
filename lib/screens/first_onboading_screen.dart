import 'package:aashwaas/screens/splash_screen.dart';
import 'package:aashwaas/widgets/my_button.dart';
import 'package:flutter/material.dart';
import '';

class FirstOnboadingScreen extends StatelessWidget {
  const FirstOnboadingScreen({super.key});

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
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 55,
                    width: 85,
                    // decoration: BoxDecoration(color: Colors.blue.shade50),
                    child: MyButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => const SplashScreen(),
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

              Image.asset("assets/images/logo.png"),

              Text(
                " Welcome to Aashwaas",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              _gap,

              Text(
                " Your platform for making a progress",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
                textAlign: TextAlign.center,
              ),

              _gap,

              Text(
                "Connect donors, volunteers, and NGOs to create meaningful impact through item donations. ",
                style: TextStyle(
                  fontSize: 17,
                  // fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),

              _gap,
              _gap,

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment,
                children: [
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
                      builder: (context) => const SplashScreen(),
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
