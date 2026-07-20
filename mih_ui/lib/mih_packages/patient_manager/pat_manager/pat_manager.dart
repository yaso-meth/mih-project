import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_manager/package_tools/mih_patient_search.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_manager/package_tools/my_patient_list.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_manager/package_tools/waiting_room.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatManager extends StatefulWidget {
  const PatManager({
    super.key,
  });

  @override
  State<PatManager> createState() => _PatManagerState();
}

class _PatManagerState extends State<PatManager> {
  late final WaitingRoom _waitingRoom;
  late final MyPatientList _myPatientList;
  late final MihPatientSearch _mihPatientSearch;

  Future<void> _loadInitialData() async {
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    PatientManagerProvider patientManagerProvider =
        context.read<PatientManagerProvider>();
    MihCalendarProvider mihCalendarProvider =
        context.read<MihCalendarProvider>();
    mzansiProfileProvider.loadCachedProfileState();
    mihCalendarProvider.loadCachedCalendar();
    if (mzansiProfileProvider.user == null ||
        mzansiProfileProvider.business == null) {
      await mzansiProfileProvider.syncWithMihServerData();
    }
    patientManagerProvider.setPersonalMode(false);
    if (mihCalendarProvider.businessAppointments == null) {
      await mihCalendarProvider.syncWithMihServerData(mzansiProfileProvider);
    }
    if (patientManagerProvider.myPaitentList == null) {
      patientManagerProvider.syncWithMihServerData(
        null,
        mzansiProfileProvider.business!.business_id,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _waitingRoom = WaitingRoom();
    _myPatientList = MyPatientList();
    _mihPatientSearch = MihPatientSearch();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MzansiProfileProvider, PatientManagerProvider>(
      builder: (
        BuildContext context,
        MzansiProfileProvider profileProvider,
        PatientManagerProvider value,
        Widget? child,
      ) {
        if (profileProvider.business == null) {
          return Scaffold(
            body: Center(
              child: Mihloadingcircle(),
            ),
          );
        }
        return MihPackage(
          packageActionButton: getActionButton(),
          packageTools: getTools(),
          packageToolBodies: getToolBody(),
          packageToolTitles: getToolTitle(),
          selectedBodyIndex:
              context.watch<PatientManagerProvider>().patientManagerIndex,
          onIndexChange: (newValue) {
            context
                .read<PatientManagerProvider>()
                .setPatientManagerIndex(newValue);
          },
        );
      },
    );
  }

  MihPackageAction getActionButton() {
    PatientManagerProvider patientManagerProvider =
        context.read<PatientManagerProvider>();
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconColor: MihColors.secondary(),
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
      selectedIndex:
          context.watch<PatientManagerProvider>().patientManagerIndex,
    );
  }

  List<Widget> getToolBody() {
    return [
      _waitingRoom,
      _myPatientList,
      _mihPatientSearch,
    ];
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
