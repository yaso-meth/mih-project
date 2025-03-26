import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
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
    ImageProvider aiLogo = MzanziInnovationHub.of(context)!.theme.aiLogoImage();
    return MihAppTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mzansi-ai',
          arguments: widget.signedInUser,
        );
      },
      appName: "Mzansi AI",
      appIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          width: widget.packageSize,
          child: Image(image: aiLogo),
        ),
      ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
