import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/package_tools/appointments.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_data_helper_services.dart';
import 'package:provider/provider.dart';

class MzansiCalendar extends StatefulWidget {
  const MzansiCalendar({
    super.key,
  });

  @override
  State<MzansiCalendar> createState() => _MzansiCalendarState();
}

class _MzansiCalendarState extends State<MzansiCalendar> {
  bool _isLoadingInitialData = true;
  late final Appointments _appointments;

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingInitialData = true;
    });
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    if (mzansiProfileProvider.user == null) {
      await MihDataHelperServices().loadUserDataOnly(
        mzansiProfileProvider,
      );
    }
    setState(() {
      _isLoadingInitialData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _appointments = Appointments();
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MihCalendarProvider>(
      builder: (BuildContext context, MihCalendarProvider calendarProvider,
          Widget? child) {
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
          selectedbodyIndex: calendarProvider.toolIndex,
          onIndexChange: (newIndex) {
            calendarProvider.setToolIndex(newIndex);
          },
        );
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        context.read<MihCalendarProvider>().resetSelectedDay();
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
      context.read<MihCalendarProvider>().setToolIndex(0);
    };

    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<MihCalendarProvider>().toolIndex,
    );
  }

  List<Widget> getToolBody() {
    return [
      _appointments,
    ];
  }

  List<String> getToolTitle() {
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    List<String> toolTitles = [
      mzansiProfileProvider.personalHome == true ? "Personal" : "Business",
    ];
    return toolTitles;
  }
}
