import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
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
    return MihAppTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/business-profile/set-up',
          arguments: widget.signedInUser,
        );
      },
      appName: "Setup Business",
      appIcon: Container(
        padding: const EdgeInsets.all(0.5),
        child: Icon(
          Icons.business_center,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        ),
      ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
