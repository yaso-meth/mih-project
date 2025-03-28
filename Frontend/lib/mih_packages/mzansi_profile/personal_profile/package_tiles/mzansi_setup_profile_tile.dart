import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';

class MzansiSetupProfileTile extends StatefulWidget {
  final AppUser signedInUser;
  final ImageProvider<Object>? propicFile;
  final double packageSize;

  const MzansiSetupProfileTile({
    super.key,
    required this.signedInUser,
    required this.propicFile,
    required this.packageSize,
  });

  @override
  State<MzansiSetupProfileTile> createState() => _MzansiSetupProfileTileState();
}

class _MzansiSetupProfileTileState extends State<MzansiSetupProfileTile> {
  @override
  Widget build(BuildContext context) {
    ImageProvider logo = MzanziInnovationHub.of(context)!.theme.logoImage();
    return MihAppTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mzansi-profile',
          arguments: AppProfileUpdateArguments(
            widget.signedInUser,
            widget.propicFile,
          ),
        );
      },
      appName: "Setup Profile",
      appIcon: Container(
        padding: const EdgeInsets.all(25),
        child: Image(image: logo),
      ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
