import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';

class PatManagerTile extends StatefulWidget {
  final PatManagerArguments arguments;
  final double packageSize;
  const PatManagerTile({
    super.key,
    required this.arguments,
    required this.packageSize,
  });

  @override
  State<PatManagerTile> createState() => _PatManagerTileState();
}

class _PatManagerTileState extends State<PatManagerTile> {
  @override
  Widget build(BuildContext context) {
    return MihAppTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/patient-manager',
          arguments: widget.arguments,
        );
      },
      appName: "Patient Manager",
      appIcon: Container(
        padding: const EdgeInsets.all(0.5),
        child: Icon(
          Icons.medical_services,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        ),
      ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
