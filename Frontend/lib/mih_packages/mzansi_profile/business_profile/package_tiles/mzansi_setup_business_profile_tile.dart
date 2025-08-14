import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

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
      appName: "Set Up Business",
      appIcon: Icon(
        MihIcons.businessSetup,
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      ),
      iconSize: widget.packageSize,
      primaryColor: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      secondaryColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
  }
}
