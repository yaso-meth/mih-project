import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_claim_statement_generation_api.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/claim_statement_file.dart';
import 'package:mzansi_innovation_hub/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/components/claim_statement_window2.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/list_builders/build_claim_statement_files_list.dart';
import 'package:flutter/material.dart';

class PatientClaimOrStatement extends StatefulWidget {
  final int patientIndex;
  final Patient selectedPatient;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final String type;
  const PatientClaimOrStatement({
    super.key,
    required this.patientIndex,
    required this.selectedPatient,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
    required this.type,
  });

  @override
  State<PatientClaimOrStatement> createState() =>
      _PatientClaimOrStatementState();
}

class _PatientClaimOrStatementState extends State<PatientClaimOrStatement> {
  late Future<List<ClaimStatementFile>> futueFiles;
  late String env;

  void claimOrStatementWindow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ClaimStatementWindow(
        selectedPatient: widget.selectedPatient,
        signedInUser: widget.signedInUser,
        business: widget.business,
        businessUser: widget.businessUser,
        env: env,
      ),
    );
  }

  @override
  void initState() {
    if (widget.business == null) {
      futueFiles =
          MIHClaimStatementGenerationApi.getClaimStatementFilesByPatient(
              widget.signedInUser.app_id);
    } else {
      futueFiles =
          MIHClaimStatementGenerationApi.getClaimStatementFilesByBusiness(
              widget.business!.business_id);
    }
    if (AppEnviroment.getEnv() == "Prod") {
      env = "Prod";
    } else {
      env = "Dev";
    }
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
    return Stack(
      children: [
        FutureBuilder(
          future: futueFiles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Mihloadingcircle(),
              );
            } else if (snapshot.hasData) {
              final filesList = snapshot.data!;
              return Column(
                children: [
                  //const Placeholder(),
                  BuildClaimStatementFileList(
                    files: filesList,
                    signedInUser: widget.signedInUser,
                    selectedPatient: widget.selectedPatient,
                    business: widget.business,
                    businessUser: widget.businessUser,
                    type: widget.type,
                    env: env,
                  ),
                ],
              );
            } else {
              return const Center(
                child: Text("Error Loading Notes"),
              );
            }
          },
        ),
        Visibility(
          visible: widget.type != "personal",
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
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                  label: "Generate Claim/ Statement",
                  labelBackgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
                  labelStyle: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
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
  }
}
