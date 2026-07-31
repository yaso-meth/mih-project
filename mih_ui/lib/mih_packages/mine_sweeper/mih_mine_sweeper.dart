import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/package_tools/mih_mine_sweeper_leader_board.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/package_tools/mine_sweeper_game.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/package_tools/mine_sweeper_quick_start_guide.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/package_tools/my_score_board.dart';
import 'package:provider/provider.dart';

class MihMineSweeper extends StatefulWidget {
  const MihMineSweeper({super.key});

  @override
  State<MihMineSweeper> createState() => _MihMineSweeperState();
}

class _MihMineSweeperState extends State<MihMineSweeper> {
  late final MineSweeperGame _mineSweeperGame;
  late final MihMineSweeperLeaderBoard _mineSweeperLeaderBoard;
  late final MyScoreBoard _myScoreBoard;
  late final MineSweeperQuickStartGuide _mineSweeperQuickStartGuide;

  Future<void> _loadInitialData() async {
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    MihMineSweeperProvider mineSweeperProvider =
        context.read<MihMineSweeperProvider>();
    mzansiProfileProvider.loadCachedProfileState();
    mineSweeperProvider.loadCachedMSleaderboards();
    if (mzansiProfileProvider.user == null) {
      await mzansiProfileProvider.syncWithMihServerData();
    }
    if (mineSweeperProvider.leaderboard == null ||
        mineSweeperProvider.leaderboard!.isEmpty ||
        mineSweeperProvider.myScoreboard == null ||
        mineSweeperProvider.myScoreboard!.isEmpty) {
      await mineSweeperProvider.syncWithMihServerData(
          mzansiProfileProvider, mineSweeperProvider);
    } else {
      mineSweeperProvider.syncWithMihServerData(
          mzansiProfileProvider, mineSweeperProvider);
    }
  }

  @override
  void initState() {
    super.initState();
    _mineSweeperGame = MineSweeperGame();
    _mineSweeperLeaderBoard = MihMineSweeperLeaderBoard();
    _myScoreBoard = MyScoreBoard();
    _mineSweeperQuickStartGuide = MineSweeperQuickStartGuide();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadInitialData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MzansiProfileProvider, MihMineSweeperProvider>(
      builder: (
        BuildContext context,
        MzansiProfileProvider profileProvider,
        MihMineSweeperProvider mineSweeperProvider,
        Widget? child,
      ) {
        if (profileProvider.user == null) {
          return Scaffold(
            body: Center(
              child: Mihloadingcircle(),
            ),
          );
        }
        return MihPackage(
          packageActionButton: getAction(),
          packageTools: getTools(),
          packageToolTitles: getToolTitle(),
          packageToolBodies: getToolBody(),
          selectedBodyIndex: context.watch<MihMineSweeperProvider>().toolIndex,
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
      iconColor: MihColors.secondary(),
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
    temp[const Icon(MihIcons.minesweeper)] = () {
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
      selectedIndex: context.watch<MihMineSweeperProvider>().toolIndex,
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
