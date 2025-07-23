import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_directory/package_tools/mih_search_mzansi.dart';

class MzansiDirectory extends StatefulWidget {
  final MzansiDirectoryArguments arguments;
  const MzansiDirectory({
    super.key,
    required this.arguments,
  });

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
      },
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      MihSearchMzansi(
        startUpSearch: widget.arguments.startUpSearch,
        personalSearch: widget.arguments.personalSearch,
      ),
      // MihContacts(),
      // MihFavouriteBusinesses(),
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
    temp[const Icon(Icons.search)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };
    // temp[const Icon(Icons.person)] = () {
    //   setState(() {
    //     _selcetedIndex = 1;
    //   });
    // };
    // temp[const Icon(Icons.business_center)] = () {
    //   setState(() {
    //     _selcetedIndex = 2;
    //   });
    // };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Mzansi Search",
      "Contacts",
      "Favourite Businesses",
    ];
    return toolTitles;
  }
}
