import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PatientProfileTile extends StatefulWidget {
  final PatientViewArguments arguments;
  const PatientProfileTile({
    super.key,
    required this.arguments,
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
      appIcon: FaIcon(
        FontAwesomeIcons.circleInfo,
        color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        size: 200,
      ),
      iconSize: 200,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
