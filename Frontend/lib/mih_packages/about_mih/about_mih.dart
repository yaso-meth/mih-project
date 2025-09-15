import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/package_tools/mih_%20attributes.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/package_tools/mih_info.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/package_tools/mih_privacy_policy.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/package_tools/mih_terms_of_service.dart';
import 'package:flutter/material.dart';

class AboutMih extends StatefulWidget {
  final AboutArguments? arguments;
  const AboutMih({
    super.key,
    this.arguments,
  });

  @override
  State<AboutMih> createState() => _AboutMihState();
}

class _AboutMihState extends State<AboutMih> {
  late int _selcetedIndex;
  late bool _personalSelected;

  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.arguments == null) {
        _selcetedIndex = 0;
        _personalSelected = true;
      } else {
        _selcetedIndex = widget.arguments!.packageIndex!;
        _personalSelected = widget.arguments!.personalSelected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex: _selcetedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selcetedIndex = newValue;
        });
        // print("Index: $_selcetedIndex");
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        context.goNamed(
          'mihHome',
          extra: _personalSelected,
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
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
    temp[const Icon(Icons.star_rounded)] = () {
      setState(() {
        _selcetedIndex = 3;
      });
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      const MihInfo(),
      const MihPrivacyPolicy(),
      const MIHTermsOfService(),
      const MihAttributes(),
    ];
    return toolBodies;
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "About",
      "Privacy Policy",
      "Terms of Service",
      "Attributions",
    ];
    return toolTitles;
  }
}
