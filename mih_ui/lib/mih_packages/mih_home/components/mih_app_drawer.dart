import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_providers/about_mih_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_access_controlls_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_authentication_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_banner_ad_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calculator_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_ai_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_wallet_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:provider/provider.dart';
import 'package:supertokens_flutter/supertokens.dart';

class MIHAppDrawer extends StatefulWidget {
  const MIHAppDrawer({
    super.key,
  });

  @override
  State<MIHAppDrawer> createState() => _MIHAppDrawerState();
}

class _MIHAppDrawerState extends State<MIHAppDrawer> {
  final proPicController = TextEditingController();
  late Widget profilePictureLoaded;

  Future<void> clearCacheAndProviders() async {
    context.read<MihAccessControllsProvider>().reset();
    context.read<MihAuthenticationProvider>().reset();
    context.read<MihBannerAdProvider>().reset();
    context.read<MihCalculatorProvider>().reset();
    context.read<MihCalendarProvider>().reset();
    context.read<MihMineSweeperProvider>().reset();
    context.read<MzansiAiProvider>().reset();
    context.read<MzansiDirectoryProvider>().reset();
    context.read<PatientManagerProvider>().reset();
    await context.read<AboutMihProvider>().clearAboutMihCacheAndProvider();
    await context.read<MzansiWalletProvider>().clearWalletCacheAndProvider();
    await context.read<MzansiProfileProvider>().clearProfileCacheAndProvider();
  }

  Future<bool> signOut() async {
    await SuperTokens.signOut(completionHandler: (error) {
      // handle error if any
    });
    return true;
  }

  Widget displayProPic(MzansiProfileProvider mzansiProfileProvider) {
    return GestureDetector(
      onTap: () {
        if (mzansiProfileProvider.personalHome) {
          context.goNamed(
            'mzansiProfileManage',
          );
        } else {
          if (mzansiProfileProvider.business == null) {
            context.goNamed(
              'businessProfileSetup',
              extra: mzansiProfileProvider.user,
            );
          } else {
            context.goNamed(
              "businessProfileManage",
            );
          }
        }
      },
      child: MihCircleAvatar(
        imageFile: mzansiProfileProvider.personalHome
            ? mzansiProfileProvider.userProfilePicture
            : mzansiProfileProvider.businessProfilePicture,
        width: 60,
        expandable: false,
        editable: false,
        fileNameController: proPicController,
        onChange: (_) {},
        userSelectedfile: null,
        frameColor: MihColors.primary(),
        backgroundColor: MihColors.secondary(),
      ),
    );
  }

  @override
  void dispose() {
    proPicController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // precacheImage(
    //     MzansiInnovationHub.of(context)!.theme.logoImage().image, context);
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        return SafeArea(
          child: Drawer(
            //backgroundColor:  MihColors.primary(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Stack(
                  //fit: StackFit.passthrough,
                  children: [
                    Column(
                      // reverse: false,
                      // padding: EdgeInsets.zero,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        DrawerHeader(
                          decoration: BoxDecoration(
                            color: MihColors.secondary(),
                          ),
                          child: SizedBox(
                            // height: 300,
                            width: constraints.maxWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                displayProPic(mzansiProfileProvider),
                                Visibility(
                                  visible: !mzansiProfileProvider.personalHome,
                                  child: Text(
                                    mzansiProfileProvider.business?.Name ??
                                        "Setup Business",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: MihColors.primary(),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: mzansiProfileProvider.personalHome,
                                  child: Text(
                                    "${mzansiProfileProvider.user!.fname} ${mzansiProfileProvider.user!.lname}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: MihColors.primary(),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: !mzansiProfileProvider.personalHome,
                                  child: Text(
                                    mzansiProfileProvider.business?.type ?? "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: MihColors.primary(),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: mzansiProfileProvider.personalHome,
                                  child: Text(
                                    "@${mzansiProfileProvider.user!.username}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: MihColors.primary(),
                                    ),
                                  ),
                                ),
                                Text(
                                  mzansiProfileProvider.business == null
                                      ? "PERSONAL"
                                      : "BUSINESS",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: MihColors.primary(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ListTile(
                                title: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.policy,
                                      color: MihColors.secondary(),
                                    ),
                                    const SizedBox(width: 25.0),
                                    Text(
                                      "Privacy Policy",
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        color: MihColors.secondary(),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  context.goNamed(
                                    "mihPrivacyPolicy",
                                  );
                                },
                              ),
                              ListTile(
                                title: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.design_services_rounded,
                                      color: MihColors.secondary(),
                                    ),
                                    const SizedBox(width: 25.0),
                                    Text(
                                      "Terms of Service",
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        color: MihColors.secondary(),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  context.goNamed(
                                    "mihTermsOfService",
                                  );
                                },
                              ),
                              ListTile(
                                title: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: MihColors.secondary(),
                                    ),
                                    const SizedBox(width: 25.0),
                                    Text(
                                      "Sign Out",
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        color: MihColors.secondary(),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  await SuperTokens.signOut(
                                      completionHandler: (error) {
                                    print(error);
                                  });
                                  if (await SuperTokens.doesSessionExist() ==
                                      false) {
                                    await clearCacheAndProviders();
                                    if (context.mounted) {
                                      context.goNamed(
                                        'mihHome',
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      width: 30,
                      height: 30,
                      child: InkWell(
                        onTap: () {
                          context.goNamed("aboutMih");
                        },
                        child: Icon(
                          MihIcons.mihLogo,
                          color: MihColors.primary(),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
