import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tools.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/mzansi_profile/personal_profile/app_tools/mih_personal_profile.dart';
import 'package:flutter/material.dart';

class MzansiProfile extends StatefulWidget {
  final AppProfileUpdateArguments arguments;
  const MzansiProfile({
    super.key,
    required this.arguments,
  });

  @override
  State<MzansiProfile> createState() => _MzansiProfileState();
}

class _MzansiProfileState extends State<MzansiProfile> {
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
    temp[const Icon(Icons.perm_identity)] = () {
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
      MihPersonalProfile(
        arguments: widget.arguments,
      ),
    ];
    return toolBodies;
  }
}
