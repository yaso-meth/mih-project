import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MzansiDirectoryTile extends StatefulWidget {
  final double packageSize;
  const MzansiDirectoryTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MzansiDirectoryTile> createState() => _MzansiDirectoryTileState();
}

class _MzansiDirectoryTileState extends State<MzansiDirectoryTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mzansi-directory',
          arguments: MzansiDirectoryArguments(
            personalSearch: true,
            startSearchText: null,
          ),
        );
      },
      appName: "Mzansi Directory",
      appIcon: Icon(
        MihIcons.mzansiDirectory,
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
