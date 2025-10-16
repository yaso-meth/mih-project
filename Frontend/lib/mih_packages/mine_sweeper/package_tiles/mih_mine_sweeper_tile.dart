import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MihMineSweeperTile extends StatefulWidget {
  final bool personalSelected;
  final double packageSize;
  const MihMineSweeperTile({
    super.key,
    required this.personalSelected,
    required this.packageSize,
  });

  @override
  State<MihMineSweeperTile> createState() => _MihMineSweeperTileState();
}

class _MihMineSweeperTileState extends State<MihMineSweeperTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        context.goNamed(
          "mihMineSweeper",
        );
      },
      appName: "MineSweeper",
      appIcon: Icon(
        MihIcons.mineSweeper,
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      secondaryColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
  }
}
