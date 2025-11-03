import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_claim_or_statement.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_consultation.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_documents.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_info.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_claim_statement_generation_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';
import 'package:provider/provider.dart';

class PatientProfile extends StatefulWidget {
  const PatientProfile({
    super.key,
  });

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  bool isLoading = true;

  Future<void> initialisePatientData() async {
    setState(() {
      isLoading = true;
    });
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    PatientManagerProvider patientManagerProvider =
        context.read<PatientManagerProvider>();
    String? app_id = profileProvider.user!.app_id;
    if (patientManagerProvider.selectedPatient == null) {
      await MihPatientServices()
          .getPatientDetails(app_id, patientManagerProvider);
    }
    if (patientManagerProvider.selectedPatient != null) {
      await MihPatientServices()
          .getPatientConsultationNotes(patientManagerProvider);
      await MihPatientServices().getPatientDocuments(patientManagerProvider);
      await MIHClaimStatementGenerationApi.getClaimStatementFilesByPatient(
          patientManagerProvider);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initialisePatientData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex:
          context.watch<PatientManagerProvider>().patientProfileIndex,
      onIndexChange: (newValue) {
        context.read<PatientManagerProvider>().setPatientProfileIndex(newValue);
      },
    );
  }

  MihPackageAction getAction() {
    PatientManagerProvider patientManagerProvider =
        context.read<PatientManagerProvider>();
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        patientManagerProvider.setPatientProfileIndex(0);
        if (!patientManagerProvider.personalMode) {
          context.pop();
        } else {
          context.goNamed(
            'mihHome',
          );
        }
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    PatientManagerProvider patientManagerProvider =
        context.read<PatientManagerProvider>();
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.perm_identity)] = () {
      patientManagerProvider.setPatientProfileIndex(0);
    };
    temp[const Icon(Icons.article_outlined)] = () {
      patientManagerProvider.setPatientProfileIndex(1);
    };
    temp[const Icon(Icons.file_present)] = () {
      patientManagerProvider.setPatientProfileIndex(2);
    };
    temp[const Icon(Icons.file_open_outlined)] = () {
      patientManagerProvider.setPatientProfileIndex(3);
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: patientManagerProvider.patientProfileIndex,
    );
  }

  List<Widget> getToolBody() {
    if (isLoading) {
      return [
        Center(
          child: Mihloadingcircle(),
        ),
      ];
    }
    PatientManagerProvider patientManagerProvider =
        context.read<PatientManagerProvider>();
    if (patientManagerProvider.selectedPatient == null) {
      return [
        const SizedBox(),
      ];
    }
    List<Widget> toolBodies = [
      PatientInfo(),
      PatientConsultation(),
      PatientDocuments(),
      PatientClaimOrStatement(),
    ];
    return toolBodies;
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Details",
      "Notes",
      "Documents",
      "Claims",
    ];
    return toolTitles;
  }
}
