import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/about_mih_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_access_controlls_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_authentication_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_banner_ad_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_calculator_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_mine_sweeper_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_ai_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_wallet_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
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

  void resetProviders() {
    context.read<AboutMihProvider>().reset();
    context.read<MihAccessControllsProvider>().reset();
    context.read<MihAuthenticationProvider>().reset();
    context.read<MihBannerAdProvider>().reset();
    context.read<MihCalculatorProvider>().reset();
    context.read<MihCalendarProvider>().reset();
    context.read<MihMineSweeperProvider>().reset();
    context.read<MzansiAiProvider>().reset();
    context.read<MzansiDirectoryProvider>().reset();
    context.read<MzansiWalletProvider>().reset();
    context.read<PatientManagerProvider>().reset();
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
        editable: false,
        fileNameController: proPicController,
        onChange: (_) {},
        userSelectedfile: null,
        frameColor: MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        backgroundColor: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
            //backgroundColor:  MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                            color: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
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
                                      color: MihColors.getPrimaryColor(
                                          MzansiInnovationHub.of(context)!
                                                  .theme
                                                  .mode ==
                                              "Dark"),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: mzansiProfileProvider.personalHome,
                                  child: Text(
                                    "${mzansiProfileProvider.user!.fname} ${mzansiProfileProvider.user!.lname}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: MihColors.getPrimaryColor(
                                          MzansiInnovationHub.of(context)!
                                                  .theme
                                                  .mode ==
                                              "Dark"),
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
                                      color: MihColors.getPrimaryColor(
                                          MzansiInnovationHub.of(context)!
                                                  .theme
                                                  .mode ==
                                              "Dark"),
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
                                      color: MihColors.getPrimaryColor(
                                          MzansiInnovationHub.of(context)!
                                                  .theme
                                                  .mode ==
                                              "Dark"),
                                    ),
                                  ),
                                ),
                                Text(
                                  mzansiProfileProvider.user!.type
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: MihColors.getPrimaryColor(
                                        MzansiInnovationHub.of(context)!
                                                .theme
                                                .mode ==
                                            "Dark"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // ListTile(
                        //   title: Row(
                        //     mainAxisSize: MainAxisSize.max,
                        //     children: [
                        //       Icon(
                        //         Icons.home_outlined,
                        //         color:
                        //             MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                        //       ),
                        //       const SizedBox(width: 25.0),
                        //       Text(
                        //         "Home",
                        //         style: TextStyle(
                        //           //fontWeight: FontWeight.bold,
                        //           color: MzansiInnovationHub.of(context)!
                        //               .theme
                        //               .secondaryColor(),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        //   onTap: () {
                        //     Navigator.of(context)
                        //         .pushNamedAndRemoveUntil('/', (route) => false);
                        //   },
                        // ),
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
                                      color: MihColors.getSecondaryColor(
                                          MzansiInnovationHub.of(context)!
                                                  .theme
                                                  .mode ==
                                              "Dark"),
                                    ),
                                    const SizedBox(width: 25.0),
                                    Text(
                                      "Privacy Policy",
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        color: MihColors.getSecondaryColor(
                                            MzansiInnovationHub.of(context)!
                                                    .theme
                                                    .mode ==
                                                "Dark"),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) async {
                                    context
                                        .read<AboutMihProvider>()
                                        .setToolIndex(1);
                                  });
                                  context.goNamed(
                                    "aboutMih",
                                    extra: true,
                                  );
                                },
                              ),
                              ListTile(
                                title: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.design_services_rounded,
                                      color: MihColors.getSecondaryColor(
                                          MzansiInnovationHub.of(context)!
                                                  .theme
                                                  .mode ==
                                              "Dark"),
                                    ),
                                    const SizedBox(width: 25.0),
                                    Text(
                                      "Terms of Service",
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        color: MihColors.getSecondaryColor(
                                            MzansiInnovationHub.of(context)!
                                                    .theme
                                                    .mode ==
                                                "Dark"),
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) async {
                                    context
                                        .read<AboutMihProvider>()
                                        .setToolIndex(2);
                                  });
                                  context.goNamed(
                                    "aboutMih",
                                    extra: true,
                                  );
                                },
                              ),
                              ListTile(
                                title: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: MihColors.getSecondaryColor(
                                          MzansiInnovationHub.of(context)!
                                                  .theme
                                                  .mode ==
                                              "Dark"),
                                    ),
                                    const SizedBox(width: 25.0),
                                    Text(
                                      "Sign Out",
                                      style: TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        color: MihColors.getSecondaryColor(
                                            MzansiInnovationHub.of(context)!
                                                    .theme
                                                    .mode ==
                                                "Dark"),
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
                                    resetProviders();
                                    await Future.delayed(Duration.zero);
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
                          // setState(() {
                          //   if (MzansiInnovationHub.of(context)?.theme.mode ==
                          //       "Dark") {
                          //     //darkm = !darkm;
                          //     MzansiInnovationHub.of(context)!
                          //         .changeTheme(ThemeMode.light);
                          //     //print("Dark Mode: $darkm");
                          //   } else {
                          //     //darkm = !darkm;
                          //     MzansiInnovationHub.of(context)!
                          //         .changeTheme(ThemeMode.dark);
                          //     //print("Dark Mode: $darkm");
                          //   }
                          //   // Navigator.of(context).popAndPushNamed('/',);
                          // });
                          context.goNamed("aboutMih");
                        },
                        child: Icon(
                          MihIcons.mihLogo,
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                      // IconButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       if (MzansiInnovationHub.of(context)?.theme.mode == "Dark") {
                      //         //darkm = !darkm;
                      //         MzansiInnovationHub.of(context)!.changeTheme(ThemeMode.light);
                      //         //print("Dark Mode: $darkm");
                      //       } else {
                      //         //darkm = !darkm;
                      //         MzansiInnovationHub.of(context)!.changeTheme(ThemeMode.dark);
                      //         //print("Dark Mode: $darkm");
                      //       }
                      //       Navigator.of(context).popAndPushNamed('/');
                      //     });
                      //   },
                      //   icon: Icon(
                      //     Icons.light_mode,
                      //     color: MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                      //     size: 35,
                      //   ),
                      // ),
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
