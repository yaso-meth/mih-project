import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_claim_or_statement.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_consultation.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_documents.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientProfile extends StatefulWidget {
  const PatientProfile({
    super.key,
  });

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  late final PatientInfo _patientInfo;
  late final PatientConsultation _patienConsultation;
  late final PatientDocuments _patientDocuments;
  late final PatientClaimOrStatement _patientClaimOrStatement;

  Future<void> _loadInitialData() async {
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    PatientManagerProvider patientManagerProvider =
        context.read<PatientManagerProvider>();
    mzansiProfileProvider.loadCachedProfileState();
    if (mzansiProfileProvider.user == null) {
      await mzansiProfileProvider.syncWithMihServerData();
    }
    if (mzansiProfileProvider.personalHome) {
      patientManagerProvider
          .loadCachedPatientManager(mzansiProfileProvider.user!.app_id);
      if (patientManagerProvider.selectedPatient == null) {
        await patientManagerProvider.syncWithMihServerData(
            mzansiProfileProvider.user!.app_id, null);
      }
      if (patientManagerProvider.selectedPatient == null) {
        context.goNamed("patientProfileSetup");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _patientInfo = PatientInfo();
    _patienConsultation = PatientConsultation();
    _patientDocuments = PatientDocuments();
    _patientClaimOrStatement = PatientClaimOrStatement();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadInitialData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientManagerProvider>(
      builder: (BuildContext context,
          PatientManagerProvider patientManagerProvider, Widget? child) {
        if (patientManagerProvider.selectedPatient == null) {
          return Scaffold(
            body: Center(
              child: Mihloadingcircle(),
            ),
          );
        }
        return MihPackage(
          packageActionButton: getAction(),
          packageTools: getTools(),
          packageToolBodies: getToolBody(),
          packageToolTitles: getToolTitle(),
          selectedBodyIndex:
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
      iconColor: MihColors.secondary(),
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
      selectedIndex: patientManagerProvider.patientProfileIndex,
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
