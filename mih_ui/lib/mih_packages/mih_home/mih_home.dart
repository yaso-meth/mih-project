import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/user_consent.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/components/mih_user_consent_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/about_mih_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/components/mih_app_drawer.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/package_tools/mih_business_home.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/package_tools/mih_personal_home.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_wallet_provider.dart';
import 'package:provider/provider.dart';

class MihHome extends StatefulWidget {
  const MihHome({
    super.key,
  });

  @override
  State<MihHome> createState() => _MihHomeState();
}

class _MihHomeState extends State<MihHome> {
  DateTime latestPrivacyPolicyDate = DateTime.parse("2024-12-01");
  DateTime latestTermOfServiceDate = DateTime.parse("2024-12-01");

  bool showPolicyWindow(UserConsent? userConsent) {
    if (userConsent == null) {
      return true;
    } else {
      if (userConsent.privacy_policy_accepted
              .isAfter(latestPrivacyPolicyDate) &&
          userConsent.terms_of_services_accepted
              .isAfter(latestTermOfServiceDate)) {
        return false;
      } else {
        return true;
      }
    }
  }

  Future<void> _syncProfileData() async {
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    mzansiProfileProvider.loadCachedProfileState();
    if (mzansiProfileProvider.user == null) {
      await mzansiProfileProvider.syncWithMihServerData();
    }
    if(mzansiProfileProvider.isLocalModificationsPending()){
	mzansiProfileProvider.syncWithMihServerData();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _syncProfileData();
      }
    });
  }

  List<String> getToolTitle() {
    List<String> toolTitles = [
      "Personal",
      "Business",
    ];
    return toolTitles;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        if (mzansiProfileProvider.user == null) {
          return Scaffold(
            body: Center(
              child: Mihloadingcircle(),
            ),
          );
        }
        return Stack(
          children: [
            RefreshIndicator(
              key: mzansiProfileProvider.refreshIndicatorKey,
              onRefresh: () async {
                MzansiWalletProvider walletProvider =
                    context.read<MzansiWalletProvider>();
                AboutMihProvider aboutProvider =
                    context.read<AboutMihProvider>();
                await mzansiProfileProvider.syncWithMihServerData();
                await walletProvider
                    .syncWithMihServerData(mzansiProfileProvider);
                bool success = await aboutProvider.syncWithMihServerData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    MihSnackBar(
                      child: Text(
                        success
                            ? "Data Synced with MIH Server."
                            : "MIH App operation in Offline Mode",
                      ),
                      // backgroundColor: success ? null : MihColors.red(),
                    ),
                  );
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: MihPackage(
                    packageActionButton: getAction(),
                    packageTools: getTools(mzansiProfileProvider,
                        mzansiProfileProvider.business != null),
                    packageToolBodies: getToolBody(mzansiProfileProvider),
                    packageToolTitles: getToolTitle(),
                    actionDrawer: getActionDrawer(),
                    selectedBodyIndex:
                        mzansiProfileProvider.personalHome ? 0 : 1,
                    onIndexChange: (newValue) {
                      mzansiProfileProvider.setPersonalHome(newValue == 0);
                    },
                  ),
                ),
              ),
            ),
            if (showPolicyWindow(mzansiProfileProvider.userConsent))
              MihUserConsentWindow(),
          ],
        );
      },
    );
  }

  Widget getAction() {
    return Builder(builder: (context) {
      return Consumer<MzansiProfileProvider>(
        builder: (BuildContext context,
            MzansiProfileProvider mzansiProfileProvider, Widget? child) {
          ImageProvider<Object>? currentImage;
          String imageKey;
          if (mzansiProfileProvider.personalHome) {
            currentImage = mzansiProfileProvider.userProfilePicture;
            imageKey = 'user_${mzansiProfileProvider.userProfilePicUrl}';
          } else {
            currentImage = mzansiProfileProvider.businessProfilePicture;
            imageKey =
                'business_${mzansiProfileProvider.businessProfilePicUrl}';
          }
          return MihPackageAction(
            iconColor: MihColors.secondary(),
            icon: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: MihCircleAvatar(
                key: Key(imageKey),
                imageFile: currentImage,
                width: 50,
                expandable: false,
                editable: false,
                fileNameController: null,
                userSelectedfile: null,
                // frameColor: frameColor,
                frameColor: MihColors.secondary(),
                backgroundColor: MihColors.primary(),
                onChange: (_) {},
              ),
            ),
            iconSize: 45,
            onTap: () {
              Scaffold.of(context).openDrawer();
              FocusScope.of(context)
                  .requestFocus(FocusNode()); // Fully unfocus all fields
              // FocusScope.of(context).unfocus(); // Unfocus any text fields
            },
          );
        },
      );
    });
  }

  MIHAppDrawer getActionDrawer() {
    return MIHAppDrawer();
  }

  MihPackageTools getTools(
      MzansiProfileProvider mzansiProfileProvider, bool isBusinessUser) {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.person)] = () {
      mzansiProfileProvider.setPersonalHome(true);
    };
    if (isBusinessUser) {
      temp[const Icon(Icons.business_center)] = () {
        mzansiProfileProvider.setPersonalHome(false);
      };
    }
    return MihPackageTools(
      tools: temp,
      selectedIndex: mzansiProfileProvider.personalHome ? 0 : 1,
    );
  }

  List<Widget> getToolBody(MzansiProfileProvider mzansiProfileProvider) {
    return [
      const MihPersonalHome(),
      if (mzansiProfileProvider.business != null)
        const MihBusinessHome(isLoading: false)
    ];
  }
}
