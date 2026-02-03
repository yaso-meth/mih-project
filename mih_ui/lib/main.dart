import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/mih_providers/about_mih_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_access_controlls_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_authentication_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_banner_ad_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calculator_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_file_viewer_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_ai_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_wallet_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
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
  final QuickActions quickActions = QuickActions();
  String shortcut = 'no action set';

  void _initializeQuickActions() {
    quickActions.initialize((String shortcutType) {
      setState(() {
        shortcut = shortcutType;
      });
      if (shortcutType == 'mihHome') {
        KenLogger.success("ShortCut: mihHome");
        widget.router.goNamed("mihHome");
      }
      if (shortcutType == 'mzansiWallet') {
        KenLogger.success("ShortCut: mzansiWallet");
        widget.router.goNamed("mzansiWallet");
      }
      if (shortcutType == 'mzansiAi') {
        KenLogger.success("ShortCut: mzansiAi");
        widget.router.goNamed("mzansiAi");
      }
      if (shortcutType == 'mihCalculator') {
        KenLogger.success("ShortCut: mihCalculator");
        widget.router.goNamed("mihCalculator");
      }
    });
    // Set the quick actions
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'mzansiWallet',
        localizedTitle: 'Mzansi Wallet',
        icon: 'mzansi_wallet_sc',
      ),
      const ShortcutItem(
        type: 'mzansiAi',
        localizedTitle: 'Mzansi AI',
        icon: 'mzansi_ai_sc',
      ),
      const ShortcutItem(
        type: 'mihCalculator',
        localizedTitle: 'MIH Calc',
        icon: 'mih_calculator_sc',
      ),
    ]).then((void _) {
      setState(() {
        if (shortcut == 'no action set') {
          shortcut = 'mih_home_sc';
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      _initializeQuickActions();
    }
    theme = MihTheme();
    theme.mode = "Dark";
    theme.platform = Theme.of(context).platform;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    theme.setScreenType(width);
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
        ChangeNotifierProvider(
          create: (context) => MihFileViewerProvider(),
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
