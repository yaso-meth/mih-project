import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';

class MzansiProfileTile extends StatefulWidget {
  final AppUser signedInUser;
  final ImageProvider<Object>? propicFile;
  final double packageSize;

  const MzansiProfileTile({
    super.key,
    required this.signedInUser,
    required this.propicFile,
    required this.packageSize,
  });

  @override
  State<MzansiProfileTile> createState() => _MzansiProfileTileState();
}

class _MzansiProfileTileState extends State<MzansiProfileTile> {
  @override
  Widget build(BuildContext context) {
    // ImageProvider logo = MzanziInnovationHub.of(context)!.theme.logoImage();
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
      appIcon: Icon(
        MihIcons.mihLogo,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
