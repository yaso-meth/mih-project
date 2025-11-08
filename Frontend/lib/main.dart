import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/about_mih_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_access_controlls_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_authentication_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_banner_ad_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_calculator_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_ai_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_wallet_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/patient_manager_provider.dart';
import 'package:provider/provider.dart';
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

  @override
  void initState() {
    super.initState();
    theme = MihTheme();
    theme.mode = "Dark";
    theme.platform = Theme.of(context).platform;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    theme.setScreenType(width);
    precacheImage(theme.loadingImage(), context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MihAuthenticationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MzansiProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MzansiWalletProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MzansiAiProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MzansiDirectoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MihBannerAdProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MihCalculatorProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MihAccessControllsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MihCalendarProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AboutMihProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MihMineSweeperProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PatientManagerProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: AppEnviroment.getEnv() == "Dev"
            ? "Dev | MIH App: Mzansi Innovation Hub"
            : "MIH App: Mzansi Innovation Hub",
        themeMode: ThemeMode.dark,
        theme: theme.getThemeData(),
        darkTheme: theme.getThemeData(),
        debugShowCheckedModeBanner: false,
        routerConfig: widget.router,
        builder: (context, child) {
          if (child == null) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return UpgradeAlert(
            navigatorKey: widget.router.routerDelegate.navigatorKey,
            child: child,
          );
        },
      ),
    );
  }
}
