import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class AboutMihTile extends StatefulWidget {
  final double packageSize;
  final bool personalSelected;
  const AboutMihTile({
    super.key,
    required this.packageSize,
    required this.personalSelected,
  });

  @override
  State<AboutMihTile> createState() => _AboutMihTileState();
}

class _AboutMihTileState extends State<AboutMihTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        context.goNamed(
          "aboutMih",
          extra: AboutArguments(
            widget.personalSelected,
            0,
          ),
        );
        // Navigator.of(context).pushNamed(
        //   '/about',
        //   arguments: 0,
        // );
      },
      appName: "About MIH",
      appIcon: Icon(
        MihIcons.aboutMih,
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
