import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor,
    this.iconColor,
    this.showChevron = true,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? iconColor;
  final bool showChevron;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final effectiveTitleColor = titleColor ?? const Color(0xFF374151);
    final effectiveIconColor = iconColor ?? const Color(0xFF6B7280);

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: effectiveIconColor),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: effectiveTitleColor,
              ),
            ),
            trailing: showChevron
                ? const Icon(Icons.chevron_right, color: Color(0xFF9CA3AF))
                : null,
          ),
          if (showDivider)
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Divider(height: 1, color: Color(0xFFE5E7EB)),
            ),
        ],
      ),
    );
  }
}
