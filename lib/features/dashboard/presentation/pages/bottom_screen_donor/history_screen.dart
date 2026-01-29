import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = _mockHistoryItems();
    final totalCount = items.length;
    final deliveredCount = items
        .where((item) => item.status == DonationStatus.delivered)
        .length;
    final pendingCount = items
        .where((item) => item.status == DonationStatus.pending)
        .length;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSummaryRow(
            total: totalCount,
            delivered: deliveredCount,
            pending: pendingCount,
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _DonationHistoryCard(item: item)),
        ],
      ),
    );
  }
}

class _DonationHistoryCard extends StatelessWidget {
  final DonationHistoryItem item;

  const _DonationHistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
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
              _ImagePlaceholder(color: item.imageColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        _CategoryPill(label: item.category),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.itemsCount} items',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _StatusChip(status: item.status),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(icon: Icons.location_on_outlined, text: item.organization),
          const SizedBox(height: 6),
          _InfoRow(
            icon: Icons.schedule_outlined,
            text: 'Submitted: ${item.submittedDate}',
          ),
          if (item.deliveredDate != null) ...[
            const SizedBox(height: 6),
            _InfoRow(
              icon: Icons.check_circle_outline,
              text: 'Delivered: ${item.deliveredDate}',
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Edit'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.redAccent),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final Color color;

  const _ImagePlaceholder({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      width: 74,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.image, color: Colors.white),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;

  const _CategoryPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, color: Color(0xFF3B70D6)),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final DonationStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      DonationStatus.delivered => const Color(0xFF4CAF50),
      DonationStatus.pending => const Color(0xFFFFA726),
    };
    final text = switch (status) {
      DonationStatus.delivered => 'Delivered',
      DonationStatus.pending => 'Pending Approved',
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, color: color)),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

Widget _buildSummaryRow({
  required int total,
  required int delivered,
  required int pending,
}) {
  return Row(
    children: [
      Expanded(
        child: _SummaryChip(
          count: total,
          label: 'Total',
          color: const Color(0xFF3B70D6),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _SummaryChip(
          count: delivered,
          label: 'Delivered',
          color: const Color(0xFF4CAF50),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: _SummaryChip(
          count: pending,
          label: 'Pending',
          color: const Color(0xFFFFA726),
        ),
      ),
    ],
  );
}

class _SummaryChip extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _SummaryChip({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

enum DonationStatus { delivered, pending }

class DonationHistoryItem {
  final String title;
  final String category;
  final int itemsCount;
  final String organization;
  final String submittedDate;
  final String? deliveredDate;
  final DonationStatus status;
  final Color imageColor;

  DonationHistoryItem({
    required this.title,
    required this.category,
    required this.itemsCount,
    required this.organization,
    required this.submittedDate,
    this.deliveredDate,
    required this.status,
    required this.imageColor,
  });
}

List<DonationHistoryItem> _mockHistoryItems() {
  return [
    DonationHistoryItem(
      title: 'Winter Clothes Bundle',
      category: 'Clothes',
      itemsCount: 8,
      organization: 'Hope Foundation',
      submittedDate: '2025-11-10',
      deliveredDate: '2025-11-19',
      status: DonationStatus.delivered,
      imageColor: const Color(0xFFBCAAA4),
    ),
    DonationHistoryItem(
      title: 'School Books & Stationery',
      category: 'Books',
      itemsCount: 15,
      organization: 'Bright Future Orphanage',
      submittedDate: '2025-11-19',
      deliveredDate: null,
      status: DonationStatus.pending,
      imageColor: const Color(0xFF90CAF9),
    ),
  ];
}
