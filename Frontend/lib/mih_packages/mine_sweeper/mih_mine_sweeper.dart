import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mine_sweeper/package_tools/mine_sweeper_game.dart';
import 'package:provider/provider.dart';

class MihMineSweeper extends StatefulWidget {
  const MihMineSweeper({super.key});

  @override
  State<MihMineSweeper> createState() => _MihMineSweeperState();
}

class _MihMineSweeperState extends State<MihMineSweeper> {
  @override
  Widget build(BuildContext context) {
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
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        context.goNamed(
          'mihHome',
          extra: true,
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
    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<MihMineSweeperProvider>().toolIndex,
    );
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "MineSweeper",
    ];
    return toolTitles;
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      const MineSweeperGame(),
    ];
    return toolBodies;
  }
}
