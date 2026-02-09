import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/core/widgets/my_button.dart';
import 'package:aashwaas/features/auth/presentation/pages/donor_login_page.dart';
import 'package:aashwaas/features/auth/presentation/view_model/donor_auth_viewmodel.dart';
import 'package:aashwaas/features/dashboard/presentation/pages/edit_profile_screen.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/profile_card.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/profile_impact_card.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/profile_stats_card.dart';
import 'package:aashwaas/features/donation/presentation/state/donation_state.dart';
import 'package:aashwaas/features/donation/presentation/view_model/donation_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStats();
    });
  }

  Future<void> _loadStats() async {
    final userSessionService = ref.read(userSessionServiceProvider);
    final userId = userSessionService.getUserId();
    if (userId != null) {
      await ref.read(donationViewModelProvider.notifier).getMyDonations(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final donationState = ref.watch(donationViewModelProvider);
    final userSessionService = ref.watch(userSessionServiceProvider);

    final fullName = userSessionService.getUserFullName() ?? 'Donor';
    final email = userSessionService.getUserEmail() ?? 'donor@email.com';
    final phone = userSessionService.getUserPhoneNumber() ?? '+977 9800000000';
    final profileImage = userSessionService.getUserProfileImage();
    final createdAtIso = userSessionService.getUserCreatedAt();

    final itemsDonated = donationState.totalDonationCount;
    final impactPoints = itemsDonated * 10;
    final roleSinceText = _formatRoleSince('Donor', createdAtIso);

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
                primaryLabel: 'Items Donated',
                primaryValue: '$itemsDonated',
                primaryIcon: Icons.card_giftcard,
                primaryIconColor: const Color(0xFF2EAD63),
                secondaryLabel: 'Impact Points',
                secondaryValue: '$impactPoints',
                secondaryIcon: Icons.workspace_premium_outlined,
                secondaryIconColor: const Color(0xFF7D5AF1),
                isLoading: donationState.status == DonationStatus.loading,
              ),
              const SizedBox(height: 16),
              ProfileImpactCard(
                subtitle: 'Items Donated',
                valueText: '$itemsDonated items',
                icon: Icons.volunteer_activism,
                iconColor: const Color(0xFF2EAD63),
                badgeColor: const Color(0xFFEFFAF4),
              ),
              const SizedBox(height: 24),
              MyButton(
                onPressed: () async {
                  await ref.read(authDonorViewmodelProvider.notifier).logout();
                  if (context.mounted) {
                    AppRoutes.pushReplacement(
                      context,
                      const DonorLoginScreen(),
                    );
                  }
                },
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
