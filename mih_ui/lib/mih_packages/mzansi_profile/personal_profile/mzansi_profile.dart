import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/package_tools/mih_personal_qr_code.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/package_tools/mih_personal_profile.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/package_tools/mih_personal_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MzansiProfile extends StatefulWidget {
  const MzansiProfile({
    super.key,
  });

  @override
  State<MzansiProfile> createState() => _MzansiProfileState();
}

class _MzansiProfileState extends State<MzansiProfile> {
  // bool _isLoadingInitialData = true;
  late final MihPersonalProfile _personalProfile;
  late final MihPersonalQrCode _personalQrCode;
  late final MihPersonalSettings _personalSettings;

  @override
  void initState() {
    super.initState();
    _personalProfile = const MihPersonalProfile();
    _personalQrCode = const MihPersonalQrCode(user: null);
    _personalSettings = const MihPersonalSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          Widget? child) {
        return MihPackage(
          packageActionButton: getAction(),
          packageTools: getTools(),
          packageToolBodies: getToolBody(),
          packageToolTitles: getToolTitle(),
          selectedBodyIndex: profileProvider.personalIndex,
          onIndexChange: (newIndex) {
            profileProvider.setPersonalIndex(newIndex);
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
        // Navigator.of(context).pop();
        context.goNamed(
          'mihHome',
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.person)] = () {
      context.read<MzansiProfileProvider>().setPersonalIndex(0);
    };
    temp[const Icon(Icons.qr_code_rounded)] = () {
      context.read<MzansiProfileProvider>().setPersonalIndex(1);
    };
    temp[const Icon(Icons.settings)] = () {
      context.read<MzansiProfileProvider>().setPersonalIndex(2);
    };
    return MihPackageTools(
      tools: temp,
      selectedIndex: context.watch<MzansiProfileProvider>().personalIndex,
    );
  }

  List<Widget> getToolBody() {
    return [
      _personalProfile,
      _personalQrCode,
      _personalSettings,
    ];
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Profile",
      "Share",
      "Settings",
    ];
    return toolTitles;
  }
}
