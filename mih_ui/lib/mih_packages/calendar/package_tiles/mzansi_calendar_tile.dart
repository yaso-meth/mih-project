import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:flutter/material.dart';

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
        context.pushNamed(
          "mihCalendar",
        );
        // Navigator.of(context).pushNamed(
        //   '/calendar',
        //   arguments: widget.arguments,
        // );
      },
      packageName: "Calendar",
      packageIcon: Icon(
        MihIcons.calendar,
        color: MihColors.secondary(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
