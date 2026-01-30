import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/features/auth/presentation/pages/volunteer_login_page.dart';
import 'package:aashwaas/features/auth/presentation/view_model/volunteer_auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox.expand(
      child: Center(
        child: MyButton(
          onPressed: () async {
            // Call logout
            await ref.read(authVolunteerViewmodelProvider.notifier).logout();

            // Navigate to login
            if (context.mounted) {
              AppRoutes.pushReplacement(context, const VolunteerLoginScreen());
            }
          },
          text: 'Logout',
        ),
      ),
    );
  }
}
