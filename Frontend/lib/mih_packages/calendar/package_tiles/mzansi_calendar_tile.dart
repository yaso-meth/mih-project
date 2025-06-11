import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:flutter/material.dart';

class MzansiCalendarTile extends StatefulWidget {
  final CalendarArguments arguments;
  final double packageSize;

  const MzansiCalendarTile({
    super.key,
    required this.arguments,
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
        Navigator.of(context).pushNamed(
          '/calendar',
          arguments: widget.arguments,
        );
      },
      appName: "Calendar",
      appIcon: Icon(
        MihIcons.calendar,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
