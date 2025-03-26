import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
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
    return MihAppTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/business-profile/manage',
          arguments: widget.arguments,
        );
      },
      appName: "Business Profile",
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
