import 'package:flutter/material.dart';
import '../mih_env/env.dart';
import '../mih_router/routeGenerator.dart';
import '../mih_theme/mih_theme.dart';

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
      } else if (_themeMode == ThemeMode.dark) {
        setState(() {
          theme.mode = "Dark";
        });
      } else {
        setState(() {
          theme.mode = "Dark";
        });
      }
    });
  }

  // void doInit() async {
  //   print(
  //       "FpjsProPlugin.initFpjs Token: ${AppEnviroment.fingerPrintPluginKey}");
  //   await FpjsProPlugin.initFpjs(
  //     AppEnviroment.fingerPrintPluginKey, // insert your actual API key here
  //     endpoint: "https://mzansi-innovation-hub.co.za",
  //     scriptUrlPattern:
  //         'https://mzansi-innovation-hub.co.za/web/v<version>/<apiKey>/loader_v<loaderVersion>.js',
  //   );
  //   identify();
  // }

  // void identify() async {
  //   try {
  //     var visitorId = await FpjsProPlugin.getVisitorId() ?? 'Unknown';
  //     print(visitorId);
  //     // use the visitor id
  //   } on FingerprintProError catch (e) {
  //     print("Error on Init: $e");
  //     // process an error somehow
  //     // check lib/error.dart to get more info about error types
  //   }
  // }

  @override
  void initState() {
    _themeMode = ThemeMode.dark;
    theme = MyTheme();
    theme.platform = Theme.of(context).platform;
    // var brightness =
    //     SchedulerBinding.instance.platformDispatcher.platformBrightness;
    // bool isDarkMode = brightness == Brightness.dark;
    // if (isDarkMode) {
    //   theme.mode = "Dark";
    // } else {
    //   theme.mode = "Light";
    // }

    super.initState();
    //doInit();
  }

  @override
  Widget build(BuildContext context) {
    // var brightness =
    //     SchedulerBinding.instance.platformDispatcher.platformBrightness;
    // bool isDarkMode = brightness == Brightness.dark;
    // if (isDarkMode) {
    //   theme.mode = "Dark";
    // } else {
    //   theme.mode = "Light";
    // }
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
