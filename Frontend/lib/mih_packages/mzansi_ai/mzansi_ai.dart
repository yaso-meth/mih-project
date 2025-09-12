import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_ai/package_tools/ai_chat.dart';
import 'package:flutter/material.dart';

class MzansiAi extends StatefulWidget {
  // final AppUser signedInUser;
  // final String? startUpQuestion;
  final MzansiAiArguments arguments;
  const MzansiAi({
    super.key,
    required this.arguments,
    // required this.signedInUser,
    // this.startUpQuestion,
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
    temp[const Icon(Icons.chat)] = () {
      setState(() {
        _selcetedIndex = 0;
      });
    };

    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      AiChat(
        signedInUser: widget.arguments.signedInUser,
        startUpQuestion: widget.arguments.startUpQuestion,
      ),
    ];
    return toolBodies;
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Ask Mzansi",
    ];
    return toolTitles;
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
}
