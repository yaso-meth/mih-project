import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/package_tools/mih_personal_profile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/package_tools/mih_personal_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MzansiProfile extends StatefulWidget {
  const MzansiProfile({
    super.key,
  });

  @override
  State<MzansiProfile> createState() => _MzansiProfileState();
}

class _MzansiProfileState extends State<MzansiProfile> {
  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex: context.watch<MzansiProfileProvider>().personalIndex,
      onIndexChange: (newIndex) {
        context.read<MzansiProfileProvider>().setPersonalIndex(newIndex);
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        // Navigator.of(context).pop();
        context.goNamed(
          'mihHome',
          extra: true,
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.person)] = () {
      context.read<MzansiProfileProvider>().setPersonalIndex(0);
    };
    // temp[const Icon(Icons.person)] = () {
    //   context.read<MzansiProfileProvider>().setPersonalIndex(1);
    // };
    temp[const Icon(Icons.settings)] = () {
      context.read<MzansiProfileProvider>().setPersonalIndex(1);
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<MzansiProfileProvider>().personalIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [];
    toolBodies.add(MihPersonalProfile());
    // toolBodies.add(MihPersonalProfile());
    toolBodies.add(MihPersonalSettings());
    return toolBodies;
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Profile",
      "Settings",
    ];
    return toolTitles;
  }
}
