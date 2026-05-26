import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
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
      packageName: "Patient Manager",
      packageIcon: Icon(
        MihIcons.patientManager,
        color: MihColors.secondary(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
