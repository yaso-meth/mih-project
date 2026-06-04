import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import "package:universal_html/html.dart" as html;

class MihTheme {
  late String mode;
  late String screenType;
  late AssetImage loading;
  late String loadingAssetText;
  late TargetPlatform platform;
  bool kIsWeb = const bool.fromEnvironment('dart.library.js_util');
  String latestVersion = "1.2.6";
  MihTheme() {
    mode = "Dark";
  }

  ThemeData getData(bool bool) {
    return ThemeData(
      fontFamily: 'Segoe UI',
      scaffoldBackgroundColor: MihColors.primary(),
      colorScheme: ColorScheme(
        brightness: getBritness(),
        primary: MihColors.secondary(),
        onPrimary: MihColors.primary(),
        secondary: MihColors.primary(),
        onSecondary: MihColors.secondary(),
        error: MihColors.red(),
        onError: MihColors.primary(),
        surface: MihColors.primary(),
        onSurface: MihColors.secondary(),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: MihColors.primary(),
        headerBackgroundColor: MihColors.secondary(),
        headerForegroundColor: MihColors.primary(),
      ),
      appBarTheme: AppBarTheme(
        color: MihColors.secondary(),
        foregroundColor: MihColors.primary(),
        titleTextStyle: TextStyle(
          color: MihColors.primary(),
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: MihColors.secondary(),
        foregroundColor: MihColors.primary(),
        extendedTextStyle: TextStyle(color: MihColors.primary()),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: MihColors.primary(),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: MihColors.primary(),
        selectionColor: MihColors.primary().withOpacity(0.25),
        selectionHandleColor: MihColors.primary(),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: MihColors.secondary(),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            width: 1.0,
            color: MihColors.primary(),
          ),
          boxShadow: [
            BoxShadow(
              color: MihColors.primary().withOpacity(0.18),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        textStyle: TextStyle(
          color: MihColors.primary(),
          fontSize: 13,
          height: 1.2,
        ),
        waitDuration: const Duration(milliseconds: 500),
        showDuration: const Duration(seconds: 3),
        preferBelow: true,
        verticalOffset: 24,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        triggerMode: TooltipTriggerMode.longPress,
      ),
    );
  }

  String getPlatform() {
    if (kIsWeb) {
      return "Web";
    } else if (!kIsWeb) {
      if (platform == TargetPlatform.android) {
        return "Android";
      } else if (platform == TargetPlatform.iOS) {
        return "iOS";
      } else if (platform == TargetPlatform.linux) {
        return "Linux";
      } else if (platform == TargetPlatform.macOS) {
        return "macOS";
      } else if (platform == TargetPlatform.windows) {
        return "Windows";
      }
    }
    return "Other";
  }

  bool isPwa() {
    return html.window.matchMedia('(display-mode: standalone)').matches;
  }

  void setMode(String m) {
    mode;
  }

  ThemeData getThemeData() {
    return getData(mode == "Dark");
  }

  ThemeData darkMode() {
    return getData(mode == "Dark");
  }

  ThemeData lightMode() {
    return getData(mode == "Dark");
  }

  Brightness getBritness() {
    if (mode == "Dark") {
      return Brightness.dark;
    } else {
      return Brightness.light;
    }
  }

  void setScreenType(double width) {
    if (width <= 800) {
      screenType = "mobile";
    } else {
      screenType = "desktop";
    }
  }
}
