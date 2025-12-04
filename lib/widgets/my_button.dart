import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color, 
    this.textColor,
  });

  //on pressed Callback
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.blueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),

        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: textColor ?? Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
