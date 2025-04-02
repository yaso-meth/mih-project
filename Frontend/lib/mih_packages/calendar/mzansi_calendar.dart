import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih_app.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih_app_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih_app_tools.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/calendar/package_tools/appointments.dart';
import 'package:flutter/material.dart';

class MzansiCalendar extends StatefulWidget {
  final CalendarArguments arguments;
  const MzansiCalendar({
    super.key,
    required this.arguments,
  });

  @override
  State<MzansiCalendar> createState() => _MzansiCalendarState();
}

class _MzansiCalendarState extends State<MzansiCalendar> {
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
        print("Index: $_selcetedIndex");
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
    temp[const Icon(Icons.calendar_month)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };

    return MihAppTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      //appointment here
      Appointments(
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        businessUser: widget.arguments.businessUser,
        personalSelected: widget.arguments.personalSelected,
      ),
    ];
    return toolBodies;
  }
}
