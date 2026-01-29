import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import "package:universal_html/html.dart" as html;

class MihTheme {
  late String mode;
  late String screenType;
  late AssetImage loading;
  late String loadingAssetText;
  late TargetPlatform platform;
  bool kIsWeb = const bool.fromEnvironment('dart.library.js_util');
  String latestVersion = "1.2.5";
  MihTheme() {
    mode = "Dark";
  }

  ThemeData getData(bool bool) {
    return ThemeData(
      fontFamily: 'Segoe UI',
      scaffoldBackgroundColor: MihColors.getPrimaryColor(mode == "Dark"),
      colorScheme: ColorScheme(
        brightness: getBritness(),
        primary: MihColors.getSecondaryColor(mode == "Dark"),
        onPrimary: MihColors.getPrimaryColor(mode == "Dark"),
        secondary: MihColors.getPrimaryColor(mode == "Dark"),
        onSecondary: MihColors.getSecondaryColor(mode == "Dark"),
        error: MihColors.getRedColor(mode == "Dark"),
        onError: MihColors.getPrimaryColor(mode == "Dark"),
        surface: MihColors.getPrimaryColor(mode == "Dark"),
        onSurface: MihColors.getSecondaryColor(mode == "Dark"),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: MihColors.getPrimaryColor(mode == "Dark"),
        headerBackgroundColor: MihColors.getSecondaryColor(mode == "Dark"),
        headerForegroundColor: MihColors.getPrimaryColor(mode == "Dark"),
      ),
      appBarTheme: AppBarTheme(
        color: MihColors.getSecondaryColor(mode == "Dark"),
        foregroundColor: MihColors.getPrimaryColor(mode == "Dark"),
        titleTextStyle: TextStyle(
          color: MihColors.getPrimaryColor(mode == "Dark"),
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: MihColors.getSecondaryColor(mode == "Dark"),
        foregroundColor: MihColors.getPrimaryColor(mode == "Dark"),
        extendedTextStyle:
            TextStyle(color: MihColors.getPrimaryColor(mode == "Dark")),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: MihColors.getPrimaryColor(mode == "Dark"),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: MihColors.getPrimaryColor(mode == "Dark"),
        selectionColor:
            MihColors.getPrimaryColor(mode == "Dark").withOpacity(0.25),
        selectionHandleColor: MihColors.getPrimaryColor(mode == "Dark"),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: MihColors.getSecondaryColor(mode == "Dark"),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            width: 1.0,
            color: MihColors.getPrimaryColor(mode == "Dark"),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  MihColors.getPrimaryColor(mode == "Dark").withOpacity(0.18),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        textStyle: TextStyle(
          color: MihColors.getPrimaryColor(mode == "Dark"),
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

  String getLatestVersion() {
    return latestVersion;
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
