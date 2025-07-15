import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
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
    return MihPackageTile(
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
        color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
