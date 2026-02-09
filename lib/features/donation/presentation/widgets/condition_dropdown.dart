import 'package:flutter/material.dart';

class DonationConditionDropdown extends StatelessWidget {
  final String label;
  final String? selectedCondition;
  final List<String> conditions;
  final Function(String?) onChanged;

  const DonationConditionDropdown({
    super.key,
    required this.label,
    required this.selectedCondition,
    required this.conditions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final hintColor = theme.hintColor;
    final fillColor =
        theme.inputDecorationTheme.fillColor ?? Colors.grey[100];
    final borderColor = theme.dividerColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedCondition,
          hint: Text(
            'Select Condition',
            style: TextStyle(color: hintColor),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
          ),
          items: conditions.map((String condition) {
            return DropdownMenuItem<String>(
              value: condition,
              child: Text(condition),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}
