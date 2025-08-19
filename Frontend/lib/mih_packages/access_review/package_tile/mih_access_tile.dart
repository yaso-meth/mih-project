import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

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
        context.goNamed(
          "mihAccess",
          extra: widget.signedInUser,
        );
        // Navigator.of(context).pushNamed(
        //   '/mih-access',
        //   arguments: widget.signedInUser,
        // );
      },
      appName: "Access Controls",
      appIcon: Icon(
        MihIcons.accessControl,
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      secondaryColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
  }
}
