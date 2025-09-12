import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

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
        context.goNamed(
          "businessProfileManage",
          extra: widget.arguments,
        );
        // Navigator.of(context).pushNamed(
        //   '/business-profile/manage',
        //   arguments: widget.arguments,
        // );
      },
      appName: "Business Profile",
      appIcon: Icon(
        MihIcons.businessProfile,
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
