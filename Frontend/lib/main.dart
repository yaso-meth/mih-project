import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:upgrader/upgrader.dart';
import 'mih_config/mih_env.dart';
import 'mih_config/mih_theme.dart';

class MzansiInnovationHub extends StatefulWidget {
  final GoRouter router;
  const MzansiInnovationHub({
    super.key,
    required this.router,
  });

  @override
  State<MzansiInnovationHub> createState() => _MzansiInnovationHubState();

  // ignore: library_private_types_in_public_api
  static _MzansiInnovationHubState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MzansiInnovationHubState>();
}

class _MzansiInnovationHubState extends State<MzansiInnovationHub> {
  late MihTheme theme;

  Color getPrimany() {
    return MihColors.getPrimaryColor(theme.mode == "Dark");
  }

  String getTitle() {
    if (AppEnviroment.getEnv() == "Dev") {
      return "Dev | MIH App: Mzansi Innovation Hub";
    } else {
      return "MIH App: Mzansi Innovation Hub";
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
    super.initState();
    theme.mode = "Dark";
    theme.platform = Theme.of(context).platform;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    theme.setScreenType(width);
    precacheImage(theme.loadingImage(), context);
    return MaterialApp.router(
      title: getTitle(),
      themeMode: ThemeMode.dark,
      theme: theme.getThemeData(),
      darkTheme: theme.getThemeData(),
      debugShowCheckedModeBanner: false,
      routerConfig: widget.router,
      builder: (context, child) {
        return UpgradeAlert(
          navigatorKey: widget.router.routerDelegate.navigatorKey,
          child: child ?? const Text('Upgrade Alert'),
        );
      },
    );
  }
}
