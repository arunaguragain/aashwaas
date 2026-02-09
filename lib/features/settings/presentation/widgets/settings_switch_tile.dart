import 'package:flutter/material.dart';

class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.showDivider = true,
  });

  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.notifications_none, color: Color(0xFF6B7280)),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          trailing: Switch.adaptive(value: value, onChanged: onChanged),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Divider(height: 1, color: Color(0xFFE5E7EB)),
          ),
      ],
    );
  }
}
