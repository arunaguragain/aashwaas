import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/features/auth/presentation/pages/volunteer_login_page.dart';
import 'package:aashwaas/features/auth/presentation/view_model/volunteer_auth_viewmodel.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/edit_profile_screen.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/profile_card.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/profile_impact_card.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/profile_stats_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      await ref.read(authVolunteerViewmodelProvider.notifier).logout();
      if (context.mounted) {
        AppRoutes.pushReplacement(context, const VolunteerLoginScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userSessionService = ref.watch(userSessionServiceProvider);

    final fullName = userSessionService.getUserFullName() ?? 'Volunteer';
    final email = userSessionService.getUserEmail() ?? 'volunteer@email.com';
    final phone = userSessionService.getUserPhoneNumber() ?? '+977 9800000000';
    final profileImage = userSessionService.getUserProfileImage();
    final createdAtIso = userSessionService.getUserCreatedAt();

    final tasksCompleted = 0;
    final impactPoints = tasksCompleted * 10;
    final roleSinceText = _formatRoleSince('Volunteer', createdAtIso);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileCard(
                fullName: fullName,
                email: email,
                phone: phone,
                profileImage: profileImage,
                onEditPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                  if (mounted) {
                    setState(() {});
                  }
                },
                roleSinceText: roleSinceText,
              ),
              const SizedBox(height: 16),
              const Text(
                'Statistics',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ProfileStatsCard(
                primaryLabel: 'Tasks Completed',
                primaryValue: '$tasksCompleted',
                primaryIcon: Icons.check_circle_outline,
                primaryIconColor: const Color(0xFF2EAD63),
                secondaryLabel: 'Impact Points',
                secondaryValue: '$impactPoints',
                secondaryIcon: Icons.workspace_premium_outlined,
                secondaryIconColor: const Color(0xFF7D5AF1),
                isLoading: false,
              ),
              const SizedBox(height: 16),
              ProfileImpactCard(
                subtitle: 'Tasks Completed',
                valueText: '$tasksCompleted tasks',
                icon: Icons.volunteer_activism,
                iconColor: const Color(0xFF2EAD63),
                badgeColor: const Color(0xFFEFFAF4),
              ),
              const SizedBox(height: 24),
              MyButton(
                onPressed: _confirmLogout,
                text: 'Logout',
                icon: const Icon(Icons.logout, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatRoleSince(String role, String? isoDate) {
    if (isoDate == null || isoDate.trim().isEmpty) {
      return '$role since —';
    }
    final parsed = DateTime.tryParse(isoDate);
    if (parsed == null) {
      return '$role since —';
    }
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final month = months[parsed.month - 1];
    return '$role since $month ${parsed.year}';
  }
}
