import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/package_tools/mih_personal_profile_view.dart';
import 'package:flutter/material.dart';

class MzansiProfileView extends StatefulWidget {
  const MzansiProfileView({
    super.key,
  });

  @override
  State<MzansiProfileView> createState() => _MzansiProfileViewState();
}

class _MzansiProfileViewState extends State<MzansiProfileView> {
  int _selectedIndex = 0;
  late final MihPersonalProfileView _personalProfileView;

  @override
  void initState() {
    super.initState();
    _personalProfileView = MihPersonalProfileView();
  }

  @override
  Widget build(BuildContext context) {
    return MihPackage(
      packageActionButton: getAction(),
      packageTools: getTools(),
      packageToolBodies: getToolBody(),
      packageToolTitles: getToolTitle(),
      selectedBodyIndex: _selectedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selectedIndex = newValue;
        });
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        context.pop();
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.person)] = () {
      setState(() {
        _selectedIndex = 0;
      });
    };
    return MihPackageTools(
      tools: temp,
      selectedIndex: _selectedIndex,
    );
  }

  List<Widget> getToolBody() {
    return [
      _personalProfileView,
    ];
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Profile",
    ];
    return toolTitles;
  }
}
