import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:flutter/material.dart';

class MihAccessTile extends StatefulWidget {
  final AppUser signedInUser;
  final double packageSize;

  const MihAccessTile({
    super.key,
    required this.signedInUser,
    required this.packageSize,
  });

  @override
  State<MihAccessTile> createState() => _MihAccessTileState();
}

class _MihAccessTileState extends State<MihAccessTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mih-access',
          arguments: widget.signedInUser,
        );
      },
      appName: "Access Controls",
      appIcon: Icon(
        MihIcons.accessControl,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
