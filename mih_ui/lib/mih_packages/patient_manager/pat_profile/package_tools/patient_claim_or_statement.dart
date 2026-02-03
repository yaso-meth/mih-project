import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/components/claim_statement_window.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/list_builders/build_claim_statement_files_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientClaimOrStatement extends StatefulWidget {
  const PatientClaimOrStatement({
    super.key,
  });

  @override
  State<PatientClaimOrStatement> createState() =>
      _PatientClaimOrStatementState();
}

class _PatientClaimOrStatementState extends State<PatientClaimOrStatement> {
  void claimOrStatementWindow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ClaimStatementWindow(),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return Consumer2<MzansiProfileProvider, PatientManagerProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          PatientManagerProvider patientManagerProvider, Widget? child) {
        return Stack(
          children: [
            BuildClaimStatementFileList(),
            Visibility(
              visible: !patientManagerProvider.personalMode,
              child: Positioned(
                right: 10,
                bottom: 10,
                child: MihFloatingMenu(
                  icon: Icons.file_copy,
                  animatedIcon: AnimatedIcons.menu_close,
                  children: [
                    SpeedDialChild(
                      child: Icon(
                        Icons.add,
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                      label: "Generate Claim/ Statement",
                      labelBackgroundColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      labelStyle: TextStyle(
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      onTap: () {
                        claimOrStatementWindow();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
