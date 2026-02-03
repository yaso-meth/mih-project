import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:provider/provider.dart';

class PatientProfileTile extends StatefulWidget {
  final double packageSize;

  const PatientProfileTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<PatientProfileTile> createState() => _PatientProfileTileState();
}

class _PatientProfileTileState extends State<PatientProfileTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      authenticateUser: true,
      onTap: () async {
        PatientManagerProvider patManProvider =
            context.read<PatientManagerProvider>();
        patManProvider.setPersonalMode(true);
        context.goNamed("patientProfile");
      },
      appName: "Patient Profile",
      appIcon: Icon(
        MihIcons.patientProfile,
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
