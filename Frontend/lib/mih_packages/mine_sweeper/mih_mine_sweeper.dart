import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_banner_ad_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/package_tools/mih_mine_sweeper_leader_board.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/package_tools/mine_sweeper_game.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/package_tools/mine_sweeper_quick_start_guide.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/package_tools/my_score_board.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_data_helper_services.dart';
import 'package:provider/provider.dart';

class MihMineSweeper extends StatefulWidget {
  const MihMineSweeper({super.key});

  @override
  State<MihMineSweeper> createState() => _MihMineSweeperState();
}

class _MihMineSweeperState extends State<MihMineSweeper> {
  bool _isLoadingInitialData = true;
  late final MineSweeperGame _mineSweeperGame;
  late final MihMineSweeperLeaderBoard _mineSweeperLeaderBoard;
  late final MyScoreBoard _myScoreBoard;
  late final MineSweeperQuickStartGuide _mineSweeperQuickStartGuide;

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingInitialData = true;
    });
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    MihBannerAdProvider bannerAdProvider = context.read<MihBannerAdProvider>();
    await MihDataHelperServices().loadUserDataOnly(
      mzansiProfileProvider,
    );
    bannerAdProvider.loadBannerAd();
    setState(() {
      _isLoadingInitialData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _mineSweeperGame = MineSweeperGame();
    _mineSweeperLeaderBoard = MihMineSweeperLeaderBoard();
    _myScoreBoard = MyScoreBoard();
    _mineSweeperQuickStartGuide = MineSweeperQuickStartGuide();
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MihMineSweeperProvider>(
      builder:
          (BuildContext context, MihMineSweeperProvider value, Widget? child) {
        if (_isLoadingInitialData) {
          return Scaffold(
            body: Center(
              child: Mihloadingcircle(),
            ),
          );
        }
        return MihPackage(
          appActionButton: getAction(),
          appTools: getTools(),
          appToolTitles: getToolTitle(),
          appBody: getToolBody(),
          selectedbodyIndex: context.watch<MihMineSweeperProvider>().toolIndex,
          onIndexChange: (newIndex) {
            context.read<MihMineSweeperProvider>().setToolIndex(newIndex);
          },
        );
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        MihMineSweeperProvider mineSweeperProvider =
            context.read<MihMineSweeperProvider>();
        mineSweeperProvider.setToolIndex(0);
        mineSweeperProvider.setDifficulty("Easy");
        context.goNamed(
          'mihHome',
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(FontAwesomeIcons.bomb)] = () {
      context.read<MihMineSweeperProvider>().setToolIndex(0);
    };
    temp[const Icon(Icons.leaderboard_rounded)] = () {
      context.read<MihMineSweeperProvider>().setToolIndex(1);
    };
    temp[const Icon(Icons.perm_identity_rounded)] = () {
      context.read<MihMineSweeperProvider>().setToolIndex(2);
    };
    temp[const Icon(Icons.rule_rounded)] = () {
      context.read<MihMineSweeperProvider>().setToolIndex(3);
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<MihMineSweeperProvider>().toolIndex,
    );
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Minesweeper",
      "Leader Board",
      "My Scores",
      "Guide",
    ];
    return toolTitles;
  }

  List<Widget> getToolBody() {
    return [
      _mineSweeperGame,
      _mineSweeperLeaderBoard,
      _myScoreBoard,
      _mineSweeperQuickStartGuide,
    ];
  }
}
