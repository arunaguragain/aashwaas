import 'package:aashwaas/features/dashboard/presentation/widgets/history_summary_chip.dart';
import 'package:flutter/material.dart';

class HistorySummaryRow extends StatelessWidget {
  final int total;
  final int delivered;
  final int pending;

  const HistorySummaryRow({
    super.key,
    required this.total,
    required this.delivered,
    required this.pending,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: HistorySummaryChip(
            count: total,
            label: 'Total',
            color: const Color(0xFF3B70D6),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: HistorySummaryChip(
            count: delivered,
            label: 'Delivered',
            color: const Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: HistorySummaryChip(
            count: pending,
            label: 'Pending',
            color: const Color(0xFFFFA726),
          ),
        ),
      ],
    );
  }
}
