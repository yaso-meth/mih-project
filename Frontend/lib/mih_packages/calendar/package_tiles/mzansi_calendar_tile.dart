import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MzansiCalendarTile extends StatefulWidget {
  final double packageSize;

  const MzansiCalendarTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MzansiCalendarTile> createState() => _MzansiCalendarTileState();
}

class _MzansiCalendarTileState extends State<MzansiCalendarTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        context.goNamed(
          "mihCalendar",
        );
        // Navigator.of(context).pushNamed(
        //   '/calendar',
        //   arguments: widget.arguments,
        // );
      },
      appName: "Calendar",
      appIcon: Icon(
        MihIcons.calendar,
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
