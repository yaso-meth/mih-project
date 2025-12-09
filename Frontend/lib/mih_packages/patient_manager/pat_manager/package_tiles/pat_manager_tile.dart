import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

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
      authenticateUser: true,
      onTap: () {
        context.goNamed(
          'patientManager',
        );
        // Navigator.of(context).pushNamed(
        //   '/patient-manager',
        //   arguments: widget.arguments,
        // );
      },
      appName: "Patient Manager",
      appIcon: Icon(
        MihIcons.patientManager,
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
  }
}
