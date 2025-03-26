import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_apis/mih_claim_statement_generation_api.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/claim_statement_file.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/patients.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_profile/components/Claim_Statement_Window.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_profile/list_builders/build_claim_statement_files_list.dart';
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

  void claimOrStatementWindow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ClaimStatementWindow(
        selectedPatient: widget.selectedPatient,
        signedInUser: widget.signedInUser,
        business: widget.business,
        businessUser: widget.businessUser,
      ),
    );
  }

  List<Widget> setIcons() {
    if (widget.type == "personal") {
      return [
        Text(
          "Claims/ Statements",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
      ];
    } else {
      return [
        Text(
          "Claims/ Statements",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
        IconButton(
          onPressed: () {
            // new window to input fields for claim/ statements
            claimOrStatementWindow();
          },
          icon: Icon(
            Icons.add,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        )
      ];
    }
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return FutureBuilder(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: setIcons(),
              ),
              Divider(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor()),
              const SizedBox(height: 10),
              //const Placeholder(),
              BuildClaimStatementFileList(
                files: filesList,
                signedInUser: widget.signedInUser,
                selectedPatient: widget.selectedPatient,
                business: widget.business,
                businessUser: widget.businessUser,
                type: widget.type,
              ),
            ],
          );
        } else {
          return const Center(
            child: Text("Error Loading Notes"),
          );
        }
      },
    );
  }
}
