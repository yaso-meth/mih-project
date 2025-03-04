import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tools.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_manager/app_tools/mih_patient_search.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_manager/app_tools/my_patient_list.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/pat_manager/app_tools/waiting_room.dart';
import 'package:flutter/material.dart';

class PatManager extends StatefulWidget {
  final PatManagerArguments arguments;
  const PatManager({
    super.key,
    required this.arguments,
  });

  @override
  State<PatManager> createState() => _PatManagerState();
}

class _PatManagerState extends State<PatManager> {
  int _selcetedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MihApp(
      appActionButton: getActionButton(),
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

  MihAppAction getActionButton() {
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

    temp[const Icon(Icons.check_box_outlined)] = () {
      setState(() {
        _selcetedIndex = 1;
      });
    };

    temp[const Icon(Icons.search)] = () {
      setState(() {
        _selcetedIndex = 2;
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
      // Appointments(
      //   signedInUser: widget.arguments.signedInUser,
      //   business: widget.arguments.business,
      //   personalSelected: widget.arguments.personalSelected,
      // ),
      WaitingRoom(
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        personalSelected: widget.arguments.personalSelected,
      ),
      MyPatientList(
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        personalSelected: widget.arguments.personalSelected,
      ),
      MihPatientSearch(
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        personalSelected: widget.arguments.personalSelected,
        businessUser: widget.arguments.businessUser,
      ),
    ];
    return toolBodies;
  }
}
