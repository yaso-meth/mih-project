import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:flutter/material.dart';

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
    return MihAppTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mzansi-ai',
          arguments: widget.signedInUser,
        );
      },
      appName: "Mzansi AI",
      appIcon: Icon(
        MihIcons.mzansiAi,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
