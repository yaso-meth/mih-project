import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/package_tools/mih_personal_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/package_tools/mih_personal_qr_code.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:provider/provider.dart';

class MzansiProfileView extends StatefulWidget {
  final String? username;
  const MzansiProfileView({
    super.key,
    required this.username,
  });

  @override
  State<MzansiProfileView> createState() => _MzansiProfileViewState();
}

class _MzansiProfileViewState extends State<MzansiProfileView> {
  late final MihPersonalProfileView _personalProfileView;
  late final MihPersonalQrCode _personalQrCode;

  void _loadUserData() async {
    MzansiDirectoryProvider directoryProvider =
        context.read<MzansiDirectoryProvider>();
    directoryProvider.setPersonalViewIndex(0);
    if (widget.username != null) {
      final user = await MihUserServices()
          .getMIHUserDetailsByUsername(widget.username!, context);
      if (user == null) {
        context.goNamed(
          'mihHome',
          extra: true,
        );
      } else {
        KenLogger.success("User found: ${user.username}");
        directoryProvider.setSelectedUser(user: user);
      }
    }
    _personalProfileView = MihPersonalProfileView();
    _personalQrCode = MihPersonalQrCode(user: directoryProvider.selectedUser);
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiDirectoryProvider>(
      builder: (BuildContext context, MzansiDirectoryProvider directoryProvider,
          Widget? child) {
        if (directoryProvider.selectedUser == null) {
          KenLogger.warning("User is null, showing loading indicator");
          return Scaffold(
            body: const Center(
              child: Mihloadingcircle(),
            ),
          );
        } else {
          return MihPackage(
            packageActionButton: getAction(),
            packageTools: getTools(),
            packageToolBodies: getToolBody(),
            packageToolTitles: getToolTitle(),
            selectedBodyIndex: directoryProvider.personalViewIndex,
            onIndexChange: (newValue) {
              directoryProvider.setPersonalViewIndex(newValue);
            },
          );
        }
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconColor: MihColors.secondary(),
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
      context.read<MzansiDirectoryProvider>().setPersonalViewIndex(0);
    };
    temp[const Icon(Icons.qr_code_rounded)] = () {
      context.read<MzansiDirectoryProvider>().setPersonalViewIndex(1);
    };
    return MihPackageTools(
      tools: temp,
      selectedIndex: context.watch<MzansiDirectoryProvider>().personalViewIndex,
    );
  }

  List<Widget> getToolBody() {
    return [
      _personalProfileView,
      _personalQrCode,
    ];
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Profile",
      "Share",
    ];
    return toolTitles;
  }
}
