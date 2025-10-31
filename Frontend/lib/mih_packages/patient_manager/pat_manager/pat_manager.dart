import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_manager/package_tools/mih_patient_search.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_manager/package_tools/my_patient_list.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_manager/package_tools/waiting_room.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_calendar_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';
import 'package:provider/provider.dart';

class PatManager extends StatefulWidget {
  const PatManager({
    super.key,
  });

  @override
  State<PatManager> createState() => _PatManagerState();
}

class _PatManagerState extends State<PatManager> {
  bool isLoading = true;

  Future<void> initialisePatientData() async {
    setState(() {
      isLoading = true;
    });
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    PatientManagerProvider patientManagerProvider =
        context.read<PatientManagerProvider>();
    MihCalendarProvider mihCalendarProvider =
        context.read<MihCalendarProvider>();
    patientManagerProvider.setPersonalMode(false);
    if (profileProvider.business != null) {
      await MihMzansiCalendarApis.getBusinessAppointments(
        profileProvider.business!.business_id,
        false,
        mihCalendarProvider.selectedDay,
        mihCalendarProvider,
      );
      await MihPatientServices().getPatientAccessListOfBusiness(
          patientManagerProvider, profileProvider.business!.business_id);
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
      appActionButton: getActionButton(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex:
          context.watch<PatientManagerProvider>().patientManagerIndex,
      onIndexChange: (newValue) {
        context.read<PatientManagerProvider>().setPatientManagerIndex(newValue);
      },
    );
  }

  MihPackageAction getActionButton() {
    PatientManagerProvider patientManagerProvider =
        context.read<PatientManagerProvider>();
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        patientManagerProvider.setPatientProfileIndex(0);
        patientManagerProvider.setPatientManagerIndex(0);
        context.goNamed(
          'mihHome',
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.calendar_month)] = () {
      context.read<PatientManagerProvider>().setPatientManagerIndex(0);
    };
    temp[const Icon(Icons.check_box_outlined)] = () {
      context.read<PatientManagerProvider>().setPatientManagerIndex(1);
    };

    temp[const Icon(Icons.search)] = () {
      context
          .read<PatientManagerProvider>()
          .setPatientSearchResults(patientSearchResults: []);
      context.read<PatientManagerProvider>().setPatientManagerIndex(2);
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex:
          context.watch<PatientManagerProvider>().patientManagerIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      WaitingRoom(),
      MyPatientList(),
      MihPatientSearch(),
    ];
    return toolBodies;
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Waiting Room",
      "My Patients",
      "Search Patients",
    ];
    return toolTitles;
  }
}
