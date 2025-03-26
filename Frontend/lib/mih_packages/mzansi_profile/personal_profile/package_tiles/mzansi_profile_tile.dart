import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';

class MzansiProfileTile extends StatefulWidget {
  final AppUser signedInUser;
  final ImageProvider<Object>? propicFile;
  const MzansiProfileTile({
    super.key,
    required this.signedInUser,
    required this.propicFile,
  });

  @override
  State<MzansiProfileTile> createState() => _MzansiProfileTileState();
}

class _MzansiProfileTileState extends State<MzansiProfileTile> {
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
      appName: "Mzansi Profile",
      appIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          width: 225,
          child: Image(image: logo),
        ),
      ),
      iconSize: 200,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
