import 'package:aashwaas/features/dashboard/presentation/widgets/donation_image_placeholder.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/history_category_pill.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/history_info_row.dart';
import 'package:aashwaas/features/dashboard/presentation/widgets/history_status_chip.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
import 'package:aashwaas/features/donation/presentation/pages/donation_details_dialog.dart';
import 'package:aashwaas/features/donation/presentation/pages/edit_donation_page.dart';
import 'package:aashwaas/features/donation/presentation/view_model/donation_viewmodel.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DonationHistoryCard extends ConsumerWidget {
  final DonationEntity donation;

  const DonationHistoryCard({super.key, required this.donation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DonationImagePlaceholder(
                imageUrl: donation.media,
                category: donation.category,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            donation.itemName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        HistoryCategoryPill(label: donation.category),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${donation.quantity} items',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                    const SizedBox(height: 6),
                    HistoryStatusChip(status: donation.status ?? 'pending'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          HistoryInfoRow(icon: Icons.info_outline, text: donation.condition),
          const SizedBox(height: 6),
          HistoryInfoRow(
            icon: Icons.location_on_outlined,
            text: donation.pickupLocation,
          ),
          if (donation.createdAt != null) ...[
            const SizedBox(height: 6),
            HistoryInfoRow(
              icon: Icons.schedule_outlined,
              text: 'Submitted: ${_formatDate(donation.createdAt!)}',
            ),
          ],
          if (donation.description != null &&
              donation.description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(
                donation.description!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    if (donation.status?.toLowerCase() == 'pending') {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) =>
                              EditDonationPage(donation: donation),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (ctx) =>
                            DonationDetailsDialog(donation: donation),
                      );
                    }
                  },
                  child: Text(
                    (donation.status?.toLowerCase() == 'pending')
                        ? 'Edit'
                        : 'View Details',
                  ),
                ),
              ),
              if (donation.status?.toLowerCase() == 'pending') ...[
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Cancel Donation'),
                          content: const Text(
                            'Are you sure you want to cancel this donation?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(ctx).pop();
                                if (donation.donationId != null) {
                                  await ref
                                      .read(donationViewModelProvider.notifier)
                                      .deleteDonation(donation.donationId!);
                                }
                              },
                              child: const Text('Yes'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.redAccent),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
