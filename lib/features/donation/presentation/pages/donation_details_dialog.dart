import 'package:flutter/material.dart';
import 'package:aashwaas/features/donation/domain/entities/donation_entity.dart';
// import 'package:aashwaas/features/dashboard/presentation/widgets/donation_image_placeholder.dart';

class DonationDetailsDialog extends StatelessWidget {
  final DonationEntity donation;
  const DonationDetailsDialog({super.key, required this.donation});

  @override
  Widget build(BuildContext context) {
    final isPending = (donation.status?.toLowerCase() == 'pending');
    return AlertDialog(
      title: const Text('Donation Details'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item: ${donation.itemName}'),
            Text('Category: ${donation.category}'),
            if (donation.description != null &&
                donation.description!.isNotEmpty)
              Text('Description: ${donation.description}'),
            Text('Quantity: ${donation.quantity}'),
            Text('Condition: ${donation.condition}'),
            Text('Pickup Location: ${donation.pickupLocation}'),
            if (donation.status != null) Text('Status: ${donation.status}'),
            if (donation.createdAt != null)
              Text(
                'Created: ${donation.createdAt!.year}-${donation.createdAt!.month.toString().padLeft(2, '0')}-${donation.createdAt!.day.toString().padLeft(2, '0')}',
              ),
          ],
        ),
      ),
      actions: [
        if (isPending)
          TextButton(
            onPressed: () => Navigator.of(context).pop('cancel'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cancel Donation'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
