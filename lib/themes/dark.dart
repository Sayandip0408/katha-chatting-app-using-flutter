import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  primaryColor: const Color.fromRGBO(8, 20, 25, 1),
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    background: Color.fromRGBO(8, 20, 25, 1),
    primary: Colors.white,
    secondary: Colors.white54,
    tertiary: Color.fromRGBO(0, 92, 74, 1.0),
    primaryContainer:Color.fromRGBO(31, 44, 51, 1),
    secondaryContainer: Colors.white,
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
    backgroundColor:Color.fromRGBO(31, 44, 51, 1),
  ),
);
