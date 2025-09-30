import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/user_consent.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_scack_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/components/mih_app_drawer.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/mih_home_error.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/package_tools/mih_business_home.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/package_tools/mih_personal_home.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_service_calls.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_consent_services.dart';

// ignore: must_be_immutable
class MihHome extends StatefulWidget {
  final bool personalSelected;
  const MihHome({
    super.key,
    required this.personalSelected,
  });

  @override
  State<MihHome> createState() => _MihHomeState();
}

class _MihHomeState extends State<MihHome> {
  final proPicController = TextEditingController();
  late int _selcetedIndex;
  late bool _personalSelected;
  late Future<HomeArguments> profileData;
  late Future<UserConsent?> futureUserConsent;
  bool showUserConsent = false;
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

  void createOrUpdateAccpetance(UserConsent? userConsent, String app_id) {
    userConsent != null
        ? MihUserConsentServices()
            .updateUserConsentStatus(
            app_id,
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String(),
          )
            .then((value) {
            if (value == 200) {
              // setState(() {
              //   showUserConsent = false;
              // });
              context.goNamed("mihHome", extra: false);
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
            app_id,
            DateTime.now().toIso8601String(),
            DateTime.now().toIso8601String(),
          )
            .then((value) {
            if (value == 201) {
              // setState(() {
              //   showUserConsent = false;
              // });
              context.goNamed("mihHome", extra: false);
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    profileData = MIHApiCalls().getProfile(10, context);
    futureUserConsent = MihUserConsentServices().getUserConsentStatus();
    if (widget.personalSelected == true) {
      setState(() {
        _selcetedIndex = 0;
        _personalSelected = true;
      });
    } else {
      setState(() {
        _selcetedIndex = 1;
        _personalSelected = false;
      });
    }
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
    return FutureBuilder(
      future: profileData,
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: const Mihloadingcircle(
                // message: "Fetching your Data...",
                ),
          );
        } else if (asyncSnapshot.connectionState == ConnectionState.done &&
            asyncSnapshot.hasData) {
          return Stack(
            children: [
              MihPackage(
                appActionButton: getAction(asyncSnapshot.data!.profilePicUrl),
                appTools: getTools(
                    asyncSnapshot.data!.signedInUser.type != "personal"),
                appBody: getToolBody(asyncSnapshot.data!),
                appToolTitles: getToolTitle(),
                actionDrawer: getActionDrawer(
                  asyncSnapshot.data!.signedInUser,
                  asyncSnapshot.data!.profilePicUrl,
                ),
                selectedbodyIndex: _selcetedIndex,
                onIndexChange: (newValue) {
                  if (_selcetedIndex == 0) {
                    setState(() {
                      _selcetedIndex = newValue;
                      _personalSelected = true;
                    });
                  } else {
                    setState(() {
                      _selcetedIndex = newValue;
                      _personalSelected = false;
                    });
                  }
                },
              ),
              FutureBuilder(
                  future: futureUserConsent,
                  builder: (context, asyncSnapshotUserConsent) {
                    if (asyncSnapshotUserConsent.connectionState ==
                        ConnectionState.waiting) {
                      showUserConsent = false;
                    } else if (asyncSnapshotUserConsent.connectionState ==
                            ConnectionState.done &&
                        asyncSnapshotUserConsent.hasData) {
                      showUserConsent =
                          showPolicyWindow(asyncSnapshotUserConsent.data);
                    } else if (asyncSnapshotUserConsent.connectionState ==
                            ConnectionState.done &&
                        !asyncSnapshotUserConsent.hasData) {
                      showUserConsent = true;
                    } else {
                      showUserConsent = false;
                    }
                    return Visibility(
                      visible: showUserConsent,
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            MihPackageWindow(
                              fullscreen: false,
                              windowTitle:
                                  "Privacy Policy & Terms Of Service Alert!",
                              onWindowTapClose: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return MihPackageAlert(
                                        alertIcon: Icon(
                                          Icons.warning_amber_rounded,
                                          size: 100,
                                          color: MihColors.getRedColor(
                                            MzansiInnovationHub.of(context)!
                                                    .theme
                                                    .mode ==
                                                "Dark",
                                          ),
                                        ),
                                        alertTitle:
                                            "Oops, Looks like you missed a step!",
                                        alertBody: Text(
                                          "We're excited for you to keep using the MIH app! Before you do, please take a moment to accept our Privacy Policy and Terms of Service. Thanks for helping us keep your experience great!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: MihColors.getSecondaryColor(
                                              MzansiInnovationHub.of(context)!
                                                      .theme
                                                      .mode ==
                                                  "Dark",
                                            ),
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        alertColour: MihColors.getRedColor(
                                          MzansiInnovationHub.of(context)!
                                                  .theme
                                                  .mode ==
                                              "Dark",
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
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark",
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Welcome to the MIH App",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: MihColors.getSecondaryColor(
                                        MzansiInnovationHub.of(context)!
                                                .theme
                                                .mode ==
                                            "Dark",
                                      ),
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "To keep using the MIH app, please take a moment to review and accept our Privacy Policy and Terms of Service. our agreement helps us keep things running smoothly and securely.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: MihColors.getSecondaryColor(
                                        MzansiInnovationHub.of(context)!
                                                .theme
                                                .mode ==
                                            "Dark",
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
                                            context.goNamed(
                                              "aboutMih",
                                              extra: AboutArguments(
                                                widget.personalSelected,
                                                1,
                                              ),
                                            );
                                          },
                                          buttonColor: MihColors.getOrangeColor(
                                              MzansiInnovationHub.of(context)!
                                                      .theme
                                                      .mode ==
                                                  "Dark"),
                                          elevation: 10,
                                          width: 300,
                                          child: Text(
                                            "Privacy Policy",
                                            style: TextStyle(
                                              color: MihColors.getPrimaryColor(
                                                  MzansiInnovationHub.of(
                                                              context)!
                                                          .theme
                                                          .mode ==
                                                      "Dark"),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        MihButton(
                                          onPressed: () {
                                            context.goNamed(
                                              "aboutMih",
                                              extra: AboutArguments(
                                                widget.personalSelected,
                                                2,
                                              ),
                                            );
                                          },
                                          buttonColor: MihColors.getYellowColor(
                                              MzansiInnovationHub.of(context)!
                                                      .theme
                                                      .mode ==
                                                  "Dark"),
                                          elevation: 10,
                                          width: 300,
                                          child: Text(
                                            "Terms of Service",
                                            style: TextStyle(
                                              color: MihColors.getPrimaryColor(
                                                  MzansiInnovationHub.of(
                                                              context)!
                                                          .theme
                                                          .mode ==
                                                      "Dark"),
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        MihButton(
                                          onPressed: () {
                                            DateTime now = DateTime.now();
                                            KenLogger.success(
                                                "Date Time Now: $now");
                                            createOrUpdateAccpetance(
                                              asyncSnapshotUserConsent.data,
                                              asyncSnapshot
                                                  .data!.signedInUser.app_id,
                                            );
                                          },
                                          buttonColor: MihColors.getGreenColor(
                                              MzansiInnovationHub.of(context)!
                                                      .theme
                                                      .mode ==
                                                  "Dark"),
                                          elevation: 10,
                                          width: 300,
                                          child: Text(
                                            "Accept",
                                            style: TextStyle(
                                              color: MihColors.getPrimaryColor(
                                                  MzansiInnovationHub.of(
                                                              context)!
                                                          .theme
                                                          .mode ==
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
                      ),
                    );
                  }),
            ],
          );
        } else {
          return MihHomeError(
            errorMessage: asyncSnapshot.hasError
                ? asyncSnapshot.error.toString()
                : "An unknown error occurred",
          );
        }
      },
    );
  }

  Widget getAction(String proPicUrl) {
    return Builder(builder: (context) {
      return MihPackageAction(
        icon: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: MihCircleAvatar(
            imageFile: proPicUrl != "" ? NetworkImage(proPicUrl) : null,
            width: 50,
            editable: false,
            fileNameController: proPicController,
            userSelectedfile: null,
            // frameColor: frameColor,
            frameColor: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            backgroundColor: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            onChange: (_) {},
          ),
          // MIHProfilePicture(
          //   profilePictureFile: widget.propicFile,
          //   proPicController: proPicController,
          //   proPic: null,
          //   width: 45,
          //   radius: 21,
          //   drawerMode: false,
          //   editable: false,
          //   frameColor: MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          //   onChange: (newProPic) {},
          // ),
        ),
        iconSize: 45,
        onTap: () {
          Scaffold.of(context).openDrawer();
          FocusScope.of(context)
              .requestFocus(FocusNode()); // Fully unfocus all fields
          // FocusScope.of(context).unfocus(); // Unfocus any text fields
        },
      );
    });
  }

  MIHAppDrawer getActionDrawer(AppUser signedInUser, String proPicUrl) {
    return MIHAppDrawer(
      signedInUser: signedInUser,
      propicFile: proPicUrl != "" ? NetworkImage(proPicUrl) : null,
    );
  }

  MihPackageTools getTools(bool isBusinessUser) {
    Map<Widget, void Function()?> temp = {};
    temp[const Icon(Icons.person)] = () {
      setState(() {
        _selcetedIndex = 0;
        _personalSelected = true;
      });
    };
    if (isBusinessUser) {
      temp[const Icon(Icons.business_center)] = () {
        setState(() {
          _selcetedIndex = 1;
          _personalSelected = false;
        });
      };
    }
    return MihPackageTools(
      tools: temp,
      selcetedIndex: _selcetedIndex,
    );
  }

  List<Widget> getToolBody(HomeArguments profData) {
    List<Widget> toolBodies = [];
    toolBodies.add(
      MihPersonalHome(
        signedInUser: profData.signedInUser,
        personalSelected: _personalSelected,
        business: profData.business,
        businessUser: profData.businessUser,
        propicFile: profData.profilePicUrl != ""
            ? NetworkImage(profData.profilePicUrl)
            : null,
        isDevActive: AppEnviroment.getEnv() == "Dev",
        isUserNew: profData.signedInUser.username == "",
      ),
    );
    if (profData.signedInUser.type != "personal") {
      toolBodies.add(
        MihBusinessHome(
          signedInUser: profData.signedInUser,
          personalSelected: _personalSelected,
          businessUser: profData.businessUser,
          business: profData.business,
          isBusinessUserNew: profData.businessUser == null,
        ),
      );
    }
    return toolBodies;
  }
}
