import 'package:flutter/material.dart';

class ThemeClass {
  static Color lightBackgroundColor = Colors.white;
  static Color darkBackgroundColor = Colors.black;
  static Color primaryColor = Colors.blue;
  static Color lightSecondaryColor = Colors.grey.shade900;
  static Color darkSecondaryColor = Colors.grey.shade500;
  static Color lightTextColor = Colors.black;
  static Color darkTextColor = Colors.white;
  static Color lightIconColor = Colors.black;
  static Color darkIconColor = Colors.white;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: lightBackgroundColor,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: lightBackgroundColor,
    ),
    iconTheme: IconThemeData(
      color: lightIconColor,
    ),
    colorScheme: ColorScheme.light(
      onPrimary: lightTextColor,
      primary: primaryColor,
      background: lightBackgroundColor,
      secondary: lightSecondaryColor,
      onSecondary: Colors.grey.shade100,
      onBackground: Colors.purpleAccent.shade200,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackgroundColor,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: darkBackgroundColor,
    ),
    iconTheme: IconThemeData(
      color: darkIconColor,
    ),
    colorScheme: ColorScheme.dark(
      onPrimary: darkTextColor,
      primary: primaryColor,
      background: darkBackgroundColor,
      secondary: darkSecondaryColor,
      onSecondary: lightSecondaryColor,
      onBackground: Colors.purpleAccent.shade700,
    ),
  );
}
