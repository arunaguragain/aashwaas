import 'package:aashwaas/core/services/storage/user_session_service.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/donation_history_card.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/history_summary_row.dart';
import 'package:aashwaas/features/donation/presentation/state/donation_state.dart';
import 'package:aashwaas/features/donation/presentation/view_model/donation_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDonations();
    });
  }

  Future<void> _loadDonations() async {
    final userSessionService = ref.read(userSessionServiceProvider);
    final userId = userSessionService.getUserId();
    if (userId != null) {
      final donationNotifier = ref.read(donationViewModelProvider.notifier);
      await donationNotifier.getMyDonations(userId);
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final donationState = ref.watch(donationViewModelProvider);
    final myDonations = donationState.myDonations;

    if (donationState.status == DonationStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (donationState.status == DonationStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(donationState.errorMessage ?? 'Error loading donations'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDonations,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (myDonations.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No donations yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Your donation history will appear here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final totalCount = myDonations.length;
    final deliveredCount = myDonations
        .where(
          (item) => item.status == 'delivered' || item.status == 'completed',
        )
        .length;
    final pendingCount = myDonations
        .where((item) => item.status == 'pending')
        .length;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadDonations,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            HistorySummaryRow(
              total: totalCount,
              delivered: deliveredCount,
              pending: pendingCount,
            ),
            const SizedBox(height: 12),
            ...myDonations.map((item) => DonationHistoryCard(donation: item)),
          ],
        ),
      ),
    );
  }
}
