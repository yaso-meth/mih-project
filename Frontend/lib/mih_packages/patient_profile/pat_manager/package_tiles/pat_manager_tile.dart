import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
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
    return MihPackageTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/patient-manager',
          arguments: widget.arguments,
        );
      },
      appName: "Patient Manager",
      appIcon: Icon(
        MihIcons.patientManager,
        color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
