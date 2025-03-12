import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tools.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_profile/business_profile/app_tools/mih_business_profile.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_profile/business_profile/app_tools/mih_business_user_search.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_profile/business_profile/app_tools/mih_my_business_team.dart';
import 'package:flutter/material.dart';

class MzansiBusinessProfile extends StatefulWidget {
  final BusinessArguments arguments;
  const MzansiBusinessProfile({
    super.key,
    required this.arguments,
  });

  @override
  State<MzansiBusinessProfile> createState() => _MzansiBusinessProfileState();
}

class _MzansiBusinessProfileState extends State<MzansiBusinessProfile> {
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
    temp[const Icon(Icons.business)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    temp[const Icon(Icons.people_outline)] = () {
      setState(() {
        _selcetedIndex = 1;
      });
    };
    temp[const Icon(Icons.add)] = () {
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
      MihBusinessProfile(arguments: widget.arguments),
      MihMyBusinessTeam(arguments: widget.arguments),
      MihBusinessUserSearch(arguments: widget.arguments),
    ];
    return toolBodies;
  }
}
