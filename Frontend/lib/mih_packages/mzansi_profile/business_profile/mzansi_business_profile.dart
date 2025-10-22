import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_details.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_qr_code.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_reviews.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_business_user_search.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_my_business_team.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/package_tools/mih_my_business_user.dart';
import 'package:provider/provider.dart';

class MzansiBusinessProfile extends StatefulWidget {
  const MzansiBusinessProfile({
    super.key,
  });

  @override
  State<MzansiBusinessProfile> createState() => _MzansiBusinessProfileState();
}

class _MzansiBusinessProfileState extends State<MzansiBusinessProfile> {
  @override
  Widget build(BuildContext context) {
    return MihPackage(
      appActionButton: getAction(),
      appTools: getTools(),
      appBody: getToolBody(),
      appToolTitles: getToolTitle(),
      selectedbodyIndex: context.watch<MzansiProfileProvider>().businessIndex,
      onIndexChange: (newIndex) {
        context.read<MzansiProfileProvider>().setBusinessIndex(newIndex);
      },
    );
  }

  MihPackageAction getAction() {
    return MihPackageAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        context.goNamed(
          'mihHome',
        );
        FocusScope.of(context).unfocus();
        context.read<MzansiProfileProvider>().setBusinessIndex(0);
      },
    );
  }

  MihPackageTools getTools() {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.business)] = () {
      context.read<MzansiProfileProvider>().setBusinessIndex(0);
    };
    temp[const Icon(Icons.person)] = () {
      context.read<MzansiProfileProvider>().setBusinessIndex(1);
    };
    temp[const Icon(Icons.people)] = () {
      context.read<MzansiProfileProvider>().setBusinessIndex(2);
    };
    temp[const Icon(Icons.add)] = () {
      context.read<MzansiProfileProvider>().setBusinessIndex(3);
    };
    temp[const Icon(Icons.star_rate_rounded)] = () {
      context.read<MzansiProfileProvider>().setBusinessIndex(4);
    };
    temp[const Icon(Icons.qr_code_rounded)] = () {
      context.read<MzansiProfileProvider>().setBusinessIndex(5);
    };
    return MihPackageTools(
      tools: temp,
      selcetedIndex: context.watch<MzansiProfileProvider>().businessIndex,
    );
  }

  List<Widget> getToolBody() {
    List<Widget> toolBodies = [
      MihBusinessDetails(),
      MihMyBusinessUser(),
      MihMyBusinessTeam(),
      MihBusinessUserSearch(),
      MihBusinessReviews(
          business: context.watch<MzansiProfileProvider>().business!),
      MihBusinessQrCode(
        business: context.watch<MzansiProfileProvider>().business!,
        // startUpSearch: "",
      ),
    ];
    return toolBodies;
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Profile",
      "User",
      "Team",
      "Add",
      "Reviews",
      "Share",
    ];
    return toolTitles;
  }
}
