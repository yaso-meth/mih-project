import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MzansiAiTile extends StatefulWidget {
  final AppUser signedInUser;
  final double packageSize;

  const MzansiAiTile({
    super.key,
    required this.signedInUser,
    required this.packageSize,
  });

  @override
  State<MzansiAiTile> createState() => _MzansiAiTileState();
}

class _MzansiAiTileState extends State<MzansiAiTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        context.goNamed(
          'mzansiAi',
          extra: MzansiAiArguments(
            widget.signedInUser,
            "",
          ),
        );
        // Navigator.of(context).pushNamed(
        //   '/mzansi-ai',
        //   arguments: MzansiAiArguments(
        //     widget.signedInUser,
        //     "",
        //   ),
        // );
      },
      appName: "Mzansi AI",
      appIcon: Icon(
        MihIcons.mzansiAi,
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
