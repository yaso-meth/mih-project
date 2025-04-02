import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih_app.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih_app_action.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih_app_tools.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/about_mih/package_tools/mih_info.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/about_mih/package_tools/mih_privacy_policy.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/about_mih/package_tools/mih_terms_of_service.dart';
import 'package:flutter/material.dart';

class AboutMih extends StatefulWidget {
  final int packageIndex;
  const AboutMih({
    super.key,
    required this.packageIndex,
  });

  @override
  State<AboutMih> createState() => _AboutMihState();
}

class _AboutMihState extends State<AboutMih> {
  late int _selcetedIndex;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selcetedIndex = widget.packageIndex;
    });
  }

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
    temp[const Icon(Icons.info)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    temp[const Icon(Icons.policy)] = () {
      setState(() {
        _selcetedIndex = 1;
      });
    };
    temp[const Icon(Icons.design_services)] = () {
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
      const MihInfo(),
      const MihPrivacyPolicy(),
      const MIHTermsOfService(),
    ];
    return toolBodies;
  }
}
