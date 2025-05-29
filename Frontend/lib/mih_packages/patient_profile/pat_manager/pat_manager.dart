import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_manager/package_tools/mih_patient_search.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_manager/package_tools/my_patient_list.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_manager/package_tools/waiting_room.dart';
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

  void updateIndex(int index) {
    setState(() {
      _selcetedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getActionButton(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex: _selcetedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selcetedIndex = newValue;
        });
      },
    );
  }

  MihPackageAction getActionButton() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
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
    return MihPackageTools(
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
        businessUser: widget.arguments.businessUser,
        personalSelected: widget.arguments.personalSelected,
        onIndexChange: updateIndex,
      ),
      MyPatientList(
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        businessUser: widget.arguments.businessUser,
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

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Waiting Room",
      "Patients",
      "Search Patients",
    ];
    return toolTitles;
  }
}
