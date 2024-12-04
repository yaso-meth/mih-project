import 'dart:async';
import 'dart:convert';

import 'package:Mzansi_Innovation_Hub/mih_apis/mih_claim_statement_generation_api.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/claim_statement_file.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/Claim_Statement_Window.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/builder/build_claim_statement_files_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:supertokens_flutter/http.dart' as http;

import '../../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../../mih_env/env.dart';
import '../../mih_objects/app_user.dart';
import '../../mih_objects/business.dart';
import '../../mih_objects/business_user.dart';
import '../../mih_objects/files.dart';
import '../../mih_objects/patients.dart';
// import 'builder/build_files_list.dart';

class PatientClaimsOrStatements extends StatefulWidget {
  final int patientIndex;
  final Patient selectedPatient;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final String type;

  const PatientClaimsOrStatements({
    super.key,
    required this.patientIndex,
    required this.selectedPatient,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
    required this.type,
  });

  @override
  State<PatientClaimsOrStatements> createState() =>
      _PatientClaimsOrStatementsState();
}

class _PatientClaimsOrStatementsState extends State<PatientClaimsOrStatements> {
  String endpointFiles = "${AppEnviroment.baseApiUrl}/files/patients/";
  String endpointUser = "${AppEnviroment.baseApiUrl}/users/profile/";
  String endpointGenFiles =
      "${AppEnviroment.baseApiUrl}/files/generate/med-cert/";
  String endpointFileUpload = "${AppEnviroment.baseApiUrl}/files/upload/file/";
  String endpointInsertFiles = "${AppEnviroment.baseApiUrl}/files/insert/";

  final startDateController = TextEditingController();
  final endDateTextController = TextEditingController();
  final retDateTextController = TextEditingController();
  final selectedFileController = TextEditingController();
  final medicineController = TextEditingController();
  final quantityController = TextEditingController();
  final dosageController = TextEditingController();
  final timesDailyController = TextEditingController();
  final noDaysController = TextEditingController();
  final noRepeatsController = TextEditingController();
  final outputController = TextEditingController();

  late Future<List<ClaimStatementFile>> futueFiles;
  late String userEmail = "";
  late PlatformFile selected;
  final baseAPI = AppEnviroment.baseApiUrl;

  Future<List<PFile>> fetchFiles() async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/files/patients/${widget.selectedPatient.app_id}"));

    //print(response.statusCode);
    //print(response.body);
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<PFile> files =
          List<PFile>.from(l.map((model) => PFile.fromJson(model)));
      return files;
    } else {
      internetConnectionPopUp();
      throw Exception('failed to load patients');
    }
  }

  void successPopUp(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MIHSuccessMessage(
          successType: "Success",
          successMessage: message,
        );
      },
    );
  }

  void messagePopUp(error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(error),
        );
      },
    );
  }

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

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  bool isMedCertFieldsFilled() {
    if (startDateController.text.isEmpty ||
        endDateTextController.text.isEmpty ||
        retDateTextController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool isFileFieldsFilled() {
    if (selectedFileController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
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
        // IconButton(
        //   onPressed: () {
        //     uploudFilePopUp();
        //   },
        //   icon: Icon(
        //     Icons.add,
        //     color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        //   ),
        // )
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
  void dispose() {
    startDateController.dispose();
    endDateTextController.dispose();
    retDateTextController.dispose();
    selectedFileController.dispose();
    medicineController.dispose();
    quantityController.dispose();
    dosageController.dispose();
    timesDailyController.dispose();
    noDaysController.dispose();
    noRepeatsController.dispose();
    outputController.dispose();
    super.dispose();
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

    //patientDetails = getPatientDetails() as Patient;
    //getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
