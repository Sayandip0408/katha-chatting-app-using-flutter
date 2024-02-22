import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    background: Color.fromRGBO(239, 231, 222, 1),
    primary: Colors.green,
    secondary: Colors.black54,
    tertiary: Color.fromRGBO(230, 255, 218, 1.0),
    primaryContainer: Colors.white,
    secondaryContainer: Colors.black,
  ),
  appBarTheme: const AppBarTheme(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    centerTitle: true,
    backgroundColor: Color.fromRGBO(1, 129, 105, 1),
  ),
);
