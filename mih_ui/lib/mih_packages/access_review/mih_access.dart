import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_access_controlls_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/access_review/package_tools/mih_access_requests.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MihAccess extends StatefulWidget {
  const MihAccess({
    super.key,
  });

  @override
  State<MihAccess> createState() => _MihAccessState();
}

class _MihAccessState extends State<MihAccess> {
  late final MihAccessRequest _accessRequest;

  Future<void> _loadInitialData() async {
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    MihAccessControllsProvider accessProvider =
        context.read<MihAccessControllsProvider>();
    profileProvider.loadCachedProfileState();
    accessProvider.loadCachedAccess();
    if (profileProvider.user == null) {
      await profileProvider.syncWithMihServerData();
    }
    if (accessProvider.accessList == null) {
      await accessProvider.syncWithMihServerData(profileProvider);
    } else {
      accessProvider.syncWithMihServerData(profileProvider);
    }
  }

  @override
  void initState() {
    super.initState();
    _accessRequest = MihAccessRequest();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadInitialData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MzansiProfileProvider, MihAccessControllsProvider>(
      builder: (
        BuildContext context,
        MzansiProfileProvider profileProvider,
        MihAccessControllsProvider accessProvider,
        Widget? child,
      ) {
        if (profileProvider.user == null || accessProvider.accessList == null) {
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
          selectedBodyIndex: accessProvider.toolIndex,
          onIndexChange: (newValue) {
            accessProvider.setToolIndex(newValue);
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
        context.goNamed(
          'mihHome',
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.people)] = () {
      context.read<MihAccessControllsProvider>().setToolIndex(0);
    };
    return MihPackageTools(
      tools: temp,
      selectedIndex: context.watch<MihAccessControllsProvider>().toolIndex,
    );
  }

  List<Widget> getToolBody() {
    return [
      _accessRequest,
    ];
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Access",
    ];
    return toolTitles;
  }
}
