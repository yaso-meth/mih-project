import 'package:flutter/material.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/router/routeGenerator.dart';
import 'package:patient_manager/theme/mihTheme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;

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
      } else {
        setState(() {
          theme.mode = "Dark";
        });
      }
    });
  }

  @override
  void initState() {
    _themeMode = ThemeMode.dark;
    theme = MyTheme();
    theme.mode = "Dark";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
