import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';

class MzansiBusinessProfileTile extends StatefulWidget {
  final BusinessArguments arguments;
  final double packageSize;
  const MzansiBusinessProfileTile({
    super.key,
    required this.arguments,
    required this.packageSize,
  });

  @override
  State<MzansiBusinessProfileTile> createState() =>
      _MzansiBusinessProfileTileState();
}

class _MzansiBusinessProfileTileState extends State<MzansiBusinessProfileTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/business-profile/manage',
          arguments: widget.arguments,
        );
      },
      appName: "Business Profile",
      appIcon: Icon(
        MihIcons.businessProfile,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
