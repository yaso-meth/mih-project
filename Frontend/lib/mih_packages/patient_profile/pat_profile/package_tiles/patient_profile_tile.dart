import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';

class PatientProfileTile extends StatefulWidget {
  final PatientViewArguments arguments;
  final double packageSize;

  const PatientProfileTile({
    super.key,
    required this.arguments,
    required this.packageSize,
  });

  @override
  State<PatientProfileTile> createState() => _PatientProfileTileState();
}

class _PatientProfileTileState extends State<PatientProfileTile> {
  @override
  Widget build(BuildContext context) {
    return MihAppTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/patient-profile',
          arguments: widget.arguments,
        );
      },
      appName: "Patient Profile",
      appIcon: Container(
          padding: const EdgeInsets.all(15),
          child: Icon(
            Icons.medical_information_outlined,
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            size: widget.packageSize,
          )),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
