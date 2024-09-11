import 'package:flutter/material.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/router/routeGenerator.dart';
import 'package:patient_manager/theme/mihTheme.dart';
import 'package:no_screenshot/no_screenshot.dart';

class MzanziInnovationHub extends StatefulWidget {
  const MzanziInnovationHub({
    super.key,
  });

  @override
  State<MzanziInnovationHub> createState() => _MzanziInnovationHubState();

  // ignore: library_private_types_in_public_api
  static _MzanziInnovationHubState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MzanziInnovationHubState>();
}

class _MzanziInnovationHubState extends State<MzanziInnovationHub> {
  late ThemeMode _themeMode;
  late MyTheme theme;
  final _noScreenshot = NoScreenshot.instance;

  void disableScreenshot() async {
    bool result = await _noScreenshot.screenshotOff();
    debugPrint('Screenshot Off: $result');
  }

  Color getPrimany() {
    return theme.primaryColor();
  }

  String getTitle() {
    if (AppEnviroment.getEnv() == "Dev") {
      return "Mzansi Innovation Hub - Dev";
    } else {
      return "Mzansi Innovation Hub";
    }
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
      if (_themeMode == ThemeMode.light) {
        setState(() {
          theme.mode = "Light";
        });
      } else {
        setState(() {
          theme.mode = "Dark";
        });
      }
    });
  }

  void setPlatformSpecificPlugins() {
    print("is PWA: ${theme.isPwa()}");
    if (theme.isPwa()) {
      disableScreenshot();
    }
  }

  @override
  void initState() {
    _themeMode = ThemeMode.dark;
    theme = MyTheme();
    setPlatformSpecificPlugins();
    theme.mode = "Dark";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    theme.setScreenType(width);
    precacheImage(theme.loadingImage(), context);
    precacheImage(theme.logoImage(), context);
    precacheImage(theme.logoFrame(), context);
    return MaterialApp(
      title: getTitle(),
      themeMode: _themeMode,
      theme: theme.darkMode(),
      darkTheme: theme.lightMode(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
