import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_tools.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_packages/access_review/package_tools/mih_access_requests.dart';
import 'package:flutter/material.dart';

class MihAccess extends StatefulWidget {
  final AppUser signedInUser;
  const MihAccess({
    super.key,
    required this.signedInUser,
  });

  @override
  State<MihAccess> createState() => _MihAccessState();
}

class _MihAccessState extends State<MihAccess> {
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
        print("Index: $_selcetedIndex");
      },
    );
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

  MihAppTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.people)] = () {
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
      MihAccessRequest(
        signedInUser: widget.signedInUser,
      ),
    ];
    return toolBodies;
  }
}
