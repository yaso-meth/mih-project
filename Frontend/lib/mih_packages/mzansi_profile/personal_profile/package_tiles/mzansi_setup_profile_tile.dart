import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
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
      appIcon: Icon(
        MihIcons.profileSetup,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
