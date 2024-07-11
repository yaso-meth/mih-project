import 'package:flutter/material.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/router/routeGenerator.dart';
import 'package:patient_manager/theme/mihTheme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Supabase.initialize(
//     url: "https://stzluvsyhbwtfbztarmu.supabase.co",
//     anonKey:
//         "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN0emx1dnN5aGJ3dGZienRhcm11Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTIwNzUyMTMsImV4cCI6MjAyNzY1MTIxM30.a7VHlk63JJcAotvsqtoqiKwjNK4EbnNgKilAqt1iRio",
//   );
//   runApp(const MzanziInnovationHub());
// }

final client = Supabase.instance.client;

class MzanziInnovationHub extends StatefulWidget {
  //final AppEnviroment appEnv;

  const MzanziInnovationHub({
    super.key,
    //required this.appEnv,
  });

  @override
  State<MzanziInnovationHub> createState() => _MzanziInnovationHubState();

  static _MzanziInnovationHubState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MzanziInnovationHubState>();
}

class _MzanziInnovationHubState extends State<MzanziInnovationHub> {
  late ThemeMode _themeMode;
  late MyTheme theme;

  Color getPrimany() {
    return theme.primaryColor();
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
      //print(_themeMode);
      if (_themeMode == ThemeMode.light) {
        setState(() {
          theme.mode = "Light";
        });
        //print(theme.mode);
      } else {
        setState(() {
          theme.mode = "Dark";
        });
        //print(theme.mode);
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
      title: 'Mzansi Innovation Hub - ${AppEnviroment.getEnv()}',
      themeMode: _themeMode,
      theme: theme.darkMode(),
      darkTheme: theme.lightMode(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
