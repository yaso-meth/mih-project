import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_claim_or_statement.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_consultation.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_documents.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_info.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_claim_statement_generation_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_data_helper_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:provider/provider.dart';

class PatientProfile extends StatefulWidget {
  const PatientProfile({
    super.key,
  });

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  bool _isLoadingInitialData = true;
  late final PatientInfo _patientInfo;
  late final PatientConsultation _patienConsultation;
  late final PatientDocuments _patientDocuments;
  late final PatientClaimOrStatement _patientClaimOrStatement;

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingInitialData = true;
    });
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    PatientManagerProvider patientManagerProvider =
        context.read<PatientManagerProvider>();
    await MihDataHelperServices().loadUserDataOnly(
      mzansiProfileProvider,
    );
    if (patientManagerProvider.selectedPatient == null) {
      await MihPatientServices().getPatientDetails(
          mzansiProfileProvider.user!.app_id, patientManagerProvider);
    }
    if (patientManagerProvider.selectedPatient == null) {
      context.goNamed("patientProfileSetup");
      return;
    }
    if (patientManagerProvider.personalMode) {
      patientManagerProvider.setSelectedPatientProfilePicUrl(
          mzansiProfileProvider.userProfilePicUrl!);
    } else {
      AppUser? patientUserDetails = await MihUserServices().getMIHUserDetails(
          patientManagerProvider.selectedPatient!.app_id, context);
      String patientProPicUrl =
          await MihFileApi.getMinioFileUrl(patientUserDetails!.pro_pic_path);
      patientManagerProvider.setSelectedPatientProfilePicUrl(patientProPicUrl);
    }
    patientManagerProvider.setPersonalMode(mzansiProfileProvider.personalHome);
    if (patientManagerProvider.selectedPatient != null) {
      await MihPatientServices()
          .getPatientConsultationNotes(patientManagerProvider);
      await MihPatientServices().getPatientDocuments(patientManagerProvider);
      await MIHClaimStatementGenerationApi.getClaimStatementFilesByPatient(
          patientManagerProvider);
    }
    setState(() {
      _isLoadingInitialData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _patientInfo = PatientInfo();
    _patienConsultation = PatientConsultation();
    _patientDocuments = PatientDocuments();
    _patientClaimOrStatement = PatientClaimOrStatement();
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientManagerProvider>(
      builder: (BuildContext context,
          PatientManagerProvider patientManagerProvider, Widget? child) {
        if (_isLoadingInitialData) {
          return Scaffold(
            body: Center(
              child: Mihloadingcircle(),
            ),
          );
        }
        return MihPackage(
          appActionButton: getAction(),
          appTools: getTools(),
          appBody: getToolBody(),
          appToolTitles: getToolTitle(),
          selectedbodyIndex:
              context.watch<PatientManagerProvider>().patientProfileIndex,
          onIndexChange: (newValue) {
            context
                .read<PatientManagerProvider>()
                .setPatientProfileIndex(newValue);
          },
        );
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
        if (!patientManagerProvider.personalMode) {
          context.pop();
        } else {
          context.goNamed(
            'mihHome',
          );
        }
        patientManagerProvider.setPatientProfileIndex(0);
        patientManagerProvider.setHidePatientDetails(true);
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
    return [
      _patientInfo,
      _patienConsultation,
      _patientDocuments,
      _patientClaimOrStatement,
    ];
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
