import 'package:flutter/material.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({
    super.key,
    required this.primaryLabel,
    required this.primaryValue,
    required this.primaryIcon,
    required this.primaryIconColor,
    required this.secondaryLabel,
    required this.secondaryValue,
    required this.secondaryIcon,
    required this.secondaryIconColor,
    required this.isLoading,
  });

  final String primaryLabel;
  final String primaryValue;
  final IconData primaryIcon;
  final Color primaryIconColor;
  final String secondaryLabel;
  final String secondaryValue;
  final IconData secondaryIcon;
  final Color secondaryIconColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E8EF)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: primaryIcon,
              iconColor: primaryIconColor,
              value: isLoading ? '--' : primaryValue,
              label: primaryLabel,
            ),
          ),
          Container(width: 1, height: 48, color: const Color(0xFFE6EAF1)),
          Expanded(
            child: _StatItem(
              icon: secondaryIcon,
              iconColor: secondaryIconColor,
              value: isLoading ? '--' : secondaryValue,
              label: secondaryLabel,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF7A869A)),
        ),
      ],
    );
  }
}
