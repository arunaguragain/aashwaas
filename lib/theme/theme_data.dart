import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    primarySwatch: Colors.orange,
    scaffoldBackgroundColor: Color(0xFFD3E3FF),
    fontFamily: 'OpenSans Regular',

    appBarTheme: AppBarThemeData(
      backgroundColor: Color(0xFFD3E3FF),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    ),
  );
}
