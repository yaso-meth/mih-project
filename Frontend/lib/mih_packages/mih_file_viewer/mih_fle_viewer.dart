import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_file_viewer_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_file_viewer/package_tools/mih_expanded_file_view.dart';
import 'package:provider/provider.dart';

class MihFleViewer extends StatefulWidget {
  const MihFleViewer({super.key});

  @override
  State<MihFleViewer> createState() => _MihFleViewerState();
}

class _MihFleViewerState extends State<MihFleViewer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MihFileViewerProvider>(
      builder: (BuildContext context, MihFileViewerProvider fileViewerProvider,
          Widget? child) {
        return MihPackage(
          appActionButton: getAction(),
          appTools: getTools(),
          appBody: getToolBody(),
          appToolTitles: getToolTitle(),
          selectedbodyIndex: fileViewerProvider.toolIndex,
          onIndexChange: (newIndex) {
            fileViewerProvider.setToolIndex(newIndex);
          },
        );
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.fullscreen_exit),
      iconSize: 35,
      onTap: () {
        context.pop();
        FocusScope.of(context).unfocus();
      },
    );
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "File Viewer",
    ];
    return toolTitles;
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.file_present)] = () {
      context.read<MihFileViewerProvider>().setToolIndex(0);
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<MihFileViewerProvider>().toolIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      MihExpandedFileView(),
    ];
    return toolBodies;
  }
}
