import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/user_consent.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_scack_bar.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/about_mih_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/components/mih_app_drawer.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/package_tools/mih_business_home.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/package_tools/mih_personal_home.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_data_helper_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_consent_services.dart';
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
  bool _isLoadingInitialData = true;

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingInitialData = true;
    });
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    await MihDataHelperServices().loadUserDataWithBusinessesData(
      mzansiProfileProvider,
    );
    setState(() {
      _isLoadingInitialData = false;
    });
  }

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

  void createOrUpdateAccpetance(MzansiProfileProvider mzansiProfileProvider) {
    UserConsent? userConsent = mzansiProfileProvider.userConsent;
    userConsent != null
        ? MihUserConsentServices()
            .updateUserConsentStatus(
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String(),
            mzansiProfileProvider,
            context,
          )
            .then((value) {
            if (value == 200) {
              context.goNamed("mihHome");
              ScaffoldMessenger.of(context).showSnackBar(
                MihSnackBar(
                  child: Text("Thank you for accepting our Policies"),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                MihSnackBar(
                  child: Text("There was an error, please try again later"),
                ),
              );
            }
          })
        : MihUserConsentServices()
            .insertUserConsentStatus(
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String(),
            mzansiProfileProvider,
            context,
          )
            .then((value) {
            if (value == 201) {
              context.goNamed("mihHome");
              ScaffoldMessenger.of(context).showSnackBar(
                MihSnackBar(
                  child: Text("Thank you for accepting our Policies"),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                MihSnackBar(
                  child: Text("There was an error, please try again later"),
                ),
              );
            }
          });
  }

  Widget displayConsentWindow(MzansiProfileProvider mzansiProfileProvider) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          MihPackageWindow(
            fullscreen: false,
            windowTitle: "Privacy Policy & Terms Of Service Alert!",
            onWindowTapClose: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return MihPackageAlert(
                      alertIcon: Icon(
                        Icons.warning_amber_rounded,
                        size: 100,
                        color: MihColors.getRedColor(
                          MzansiInnovationHub.of(context)!.theme.mode == "Dark",
                        ),
                      ),
                      alertTitle: "Oops, Looks like you missed a step!",
                      alertBody: Text(
                        "We're excited for you to keep using the MIH app! Before you do, please take a moment to accept our Privacy Policy and Terms of Service. Thanks for helping us keep your experience great!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark",
                          ),
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      alertColour: MihColors.getRedColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark",
                      ),
                    );
                  });
            },
            windowBody: Column(
              children: [
                Icon(
                  Icons.policy,
                  size: 150,
                  color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark",
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome to the MIH App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark",
                    ),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "To keep using the MIH app, please take a moment to review and accept our Policies. Our agreements helps us keep things running smoothly and securely.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark",
                    ),
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      MihButton(
                        onPressed: () {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            context.read<AboutMihProvider>().setToolIndex(1);
                          });
                          context.goNamed("aboutMih",
                              extra: mzansiProfileProvider.personalHome);
                        },
                        buttonColor: MihColors.getOrangeColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        elevation: 10,
                        width: 300,
                        child: Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MihButton(
                        onPressed: () {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) async {
                            context.read<AboutMihProvider>().setToolIndex(2);
                          });
                          context.goNamed("aboutMih",
                              extra: mzansiProfileProvider.personalHome);
                        },
                        buttonColor: MihColors.getYellowColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        elevation: 10,
                        width: 300,
                        child: Text(
                          "Terms of Service",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MihButton(
                        onPressed: () {
                          DateTime now = DateTime.now();
                          KenLogger.success("Date Time Now: $now");
                          createOrUpdateAccpetance(mzansiProfileProvider);
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        elevation: 10,
                        width: 300,
                        child: Text(
                          "Accept",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
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
        if (_isLoadingInitialData) {
          return Scaffold(
            body: Center(
              child: Mihloadingcircle(),
            ),
          );
        }
        // bool showConsentWindow =
        //     showPolicyWindow(mzansiProfileProvider.userConsent);
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () async {
                await _loadInitialData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: MihPackage(
                    appActionButton: getAction(),
                    appTools: getTools(mzansiProfileProvider,
                        mzansiProfileProvider.user!.type != "personal"),
                    appBody: getToolBody(mzansiProfileProvider),
                    appToolTitles: getToolTitle(),
                    actionDrawer: getActionDrawer(),
                    selectedbodyIndex:
                        mzansiProfileProvider.personalHome ? 0 : 1,
                    onIndexChange: (newValue) {
                      mzansiProfileProvider.setPersonalHome(newValue == 0);
                    },
                  ),
                ),
              ),
            ),
            if (showPolicyWindow(mzansiProfileProvider.userConsent))
              displayConsentWindow(mzansiProfileProvider),
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
            icon: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: MihCircleAvatar(
                key: Key(imageKey),
                imageFile: currentImage,
                width: 50,
                editable: false,
                fileNameController: null,
                userSelectedfile: null,
                // frameColor: frameColor,
                frameColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                backgroundColor: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
      setState(() {
        mzansiProfileProvider.setPersonalHome(true);
      });
    };
    if (isBusinessUser) {
      temp[const Icon(Icons.business_center)] = () {
        setState(() {
          mzansiProfileProvider.setPersonalHome(false);
        });
      };
    }
    return MihPackageTools(
      tools: temp,
      selcetedIndex: mzansiProfileProvider.personalHome ? 0 : 1,
    );
  }

  List<Widget> getToolBody(MzansiProfileProvider mzansiProfileProvider) {
    List<Widget> toolBodies = [];
    AppUser? user = mzansiProfileProvider.user;
    Business? business = mzansiProfileProvider.business;
    BusinessUser? businessUser = mzansiProfileProvider.businessUser;
    String userProfilePictureUrl =
        mzansiProfileProvider.userProfilePicUrl ?? "";
    toolBodies.add(
      MihPersonalHome(
        signedInUser: user!,
        personalSelected: mzansiProfileProvider.personalHome,
        business: business,
        businessUser: businessUser,
        propicFile: userProfilePictureUrl != ""
            ? NetworkImage(userProfilePictureUrl)
            : null,
        isDevActive: AppEnviroment.getEnv() == "Dev",
        isUserNew: user.username == "",
      ),
    );
    if (user.type != "personal") {
      toolBodies.add(
        MihBusinessHome(
          isLoading: _isLoadingInitialData,
        ),
      );
    }
    return toolBodies;
  }
}
