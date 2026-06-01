import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_setup_form.dart';
import 'package:provider/provider.dart';

class PatientSetUp extends StatefulWidget {
  const PatientSetUp({super.key});

  @override
  State<PatientSetUp> createState() => _PatientSetUpState();
}

class _PatientSetUpState extends State<PatientSetUp> {
  late final PatientSetupForm _patientSetupForm;

  @override
  void initState() {
    super.initState();
    _patientSetupForm = PatientSetupForm();
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      packageActionButton: getAction(),
      packageTools: getTools(),
      packageToolBodies: getToolBody(),
      packageToolTitles: getToolTitle(),
      selectedBodyIndex:
          context.watch<PatientManagerProvider>().patientProfileIndex,
      onIndexChange: (newValue) {
        context.read<PatientManagerProvider>().setPatientProfileIndex(newValue);
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconColor: MihColors.secondary(),
      iconSize: 35,
      onTap: () {
        context.goNamed(
          'mihHome',
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    PatientManagerProvider patientManagerProvider =
        context.read<PatientManagerProvider>();
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.medical_services)] = () {
      patientManagerProvider.setPatientProfileIndex(0);
    };
    return MihPackageTools(
      tools: temp,
      selectedIndex: patientManagerProvider.patientProfileIndex,
    );
  }

  List<Widget> getToolBody() {
    return [
      _patientSetupForm,
    ];
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Set Up Patient Profile",
    ];
    return toolTitles;
  }
}
