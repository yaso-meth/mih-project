import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_details_set_up.dart';
import 'package:provider/provider.dart';

class MzansiSetUpBusinessProfile extends StatefulWidget {
  const MzansiSetUpBusinessProfile({super.key});

  @override
  State<MzansiSetUpBusinessProfile> createState() =>
      _MzansiSetUpBusinessProfileState();
}

class _MzansiSetUpBusinessProfileState
    extends State<MzansiSetUpBusinessProfile> {
  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex: context.watch<MzansiProfileProvider>().businessIndex,
      onIndexChange: (newIndex) {
        context.read<MzansiProfileProvider>().setBusinessIndex(newIndex);
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
        context.read<MzansiProfileProvider>().setBusinessIndex(0);
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.business)] = () {
      context.read<MzansiProfileProvider>().setBusinessIndex(0);
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<MzansiProfileProvider>().businessIndex,
    );
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Set Up Profile",
    ];
    return toolTitles;
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      MihBusinessDetailsSetUp(),
    ];
    return toolBodies;
  }
}
