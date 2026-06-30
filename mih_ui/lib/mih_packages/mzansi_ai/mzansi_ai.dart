import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_ai_provider.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_ai/package_tools/mih_ai_chat.dart';
import 'package:provider/provider.dart';

class MzansiAi extends StatefulWidget {
  const MzansiAi({
    super.key,
  });

  @override
  State<MzansiAi> createState() => _MzansiAiState();
}

class _MzansiAiState extends State<MzansiAi> {
  late final MihAiChat _aiChat;

  Future<void> _syncProfileData() async {
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    mzansiProfileProvider.loadCachedProfileState();
    if (mzansiProfileProvider.user == null) {
      await mzansiProfileProvider.syncWithMihServerData();
    }
  }

  @override
  void initState() {
    super.initState();
    _aiChat = MihAiChat();
    _syncProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MzansiAiProvider, MzansiProfileProvider>(
      builder: (
        BuildContext context,
        MzansiAiProvider aiProvider,
        MzansiProfileProvider profileProvider,
        Widget? child,
      ) {
        if (profileProvider.user == null) {
          return Scaffold(
            body: Center(
              child: Mihloadingcircle(),
            ),
          );
        }
        return MihPackage(
          packageActionButton: getAction(),
          packageTools: getTools(),
          packageToolBodies: getToolBody(),
          packageToolTitles: getToolTitle(),
          selectedBodyIndex: context.watch<MzansiAiProvider>().toolIndex,
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
      iconColor: MihColors.secondary(),
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
      selectedIndex: context.watch<MzansiAiProvider>().toolIndex,
    );
  }

  List<Widget> getToolBody() {
    return [
      _aiChat,
    ];
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Ask Mzansi",
    ];
    return toolTitles;
  }
}
