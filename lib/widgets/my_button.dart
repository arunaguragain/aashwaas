// import 'package:flutter/material.dart';

// class MyButton extends StatelessWidget {
//   const MyButton({
//     super.key,
//     required this.onPressed,
//     required this.text,
//     this.color,
//     this.textColor, 
//     this.icon,
//   });

//   //on pressed Callback
//   final VoidCallback onPressed;
//   final String text;
//   final Color? color;
//   final Color? textColor;
//   final Icon? icon;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 500,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color ?? Colors.blueAccent,
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//         ),

//         onPressed: onPressed,
//         child: Text(
//           text,
//           style: TextStyle(color: textColor ?? Colors.white, fontSize: 20),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.textColor, 
    this.icon,
  });

  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final Color? textColor;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.blueAccent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),

        onPressed: onPressed,
        
        child: icon == null
            ? Text(
                text,
                style: TextStyle(color: textColor ?? Colors.white, fontSize: 20),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,                       // ← your icon
                  const SizedBox(width: 10),   // space between icon and text
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
