import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';

class MzansiDirectory extends StatefulWidget {
  const MzansiDirectory({super.key});

  @override
  State<MzansiDirectory> createState() => _MzansiDirectoryState();
}

class _MzansiDirectoryState extends State<MzansiDirectory> {
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
        print("Index: $_selcetedIndex");
      },
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      Placeholder(),
      Placeholder(),
      Placeholder(),
    ];
    return toolBodies;
  }

  MihPackageAction getAction() {
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
    temp[const Icon(Icons.person)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    temp[const Icon(Icons.business_center)] = () {
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

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Contacts",
      "Favourite Businesses",
      "Search Mzansi",
    ];
    return toolTitles;
  }
}
