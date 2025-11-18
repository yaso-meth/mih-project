import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_ai_provider.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_ai/package_tools/mih_ai_chat.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_data_helper_services.dart';
import 'package:provider/provider.dart';

class MzansiAi extends StatefulWidget {
  const MzansiAi({
    super.key,
  });

  @override
  State<MzansiAi> createState() => _MzansiAiState();
}

class _MzansiAiState extends State<MzansiAi> {
  bool _isLoadingInitialData = true;

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingInitialData = true;
    });
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    await MihDataHelperServices().loadUserDataOnly(
      mzansiProfileProvider,
    );
    setState(() {
      _isLoadingInitialData = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiAiProvider>(
      builder: (BuildContext context, MzansiAiProvider value, Widget? child) {
        if (_isLoadingInitialData) {
          return Scaffold(
            body: Center(
              child: Mihloadingcircle(),
            ),
          );
        }
        return MihPackage(
          appActionButton: getAction(),
          appTools: getTools(),
          appBody: getToolBody(),
          appToolTitles: getToolTitle(),
          selectedbodyIndex: context.watch<MzansiAiProvider>().toolIndex,
          onIndexChange: (newValue) {
            context.read<MzansiAiProvider>().setToolIndex(newValue);
          },
        );
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        context.read<MzansiAiProvider>().setStartUpQuestion(null);
        context.goNamed(
          'mihHome',
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.chat)] = () {
      context.read<MzansiAiProvider>().setToolIndex(0);
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<MzansiAiProvider>().toolIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      MihAiChat(),
    ];
    return toolBodies;
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Ask Mzansi",
    ];
    return toolTitles;
  }
}
