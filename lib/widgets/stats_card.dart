import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color cardColor;

  const StatsCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.cardColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: 200,
      child: Card(
        color: cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 40,
                color: const Color.fromARGB(255, 249, 243, 243),
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 249, 243, 243),
                ),
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 249, 243, 243),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
