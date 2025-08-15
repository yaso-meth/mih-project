import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import "package:universal_html/html.dart" as html;

class MihTheme {
  // late int _mainColor;
  // late int _secondColor;
  //late int _errColor;
  //late int _succColor;
  // late int _mesColor;
  late String mode;
  late String screenType;
  late AssetImage loading;
  late String loadingAssetText;
  late TargetPlatform platform;
  bool kIsWeb = const bool.fromEnvironment('dart.library.js_util');
  String latestVersion = "1.1.15";
  // Options:-
  // f3f9d2 = Cream
  // f0f0c9 = cream2
  // caffd0 = light green
  // B0F2B4 = light grean 2 *
  // 85bda6 = light green 3
  // 70f8ba = green
  // F7F3EA = white
  // a63446 = red
  //747474

  MihTheme() {
    mode = "Dark";
    //_errColor = 0xffD87E8B;
    //_succColor = 0xffB0F2B4;
    //_mesColor = 0xffc8c8c8d9;
  }

  ThemeData getData(bool bool) {
    return ThemeData(
        fontFamily: 'Segoe UI',
        scaffoldBackgroundColor: MihColors.getPrimaryColor(mode == "Dark"),
        // pageTransitionsTheme: PageTransitionsTheme(
        //   builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
        //     TargetPlatform.values,
        //     value: (dynamic _) => const FadeUpwardsPageTransitionsBuilder(),
        //   ),
        // ),
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
        ));
  }

  String getPlatform() {
    // if (isPwa()) {
    //   if (platform == TargetPlatform.android) {
    //     return "Android";
    //   } else if (platform == TargetPlatform.iOS) {
    //     return "iOS";
    //   }
    // } else
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

  // Color messageTextColor() {
  //   if (mode == "Dark") {
  //     _mesColor = 0XFFc8c8c8;
  //   } else {
  //     _mesColor = 0XFF747474;
  //   }
  //   return Color(_mesColor);
  // }

  // Color errorColor() {
  //   if (mode == "Dark") {
  //     return const Color(0xffD87E8B);
  //   } else {
  //     return const Color(0xffbb3d4f);
  //   }
  //   //return Color(_errColor);
  // }

  // Color highlightColor() {
  //   if (mode == "Dark") {
  //     return const Color(0XFF9bc7fa);
  //   } else {
  //     return const Color(0XFF354866);
  //   }
  // }

  // Color successColor() {
  //   if (mode == "Dark") {
  //     return const Color(0xffB0F2B4);
  //   } else {
  //     return const Color(0xff56a95b);
  //   }
  // }

  AssetImage loadingImage() {
    if (mode == "Dark") {
      loading = const AssetImage(
        'lib/mih_components/mih_package_components/assets/images/loading_light.gif',
      );
    } else {
      loading = const AssetImage(
        'lib/mih_components/mih_package_components/assets/images/loading_dark.gif',
      );
    }
    return loading;
  }

  AssetImage altLoadingImage() {
    if (mode == "Dark") {
      loading = const AssetImage(
        'lib/mih_components/mih_package_components/assets/images/loading_dark.gif',
      );
    } else {
      loading = const AssetImage(
        'lib/mih_components/mih_package_components/assets/images/loading_light.gif',
      );
    }
    return loading;
  }

  String loadingImageLocation() {
    if (mode == "Dark") {
      loadingAssetText =
          'lib/mih_components/mih_package_components/assets/images/loading_light.gif';
    } else {
      loadingAssetText =
          'lib/mih_components/mih_package_components/assets/images/loading_dark.gif';
    }
    return loadingAssetText;
  }

  String altLoadingImageLocation() {
    if (mode == "Dark") {
      loadingAssetText =
          'lib/mih_components/mih_package_components/assets/images/loading_dark.gif';
    } else {
      loadingAssetText =
          'lib/mih_components/mih_package_components/assets/images/loading_light.gif';
    }
    return loadingAssetText;
  }

  AssetImage aiLogoImage() {
    if (mode == "Dark") {
      return const AssetImage(
        'lib/mih_components/mih_package_components/assets/images/mzansi_ai-dark.png',
      );
    } else {
      return const AssetImage(
        'lib/mih_components/mih_package_components/assets/images/mzansi_ai-light.png',
      );
    }
  }

  void setScreenType(double width) {
    if (width <= 800) {
      screenType = "mobile";
    } else {
      screenType = "desktop";
    }
  }

  // Color MihColors.getPrimaryColor(mode == "Dark") {
  //   if (mode == "Dark") {
  //     _mainColor = 0XFF3A4454;
  //   } else {
  //     _mainColor = 0XFFbedcfe;
  //   }
  //   return Color(_mainColor);
  // }

//   Color MihColors.getSecondaryColor(mode == "Dark") {
//     if (mode == "Dark") {
//       _secondColor = 0XFFbedcfe;
//     } else {
//       _secondColor = 0XFF3A4454;
//     }
//     return Color(_secondColor);
//   }
}
