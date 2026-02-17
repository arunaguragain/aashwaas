import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/donation_history_card.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/home_header.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/quick_action_section.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/stats_card.dart';
import 'package:aashwaas/features/donation/presentation/state/donation_state.dart';
import 'package:aashwaas/features/donation/presentation/view_model/donation_viewmodel.dart';
import 'package:aashwaas/app/routes/app_routes.dart';
import 'package:aashwaas/features/settings/presentation/pages/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef TabChangeCallback = void Function(int index);

class HomeScreen extends ConsumerStatefulWidget {
  final TabChangeCallback? onTabChange;
  const HomeScreen({super.key, this.onTabChange});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecentDonations();
    });
  }

  Future<void> _loadRecentDonations() async {
    final userSessionService = ref.read(userSessionServiceProvider);
    final userId = userSessionService.getUserId();
    if (userId != null) {
      await ref.read(donationViewModelProvider.notifier).getMyDonations();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userSessionService = ref.watch(userSessionServiceProvider);
    final userName = userSessionService.getUserFullName() ?? 'Donor';
    final profileImage = userSessionService.getUserProfileImage();
    final donationState = ref.watch(donationViewModelProvider);
    final recentDonations = donationState.myDonations.take(2).toList();

    return SizedBox.expand(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HomeHeader(
              userName: userName,
              profileImageUrl: profileImage,
              onNotificationPressed: () {},
              onMenuPressed: () {
                AppRoutes.push(context, const SettingsScreen());
              },
              isVerified: true,
              role: 'donor',
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatsCard(
                    label: 'Items Donated',
                    value: donationState.myDonations.length.toString(),
                    icon: Icons.card_giftcard,
                  ),
                  StatsCard(
                    label: 'Active Listings',
                    value: donationState.myDonations
                        .where((d) => d.status != 'completed')
                        .length
                        .toString(),
                    icon: Icons.list_alt,
                    cardColor: Colors.green,
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  SizedBox(height: 14),
                  QuickActionsSection(onTabChange: widget.onTabChange),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "Recent Donations",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextButton(
                          onPressed: () {
                            if (widget.onTabChange != null) {
                              widget.onTabChange!(3); // History tab
                            }
                          },
                          child: Text(
                            "View All",
                            selectionColor: Colors.blue,
                            style: TextStyle(fontFamily: 'OpenSans Bold'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (donationState.status == DonationStatus.loading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (recentDonations.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'No donations yet',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: recentDonations
                            .map(
                              (donation) =>
                                  DonationHistoryCard(donation: donation),
                            )
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
