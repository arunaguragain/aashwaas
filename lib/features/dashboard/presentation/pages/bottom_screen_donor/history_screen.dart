import 'package:aashwaas/core/utils/my_snackbar.dart';
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
  String _selectedStatus = 'all';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDonations();
      ref.listen<DonationState>(donationViewModelProvider, (previous, next) {
        if (next.status == DonationStatus.created) {
          MySnackbar.showSuccess(context, 'Donation submitted successfully');
        } else if (next.status == DonationStatus.updated) {
          MySnackbar.showSuccess(context, 'Donation updated successfully');
        } else if (next.status == DonationStatus.deleted) {
          MySnackbar.showInfo(context, 'Donation cancelled');
        } else if (next.status == DonationStatus.error) {
          MySnackbar.showError(
            context,
            next.errorMessage ?? 'Something went wrong',
          );
        }
      });
    });
  }

  Future<void> _loadDonations() async {
    final donationNotifier = ref.read(donationViewModelProvider.notifier);
    await donationNotifier.getMyDonations();
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    final donationState = ref.watch(donationViewModelProvider);
    final myDonations = donationState.myDonations;

    // filter donations based on selected status
    final filteredDonations = _selectedStatus == 'all'
        ? myDonations
        : myDonations.where((d) {
            final s = (d.status ?? '').toLowerCase();
            switch (_selectedStatus) {
              case 'pending':
                return s == 'pending';
              case 'delivered':
                return s == 'delivered' || s == 'completed';
              case 'assigned':
                return s == 'assigned';
              default:
                return true;
            }
          }).toList();

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
            // Filter control
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    SizedBox(width: 8),
                    // Text(
                    // 'Filters',
                    // style: TextStyle(fontWeight: FontWeight.bold),
                    // ),
                  ],
                ),
                DropdownButton<String>(
                  value: _selectedStatus,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(
                      value: 'delivered',
                      child: Text('Delivered'),
                    ),
                    DropdownMenuItem(
                      value: 'assigned',
                      child: Text('Assigned'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val == null) return;
                    setState(() {
                      _selectedStatus = val;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...filteredDonations.map(
              (item) => DonationHistoryCard(donation: item),
            ),
          ],
        ),
      ),
    );
  }
}
