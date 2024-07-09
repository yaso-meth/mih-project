import 'package:flutter/material.dart';

class MyTheme {
  late int _mainColor;
  late int _secondColor;
  late int _errColor;
  late int _succColor;
  late int _mesColor;
  late ThemeData data;

  // Options:-
  // f3f9d2 = Cream
  // f0f0c9 = cream2
  // caffd0 = light green
  // B0F2B4 = light grean 2 *
  // 85bda6 = light green 3
  // 70f8ba = green
  // F7F3EA = white
  // a63446 = red

  MyTheme() {
    _mainColor = 0XFF3A4454;
    _secondColor = 0XFFbedcfe;
    _errColor = 0xffD87E8B;
    _succColor = 0xffB0F2B4;
    _mesColor = 0xffc8c8c8d9;
    data = ThemeData(
      scaffoldBackgroundColor: primaryColor(),
      colorScheme: ColorScheme.dark(
        primary: messageTextColor(),
        onPrimary: primaryColor(),
        onSurface: secondaryColor(),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: primaryColor(),

        //------------------------------
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(secondaryColor()),
          overlayColor: WidgetStatePropertyAll(messageTextColor()),
        ),
        //------------------------------
        confirmButtonStyle: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(secondaryColor()),
          overlayColor: WidgetStatePropertyAll(messageTextColor()),
        ),
        headerBackgroundColor: secondaryColor(),
        headerForegroundColor: primaryColor(),
      ),
      appBarTheme: AppBarTheme(
        color: secondaryColor(),
      ),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(backgroundColor: secondaryColor()),
    );
  }

  Color messageTextColor() {
    return Color(_mesColor);
  }

  Color errorColor() {
    return Color(_errColor);
  }

  Color successColor() {
    return Color(_succColor);
  }

  Color primaryColor() {
    return Color(_mainColor);
  }

  Color secondaryColor() {
    return Color(_secondColor);
  }
}
