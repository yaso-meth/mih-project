import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/about_mih_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/package_tools/mih_%20attributes.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/package_tools/mih_info.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/package_tools/mih_privacy_policy.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/package_tools/mih_terms_of_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutMih extends StatefulWidget {
  const AboutMih({
    super.key,
  });

  @override
  State<AboutMih> createState() => _AboutMihState();
}

class _AboutMihState extends State<AboutMih> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex: context.watch<AboutMihProvider>().toolIndex,
      onIndexChange: (newIndex) {
        context.read<AboutMihProvider>().setToolIndex(newIndex);
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
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.info)] = () {
      context.read<AboutMihProvider>().setToolIndex(0);
    };
    temp[const Icon(Icons.policy)] = () {
      context.read<AboutMihProvider>().setToolIndex(1);
    };
    temp[const Icon(Icons.design_services)] = () {
      context.read<AboutMihProvider>().setToolIndex(2);
    };
    temp[const Icon(Icons.star_rounded)] = () {
      context.read<AboutMihProvider>().setToolIndex(3);
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<AboutMihProvider>().toolIndex,
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
