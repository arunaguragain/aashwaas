import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.textColor,
    this.icon, 
    this.isLoading,
  });

  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final Icon? icon;
  final bool? isLoading;

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
        child: icon == null
            ? Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 20,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!, 
                  const SizedBox(width: 10), 
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
