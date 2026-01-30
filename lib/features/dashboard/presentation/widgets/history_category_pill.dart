import 'package:flutter/material.dart';

class HistoryCategoryPill extends StatelessWidget {
  final String label;

  const HistoryCategoryPill({super.key, required this.label});

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
