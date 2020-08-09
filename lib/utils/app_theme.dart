import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    primaryColorLight: Colors.grey[800],
    accentColor: Colors.blue,
    errorColor: Colors.red[700],
    iconTheme: IconThemeData(
      color: Colors.blue,
    ),
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ),
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Colors.grey[600],
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyText2: TextStyle(
        color: Colors.grey[600],
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      headline1: TextStyle(
        color: Colors.blue,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      headline4: TextStyle(
        color: Colors.blue,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      headline5: TextStyle(
        color: Colors.blue,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      headline6: TextStyle(
        color: Colors.blue,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    canvasColor: Color(0xFFFFFFFF),
    appBarTheme: AppBarTheme(
      color: Color(0xF4FFFFFF),
      brightness: Brightness.light,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.blueGrey[900],
    ),
    primaryColor: Colors.blueGrey[900],
    primaryColorLight: Colors.white70,
    accentColor: Colors.blue[900],
    cardTheme: CardTheme(
      color: Colors.blueGrey[900],
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.blueGrey[900],
    ),
    dialogTheme: DialogTheme(
      backgroundColor: Colors.blueGrey[900],
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
    ),
    iconTheme: IconThemeData(
      color: Colors.blue[900],
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyText2: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      headline1: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      headline4: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      headline5: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      headline6: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    ),
    errorColor: Colors.red[900],
    bottomAppBarColor: Colors.blue[900],
    canvasColor: Color(0xFF000000),
    appBarTheme: AppBarTheme(
      color: Color(0xF0000000),
      brightness: Brightness.dark,
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
