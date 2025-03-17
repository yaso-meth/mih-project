import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tools.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_profile/app_tools/patient_claim_or_statement.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_profile/app_tools/patient_consultation.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_profile/app_tools/patient_documents.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_profile/app_tools/patient_info.dart';
import 'package:flutter/material.dart';

class PatientProfile extends StatefulWidget {
  final PatientViewArguments arguments;
  const PatientProfile({
    super.key,
    required this.arguments,
  });

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  int _selcetedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MihApp(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      selectedbodyIndex: _selcetedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selcetedIndex = newValue;
        });
      },
    );
  }

  MihAppAction getAction() {
    return MihAppAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  MihAppTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.perm_identity)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    temp[const Icon(Icons.article_outlined)] = () {
      setState(() {
        _selcetedIndex = 1;
      });
    };
    temp[const Icon(Icons.file_present)] = () {
      setState(() {
        _selcetedIndex = 2;
      });
    };
    temp[const Icon(Icons.file_open_outlined)] = () {
      setState(() {
        _selcetedIndex = 3;
      });
    };
    return MihAppTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      PatientInfo(
        signedInUser: widget.arguments.signedInUser,
        selectedPatient: widget.arguments.selectedPatient!,
        type: widget.arguments.type,
      ),
      PatientConsultation(
        patientAppId: widget.arguments.selectedPatient!.app_id,
        selectedPatient: widget.arguments.selectedPatient!,
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        businessUser: widget.arguments.businessUser,
        type: widget.arguments.type,
      ),
      PatientDocuments(
        patientIndex: widget.arguments.selectedPatient!.idpatients,
        selectedPatient: widget.arguments.selectedPatient!,
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        businessUser: widget.arguments.businessUser,
        type: widget.arguments.type,
      ),
      PatientClaimOrStatement(
        patientIndex: widget.arguments.selectedPatient!.idpatients,
        selectedPatient: widget.arguments.selectedPatient!,
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        businessUser: widget.arguments.businessUser,
        type: widget.arguments.type,
      ),
    ];
    return toolBodies;
  }
}
