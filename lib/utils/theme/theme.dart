import 'package:flutter/material.dart';
import 'package:the_app/utils/theme/theme_text.dart';

class TheAppTheme{

  TheAppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.orange,
    textTheme: ThemeTexts.lightTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom()),
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.orange,
      textTheme: ThemeTexts.darkTheme,
  );
}