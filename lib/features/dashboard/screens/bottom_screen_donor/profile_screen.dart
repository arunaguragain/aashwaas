import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/features/auth/presentation/pages/volunteer_login_page.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Center(
        child:
            //  Text('Welcome to Volunteers Profile Screen')
            MyButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const VolunteerLoginScreen(),
                  ),
                );
              },
              text: 'logout',
            ),
      ),
    );
  }
}
