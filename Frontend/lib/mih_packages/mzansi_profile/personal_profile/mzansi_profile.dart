import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/package_tools/mih_personal_profile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/package_tools/mih_personal_settings.dart';
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
          extra: AuthArguments(
            true,
            false,
          ),
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.person)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    temp[const Icon(Icons.settings)] = () {
      setState(() {
        _selcetedIndex = 1;
      });
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [];
    toolBodies.add(MihPersonalProfile(
      arguments: widget.arguments,
    ));
    toolBodies.add(MihPersonalSettings(
      signedInUser: widget.arguments.signedInUser,
    ));
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
