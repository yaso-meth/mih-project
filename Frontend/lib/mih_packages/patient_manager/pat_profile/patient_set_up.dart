import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/package_tools/patient_setup_form.dart';
import 'package:provider/provider.dart';

class PatientSetUp extends StatefulWidget {
  const PatientSetUp({super.key});

  @override
  State<PatientSetUp> createState() => _PatientSetUpState();
}

class _PatientSetUpState extends State<PatientSetUp> {
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
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
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
      selcetedIndex: patientManagerProvider.patientProfileIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      PatientSetupForm(),
    ];
    return toolBodies;
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Set Up Patient Profile",
    ];
    return toolTitles;
  }
}
