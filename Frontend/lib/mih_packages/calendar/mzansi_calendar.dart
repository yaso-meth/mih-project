import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/package_tools/appointments.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MzansiCalendar extends StatefulWidget {
  const MzansiCalendar({
    super.key,
  });

  @override
  State<MzansiCalendar> createState() => _MzansiCalendarState();
}

class _MzansiCalendarState extends State<MzansiCalendar> {
  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex: context.watch<MihCalendarProvider>().toolIndex,
      onIndexChange: (newIndex) {
        context.read<MihCalendarProvider>().setToolIndex(newIndex);
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        // Navigator.of(context).pop();
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
    List<Widget> toolBodies = [
      //appointment here
      Appointments(),
    ];
    return toolBodies;
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
