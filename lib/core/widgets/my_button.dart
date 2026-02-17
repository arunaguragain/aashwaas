import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    this.onPressed,
    required this.text,
    this.color,
    this.textColor,
    this.icon,
    this.isLoading,
  });

  final VoidCallback? onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final Icon? icon;
  final bool? isLoading;

  @override
  Widget build(BuildContext context) {
    final bool loading = isLoading == true;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.blueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),

        onPressed: loading ? null : onPressed,
        child: loading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    textColor ?? Colors.white,
                  ),
                ),
              )
            : (icon == null
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
                    )),
      ),
    );
  }
}
