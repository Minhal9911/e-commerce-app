
import 'package:flutter/material.dart';

class AppTheme {
  ///Light theme data-----------------------------------------------------------
  static ThemeData lightTheme(){
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: Colors.blue
    );
  }

  ///Dark theme data------------------------------------------------------------
  static ThemeData darkTheme(){
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.blue
    );
  }
}