import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:flutter/material.dart';

class MzansiSetupBusinessProfileTile extends StatefulWidget {
  final AppUser signedInUser;
  final double packageSize;
  const MzansiSetupBusinessProfileTile({
    super.key,
    required this.signedInUser,
    required this.packageSize,
  });

  @override
  State<MzansiSetupBusinessProfileTile> createState() =>
      _MzansiSetupBusinessProfileTileState();
}

class _MzansiSetupBusinessProfileTileState
    extends State<MzansiSetupBusinessProfileTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/business-profile/set-up',
          arguments: widget.signedInUser,
        );
      },
      appName: "Setup Business",
      appIcon: Icon(
        MihIcons.profileSetup,
        color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
      ),
      iconSize: widget.packageSize,
      primaryColor: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
