import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:flutter/material.dart';

class MihAccessTile extends StatefulWidget {
  final AppUser signedInUser;
  const MihAccessTile({
    super.key,
    required this.signedInUser,
  });

  @override
  State<MihAccessTile> createState() => _MihAccessTileState();
}

class _MihAccessTileState extends State<MihAccessTile> {
  @override
  Widget build(BuildContext context) {
    return MihAppTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mih-access',
          arguments: widget.signedInUser,
        );
      },
      appName: "MIH Access",
      appIcon: Padding(
        padding: const EdgeInsets.all(1),
        child: Icon(
          Icons.check_box,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        ),
      ),
      iconSize: 200,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
