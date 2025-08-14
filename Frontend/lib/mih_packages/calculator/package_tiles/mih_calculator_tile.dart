import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MihCalculatorTile extends StatefulWidget {
  final bool personalSelected;
  final double packageSize;

  const MihCalculatorTile({
    super.key,
    required this.personalSelected,
    required this.packageSize,
  });

  @override
  State<MihCalculatorTile> createState() => _MihCalculatorTileState();
}

class _MihCalculatorTileState extends State<MihCalculatorTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/calculator',
          arguments: widget.personalSelected,
        );
      },
      appName: "Calculator",
      appIcon: Icon(
        MihIcons.calculator,
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
