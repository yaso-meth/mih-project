import 'package:flutter/material.dart';
import 'mih_config/mih_env.dart';
import 'mih_config/mih_routeGenerator.dart';
import 'mih_config/mih_theme.dart';

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
  late MihTheme theme;

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
      if (themeMode == ThemeMode.light) {
        setState(() {
          theme.mode = "Light";
        });
      } else if (themeMode == ThemeMode.dark) {
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

  @override
  void initState() {
    theme = MihTheme();
    // var systemTheme =
    //     SchedulerBinding.instance.platformDispatcher.platformBrightness;
    // bool isDarkMode = systemTheme == Brightness.dark;
    // if (isDarkMode) {
    //   theme.mode = "Dark";
    // } else {
    //   theme.mode = "Light";
    // }
    theme.mode = "Dark";
    theme.platform = Theme.of(context).platform;
    super.initState();
    //doInit();
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
      themeMode: ThemeMode.dark,
      theme: theme.getThemeData(),
      darkTheme: theme.getThemeData(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
