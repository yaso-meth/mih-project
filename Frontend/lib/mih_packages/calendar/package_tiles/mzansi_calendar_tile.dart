import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';

class MzansiCalendarTile extends StatefulWidget {
  final CalendarArguments arguments;
  const MzansiCalendarTile({
    super.key,
    required this.arguments,
  });

  @override
  State<MzansiCalendarTile> createState() => _MzansiCalendarTileState();
}

class _MzansiCalendarTileState extends State<MzansiCalendarTile> {
  @override
  Widget build(BuildContext context) {
    return MihAppTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/calendar',
          arguments: widget.arguments,
        );
      },
      appName: "Calendar",
      appIcon: Padding(
        padding: const EdgeInsets.all(1),
        child: Icon(
          Icons.calendar_month,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        ),
      ),
      iconSize: 200,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
