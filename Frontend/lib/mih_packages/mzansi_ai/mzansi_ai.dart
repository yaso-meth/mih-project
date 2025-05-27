import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_tools.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_ai/package_tools/ai_chat.dart';
import 'package:flutter/material.dart';

class MzansiAi extends StatefulWidget {
  final AppUser signedInUser;
  const MzansiAi({
    super.key,
    required this.signedInUser,
  });

  @override
  State<MzansiAi> createState() => _MzansiAiState();
}

class _MzansiAiState extends State<MzansiAi> {
  int _selcetedIndex = 0;

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
    temp[const Icon(Icons.chat)] = () {
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
      AiChat(signedInUser: widget.signedInUser),
    ];
    return toolBodies;
  }

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
      selectedbodyIndex: _selcetedIndex,
      onIndexChange: (newValue) {
        setState(() {
          _selcetedIndex = newValue;
        });
        print("Index: $_selcetedIndex");
      },
    );
  }
}
