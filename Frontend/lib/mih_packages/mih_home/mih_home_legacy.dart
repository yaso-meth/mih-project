import 'dart:async';
import 'dart:convert';
// import 'dart:convert';

import 'package:mzansi_innovation_hub/mih_objects/patients.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../main.dart';
import 'package:supertokens_flutter/http.dart' as http;
import "package:universal_html/html.dart" as html;

import '../../mih_apis/mih_location_api.dart';
import '../../mih_components/mih_inputs_and_buttons/mih_search_input.dart';
import '../../mih_components/mih_layout/mih_action.dart';
import 'components/mih_app_drawer.dart';
import '../../mih_components/mih_layout/mih_body.dart';
import '../../mih_components/mih_layout/mih_header.dart';
import '../../mih_components/mih_layout/mih_layout_builder.dart';
import '../../mih_components/mih_layout/mih_notification_drawer.dart';
import '../../mih_components/mih_layout/mih_tile.dart';
import '../../mih_components/mih_layout/mih_window.dart';
import '../../mih_components/mih_pop_up_messages/mih_delete_message.dart';
import '../../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_components/mih_pop_up_messages/mih_notification_message.dart';
import '../../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../../mih_components/mih_pop_up_messages/mih_warning_message.dart';
import '../../mih_env/env.dart';
import '../../mih_objects/app_user.dart';
import '../../mih_objects/arguments.dart';
import '../../mih_objects/business.dart';
import '../../mih_objects/business_user.dart';
import '../../mih_objects/notification.dart';
import '../test/test.dart';

// ignore: must_be_immutable
class MIHHomeLegacy extends StatefulWidget {
  final AppUser signedInUser;
  final BusinessUser? businessUser;
  final Business? business;
  final Patient? patient;
  final List<MIHNotification> notifications;
  final ImageProvider<Object>? propicFile;
  final bool isUserNew;
  final bool isBusinessUser;
  final bool isBusinessUserNew;
  final bool isDevActive;
  bool personalSelected;
  MIHHomeLegacy({
    super.key,
    required this.signedInUser,
    required this.businessUser,
    required this.business,
    required this.patient,
    required this.notifications,
    required this.propicFile,
    required this.isUserNew,
    required this.isBusinessUser,
    required this.isBusinessUserNew,
    required this.isDevActive,
    required this.personalSelected,
  });

  @override
  State<MIHHomeLegacy> createState() => _MIHHomeLegacyState();
}

class _MIHHomeLegacyState extends State<MIHHomeLegacy> {
  final proPicController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late List<MIHTile> persHTList = [];
  late List<MIHTile> busHTList = [];
  late List<List<MIHTile>> pbswitch;
  late List<MIHNotification> notifiList;
  late bool businessUserSwitch;
  int _selectedIndex = 0;
  String appSearch = "";
  int amount = 10;
  final baseAPI = AppEnviroment.baseApiUrl;
  // final MobileScannerController scannerController = MobileScannerController(
  //     // required options for the scanner
  //     );

  void setAppsNewPersonal(List<MIHTile> tileList) {
    ImageProvider logo = MzanziInnovationHub.of(context)!.theme.logoImage();

    if (widget.signedInUser.fname == "") {
      tileList.add(MIHTile(
        videoID: "jFV3NN65DtQ",
        onTap: () {
          Navigator.of(context).pushNamed('/mzansi-profile',
              arguments: AppProfileUpdateArguments(
                  widget.signedInUser, widget.propicFile));
        },
        tileName: "Setup Profie",
        tileIcon: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Image(image: logo),
        ),
        p: getPrim(),
        s: getSec(),
      ));
    }
  }

  void setAppsNewBusiness(List<MIHTile> tileList) {
    tileList.add(MIHTile(
      videoID: "Nfp4pVBZL78",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/business-profile/set-up',
          arguments: widget.signedInUser,
        );
      },
      tileName: "Setup Business",
      tileIcon: Icon(
        Icons.add_business_outlined,
        color: getSec(),
        size: 230,
      ),
      p: getPrim(),
      s: getSec(),
    ));
  }

  void setAppsPersonal(List<MIHTile> tileList) {
    ImageProvider logo = MzanziInnovationHub.of(context)!.theme.logoImage();
    ImageProvider aiLogo = MzanziInnovationHub.of(context)!.theme.aiLogoImage();
    tileList.add(MIHTile(
      videoID: "P2bM9eosJ_A",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mzansi-profile',
          arguments: AppProfileUpdateArguments(
            widget.signedInUser,
            widget.propicFile,
          ),
        );
      },
      tileName: "Mzansi Profile",
      tileIcon: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Image(image: logo),
      ),
      p: getPrim(),
      s: getSec(),
    ));
    tileList.add(MIHTile(
      videoID: "6l8h0sjt08k",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mzansi-wallet',
          arguments: widget.signedInUser,
        );
      },
      tileName: "Mzansi Wallet",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.wallet,
          color: getSec(),
          size: 200,
        ),
      ),
      //     Icon(
      //   Icons.info_outline,
      //   color: getSec(),
      //   size: 230,
      // ),
      p: getPrim(),
      s: getSec(),
    ));
    // print("Pat Prof: ${widget.patient}");
    if (widget.patient != null) {
      tileList.add(MIHTile(
        videoID: "NUDdoWrbXNc",
        onTap: () {
          Navigator.of(context).pushNamed('/patient-profile',
              arguments: PatientViewArguments(
                  widget.signedInUser, null, null, null, "personal"));
        },
        tileName: "Patient Profile",
        tileIcon: Center(
          child: FaIcon(
            FontAwesomeIcons.bookMedical,
            color: getSec(),
            size: 200,
          ),
        ),
        // Icon(
        //   Icons.medication,
        //   color: getSec(),
        //   size: 200,
        // ),
        p: getPrim(),
        s: getSec(),
      ));
    } else {
      tileList.add(MIHTile(
        videoID: "NUDdoWrbXNc",
        onTap: () {
          Navigator.of(context).pushNamed('/patient-profile/set-up',
              arguments: widget.signedInUser);
        },
        tileName: "Set Up Patient",
        tileIcon: Center(
          child: FaIcon(
            FontAwesomeIcons.bookMedical,
            color: getSec(),
            size: 200,
          ),
        ),
        // Icon(
        //   Icons.medication,
        //   color: getSec(),
        //   size: 200,
        // ),
        p: getPrim(),
        s: getSec(),
      ));
    }
    tileList.add(MIHTile(
      videoID: "dYuLqZWzMnM",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mzansi-ai',
          arguments: widget.signedInUser,
        );
      },
      tileName: "Mzansi AI",
      tileIcon: Center(
        child: SizedBox(
          width: 225,
          child: Image(image: aiLogo),
        ),
      ),
      // Icon(
      //   Icons.medication,
      //   color: getSec(),
      //   size: 200,
      // ),
      p: getPrim(),
      s: getSec(),
    ));
    tileList.add(MIHTile(
      videoID: "nfzhJFY_W4Y",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/calendar',
          arguments: CalendarArguments(
            widget.signedInUser,
            true,
            widget.business,
            null,
          ),
        );
      },
      tileName: "Calendar",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.calendarDays,
          color: getSec(),
          size: 200,
        ),
      ),
      //     Icon(
      //   Icons.calendar_month,
      //   color: getSec(),
      //   size: 230,
      // ),
      p: getPrim(),
      s: getSec(),
    ));

    tileList.add(MIHTile(
      videoID: "woQ5hND5EaU",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/calculator',
          arguments: widget.personalSelected,
        );
      },
      tileName: "Calculator",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.calculator,
          color: getSec(),
          size: 200,
        ),
      ),
      //     Icon(
      //   Icons.info_outline,
      //   color: getSec(),
      //   size: 230,
      // ),
      p: getPrim(),
      s: getSec(),
    ));

    tileList.add(MIHTile(
      videoID: "",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mih-access',
          arguments: widget.signedInUser,
        );
      },
      tileName: "MIH Access",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.userCheck,
          color: getSec(),
          size: 170,
        ),
      ),
      // Icon(
      //   Icons.check_box_outlined,
      //   color: getSec(),
      //   size: 200,
      // ),
      p: getPrim(),
      s: getSec(),
    ));

    tileList.add(MIHTile(
      videoID: "hbKhlmY_56U",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/about',
          arguments: 0,
        );
      },
      tileName: "About MIH",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.circleInfo,
          color: getSec(),
          size: 200,
        ),
      ),
      //     Icon(
      //   Icons.info_outline,
      //   color: getSec(),
      //   size: 230,
      // ),
      p: getPrim(),
      s: getSec(),
    ));
  }

  void setAppsBusiness(List<MIHTile> tileList) {
    ImageProvider aiLogo = MzanziInnovationHub.of(context)!.theme.aiLogoImage();
    tileList.add(MIHTile(
      videoID: "NWyJZq2ZYOM",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/business-profile/manage',
          arguments: BusinessArguments(
            widget.signedInUser,
            widget.businessUser,
            widget.business,
          ),
        );
      },
      tileName: "Biz Profile",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.buildingUser,
          color: getSec(),
          size: 165,
        ),
      ),
      // Icon(
      //   Icons.business,
      //   color: getSec(),
      //   size: 230,
      // ),
      p: getPrim(),
      s: getSec(),
    ));
    // tileList.add(MIHTile(
    //   onTap: () {
    //     Navigator.of(context).pushNamed(
    //       '/mih-access',
    //       arguments: widget.signedInUser,
    //     );
    //   },
    //   tileName: "Access",
    //   tileIcon: Icon(
    //     Icons.check_box_outlined,
    //     color: getSec(),
    //     size: 200,
    //   ),
    //   p: getPrim(),
    //   s: getSec(),
    // ));
    tileList.add(MIHTile(
      videoID: "D6q2qIavoiY",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/patient-manager',
          arguments: PatManagerArguments(
            widget.signedInUser,
            widget.personalSelected,
            widget.business,
            widget.businessUser,
          ),
        );
      },
      tileName: "Pat Manager",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.bookMedical,
          color: getSec(),
          size: 200,
        ),
      ),
      // Icon(
      //   Icons.medication,
      //   color: getSec(),
      //   size: 230,
      // ),
      p: getPrim(),
      s: getSec(),
    ));

    tileList.add(MIHTile(
      videoID: "nfzhJFY_W4Y",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/calendar',
          arguments: CalendarArguments(
            widget.signedInUser,
            false,
            widget.business,
            widget.businessUser,
          ),
        );
      },
      tileName: "Calendar",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.calendarDays,
          color: getSec(),
          size: 200,
        ),
      ),
      //     Icon(
      //   Icons.calendar_month,
      //   color: getSec(),
      //   size: 230,
      // ),
      p: getPrim(),
      s: getSec(),
    ));

    tileList.add(MIHTile(
      videoID: "dYuLqZWzMnM",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mzansi-ai',
          arguments: widget.signedInUser,
        );
      },
      tileName: "Mzansi AI",
      tileIcon: Center(
        child: SizedBox(
          width: 225,
          child: Image(image: aiLogo),
        ),
      ),
      // Icon(
      //   Icons.medication,
      //   color: getSec(),
      //   size: 200,
      // ),
      p: getPrim(),
      s: getSec(),
    ));

    tileList.add(MIHTile(
      videoID: "woQ5hND5EaU",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/calculator',
          arguments: widget.personalSelected,
        );
      },
      tileName: "Calculator",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.calculator,
          color: getSec(),
          size: 200,
        ),
      ),
      //     Icon(
      //   Icons.info_outline,
      //   color: getSec(),
      //   size: 230,
      // ),
      p: getPrim(),
      s: getSec(),
    ));

    tileList.add(MIHTile(
      videoID: "hbKhlmY_56U",
      onTap: () {
        Navigator.of(context).pushNamed(
          '/about',
          arguments: 0,
        );
      },
      tileName: "About MIH",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.circleInfo,
          color: getSec(),
          size: 200,
        ),
      ),
      //     Icon(
      //   Icons.info_outline,
      //   color: getSec(),
      //   size: 230,
      // ),
      p: getPrim(),
      s: getSec(),
    ));
  }

  void setAppsDev(List<MIHTile> tileList) {
    if (AppEnviroment.getEnv() == "Dev") {
      tileList.add(MIHTile(
        videoID: "",
        onTap: () {
          Navigator.of(context).pushNamed(
            '/home-dev',
            //arguments: widget.signedInUser,
          );
        },
        tileName: "Home - Dev",
        tileIcon: Center(
          child: Icon(
            Icons.warning,
            color: getSec(),
            size: 230,
          ),
        ),
        //     Icon(
        //   Icons.info_outline,
        //   color: getSec(),
        //   size: 230,
        // ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(MIHTile(
        videoID: "",
        onTap: () {
          Navigator.of(context).pushNamed(
            '/package-dev',
            //arguments: widget.signedInUser,
          );
        },
        tileName: "Package - Dev",
        tileIcon: Center(
          child: Icon(
            Icons.warning,
            color: getSec(),
            size: 230,
          ),
        ),
        //     Icon(
        //   Icons.info_outline,
        //   color: getSec(),
        //   size: 230,
        // ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(MIHTile(
        videoID: "",
        onTap: () {
          Navigator.of(context).pushNamed(
            '/terms-of-service',
            //arguments: widget.signedInUser,
          );
        },
        tileName: "TOS - Dev",
        tileIcon: Center(
          child: Icon(
            Icons.design_services,
            color: getSec(),
            size: 230,
          ),
        ),
        //     Icon(
        //   Icons.info_outline,
        //   color: getSec(),
        //   size: 230,
        // ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(MIHTile(
        videoID: "",
        onTap: () {
          Navigator.of(context).pushNamed(
            '/privacy-policy',
            //arguments: widget.signedInUser,
          );
        },
        tileName: "Policy - Dev",
        tileIcon: Center(
          child: Icon(
            Icons.policy,
            color: getSec(),
            size: 230,
          ),
        ),
        //     Icon(
        //   Icons.info_outline,
        //   color: getSec(),
        //   size: 230,
        // ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(MIHTile(
        onTap: () {
          TextEditingController cardNumberController = TextEditingController();
          Navigator.of(context).pushNamed(
            '/scanner',
            arguments: cardNumberController,
          );
          print(cardNumberController.text);
        },
        tileName: "Scanner - Dev",
        tileIcon: Icon(
          Icons.camera_alt_outlined,
          color: getSec(),
          size: 230,
        ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(MIHTile(
        onTap: () {
          showDialog(
            barrierColor: const Color(0x01000000),
            context: context,
            builder: (context) {
              return const MIHTest();
            },
          );
        },
        tileName: "video - Dev",
        tileIcon: Icon(
          Icons.video_file,
          color: getSec(),
          size: 230,
        ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(MIHTile(
        onTap: () {
          showDialog(
            barrierColor: const Color(0x01000000),
            context: context,
            builder: (context) {
              return Builder(builder: (context) {
                return MIHNotificationMessage(
                  arguments: NotificationArguments(
                    "Testing",
                    "Testing the new MIH Notification",
                    () {
                      Navigator.of(context).pop();
                      //Scaffold.of(context).openEndDrawer();
                    },
                  ),
                );
              });
            },
          );
        },
        tileName: "Notify - Dev",
        tileIcon: Icon(
          Icons.notifications,
          color: getSec(),
          size: 230,
        ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(MIHTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return const Mihloadingcircle();
            },
          );
        },
        tileName: "Loading - Dev",
        tileIcon: Icon(
          Icons.change_circle,
          color: getSec(),
          size: 230,
        ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(MIHTile(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/business-profile/set-up',
            arguments: widget.signedInUser,
          );
        },
        tileName: "Setup Bus - Dev",
        tileIcon: Icon(
          Icons.add_business_outlined,
          color: getSec(),
          size: 230,
        ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(MIHTile(
        onTap: () {
          Navigator.of(context).pushNamed('/patient-profile/set-up',
              arguments: widget.signedInUser);
        },
        tileName: "Add Pat - Dev",
        tileIcon: Icon(
          Icons.add_circle_outline,
          color: getSec(),
          size: 230,
        ),
        p: getPrim(),
        s: getSec(),
      ));

      tileList.add(MIHTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              // return const MIHWarningMessage(warningType: "No Access");
              return const MIHWarningMessage(warningType: "Expired Access");
            },
          );
        },
        tileName: "Warn - Dev",
        tileIcon: Icon(
          Icons.warning_amber_rounded,
          color: getSec(),
          size: 230,
        ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(MIHTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              // return const MIHErrorMessage(errorType: "Input Error");
              // return const MIHErrorMessage(errorType: "Password Requirements");
              // return const MIHErrorMessage(errorType: "Invalid Username");
              // return const MIHErrorMessage(errorType: "Invalid Email");
              // return const MIHErrorMessage(errorType: "User Exists");
              // return const MIHErrorMessage(errorType: "Password Match");
              // return const MIHErrorMessage(errorType: "Invalid Credentials");
              return const MIHErrorMessage(errorType: "Internet Connection");
            },
          );
        },
        tileName: "Error - Dev",
        tileIcon: Icon(
          Icons.error_outline_outlined,
          color: getSec(),
          size: 230,
        ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(MIHTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return const MIHSuccessMessage(
                  successType: "Success",
                  successMessage:
                      "Congratulations! Your account has been created successfully. You are log in and can start exploring.\n\nPlease note: more apps will appear once you update your profile.");
            },
          );
        },
        tileName: "Success - Dev",
        tileIcon: Icon(
          Icons.check_circle_outline_outlined,
          color: getSec(),
          size: 230,
        ),
        p: getPrim(),
        s: getSec(),
      ));

      tileList.add(MIHTile(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              // return MIHDeleteMessage(deleteType: "Note", onTap: () {});
              return MIHDeleteMessage(deleteType: "File", onTap: () {});
            },
          );
        },
        tileName: "Delete - Dev",
        tileIcon: Icon(
          Icons.delete_forever_outlined,
          color: getSec(),
          size: 230,
        ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(MIHTile(
        onTap: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              // return const MIHErrorMessage(errorType: "Input Error");
              // return const MIHErrorMessage(errorType: "Password Requirements");
              // return const MIHErrorMessage(errorType: "Invalid Username");
              // return const MIHErrorMessage(errorType: "Invalid Email");
              // return const MIHErrorMessage(errorType: "User Exists");
              // return const MIHErrorMessage(errorType: "Password Match");
              // return const MIHErrorMessage(errorType: "Invalid Credentials");
              return MIHWindow(
                fullscreen: false,
                windowTitle:
                    "Test Window title that is too large for mobile devices",
                windowBody: const [
                  SizedBox(
                    height: 250,
                  )
                ],
                windowTools: [
                  IconButton(
                    onPressed: () {
                      //deleteFilePopUp(filePath, fileID);
                    },
                    icon: Icon(
                      Icons.delete,
                      size: 35,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      //deleteFilePopUp(filePath, fileID);
                    },
                    icon: Icon(
                      Icons.wallet,
                      size: 35,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ],
                onWindowTapClose: () {
                  Navigator.pop(context);
                },
              );
            },
          );
        },
        tileName: "Window - Dev",
        tileIcon: Icon(
          Icons.window,
          color: getSec(),
          size: 230,
        ),
        p: getPrim(),
        s: getSec(),
      ));
      tileList.add(MIHTile(
        onTap: () {
          MIHLocationAPI().getGPSPosition(context).then((position) {
            if (position != null) {
              print(position);
              print(
                  "Distance: ${MIHLocationAPI().getDistanceInMeaters(position, position)}m");
            }
          });
        },
        tileName: "Location - Dev",
        tileIcon: Icon(
          Icons.location_pin,
          color: getSec(),
          size: 230,
        ),
        p: getPrim(),
        s: getSec(),
      ));
    }
  }

  List<MIHTile> searchApp(List<MIHTile> appList, String searchString) {
    if (searchString == "") {
      return appList;
    } else {
      List<MIHTile> temp = [];
      for (var item in appList) {
        if (item.tileName.toLowerCase().contains(appSearch.toLowerCase())) {
          temp.add(item);
        }
      }
      return temp;
    }
  }

  List<List<MIHTile>> setApps(
      List<MIHTile> personalTileList, List<MIHTile> businessTileList) {
    if (widget.isUserNew) {
      setAppsNewPersonal(personalTileList);
    } else if (!widget.isBusinessUser) {
      setAppsPersonal(personalTileList);
    } else if (widget.isBusinessUserNew) {
      setAppsPersonal(personalTileList);
      setAppsNewBusiness(businessTileList);
    } else {
      setAppsPersonal(personalTileList);
      setAppsBusiness(businessTileList);
    }
    if (widget.isDevActive) {
      setAppsDev(personalTileList);
      setAppsDev(businessTileList);
    }
    return [personalTileList, businessTileList];
  }

  Color getPrim() {
    return MzanziInnovationHub.of(context)!.theme.secondaryColor();
  }

  Color getSec() {
    return MzanziInnovationHub.of(context)!.theme.primaryColor();
  }

  bool isBusinessUser(AppUser signedInUser) {
    if (signedInUser.type == "personal") {
      return false;
    } else {
      return true;
    }
  }

  String getHeading(int index) {
    if (index == 0) {
      return "Personal Apps";
    } else {
      return "Business Apps";
    }
  }

  void onDragStart(DragStartDetails startDrag) {
    Scaffold.of(context).openDrawer();
    print(startDrag.globalPosition.dx);
  }

  Widget getActionButton() {
    return Builder(builder: (context) {
      return MIHAction(
        icon: Padding(
          padding: const EdgeInsets.only(left: 5.0), child: Placeholder(),
          // MIHProfilePicture(
          //   profilePictureFile: widget.propicFile,
          //   proPicController: proPicController,
          //   proPic: null,
          //   width: 45,
          //   radius: 21,
          //   drawerMode: false,
          //   editable: false,
          //   frameColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          //   onChange: (newProPic) {},
          // ),
        ),
        // const Icon(Icons.apps),
        iconSize: 45,
        onTap: () {
          setState(() {
            appSearch = "";
            searchController.clear();
          });
          //key.currentState.o
          Scaffold.of(context).openDrawer();
        },
      );
    });
  }

  Widget getSecondaryActionButton() {
    Widget notIIcon;
    if (hasNewNotifications()) {
      notIIcon = Stack(
        children: [
          const Icon(Icons.notifications),
          Positioned(
            right: 0,
            top: 0,
            child: Icon(
              Icons.circle,
              size: 10,
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
            ),
          )
        ],
      );
    } else {
      notIIcon = const Icon(Icons.notifications);
    }
    return Builder(builder: (context) {
      return MIHAction(
        icon: notIIcon,
        iconSize: 35,
        onTap: () {
          setState(() {
            appSearch = "";
            searchController.clear();
          });
          //key.currentState.o
          Scaffold.of(context).openEndDrawer();
        },
      );
    });
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "MIH",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  MIHBody getBody(double width, double height) {
    return MIHBody(
      borderOn: false,
      bodyItems: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 4,
              child: KeyboardListener(
                focusNode: _focusNode,
                autofocus: true,
                onKeyEvent: (event) async {
                  if (event is KeyDownEvent &&
                      event.logicalKey == LogicalKeyboardKey.enter) {
                    setState(() {
                      appSearch = searchController.text;
                    });
                  }
                },
                child: SizedBox(
                  child: MIHSearchField(
                    controller: searchController,
                    hintText: "Search Mzansi Packages",
                    required: false,
                    editable: true,
                    onTap: () {
                      setState(() {
                        appSearch = searchController.text;
                      });
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: IconButton(
                //padding: const EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    appSearch = "";
                    searchController.clear();
                  });
                },
                icon: const Icon(
                  Icons.filter_alt_off,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.only(
            left: width / 13,
            right: width / 13,
            bottom: height / 15,
            //top: 20,
          ),
          // shrinkWrap: true,
          itemCount: searchApp(pbswitch[_selectedIndex], appSearch).length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisSpacing: 15, maxCrossAxisExtent: 200),
          itemBuilder: (context, index) {
            return searchApp(pbswitch[_selectedIndex], appSearch)[index];
          },
        ),
      ],
    );
  }

  MIHAppDrawer getActionDrawer() {
    return MIHAppDrawer(
      signedInUser: widget.signedInUser,
      propicFile: widget.propicFile,
    );
  }

  MIHNotificationDrawer getSecondaryActionDrawer() {
    return MIHNotificationDrawer(
      signedInUser: widget.signedInUser,
      notifications: widget.notifications,
    );
  }

  Widget getBottomNavBar() {
    return Visibility(
      visible: isBusinessUser(widget.signedInUser),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 10.0, right: 10.0, bottom: 10.0, top: 0),
        child: GNav(
          //hoverColor: Colors.lightBlueAccent,
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          iconSize: 35.0,
          activeColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          tabBackgroundColor:
              MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          //gap: 20,
          //padding: EdgeInsets.all(15),
          tabs: [
            GButton(
              icon: Icons.perm_identity,
              text: "Personal",
              onPressed: () {
                setState(() {
                  widget.personalSelected = true;
                  _selectedIndex = 0;
                });
                print("personal selected: ${widget.personalSelected}");
              },
            ),
            GButton(
              icon: Icons.business_center,
              text: "Business",
              onPressed: () {
                setState(() {
                  widget.personalSelected = false;
                  _selectedIndex = 1;
                });
                print("personal selected: ${widget.personalSelected}");
              },
            ),
          ],
          selectedIndex: _selectedIndex,
        ),
      ),
    );
  }

  bool hasNewNotifications() {
    //print(widget.notifications.toString());
    if (notifiList.map((item) => item.notification_read).contains("No")) {
      //print("New Notification Available");

      return true;
    } else {
      //print("No New Notification Available");
      return false;
    }
  }

  Future<void> refreshNotifications() async {
    if (MzanziInnovationHub.of(context)!.theme.getPlatform() == "Web") {
      html.window.location.reload();
    } else {
      var responseNotification = await http.get(Uri.parse(
          "$baseAPI/notifications/${widget.signedInUser.app_id}?amount=$amount"));
      List<MIHNotification> notifi;
      if (responseNotification.statusCode == 200) {
        String body = responseNotification.body;
        // var decodedData = jsonDecode(body);
        // MIHNotification notifications = MIHNotification.fromJson(decodedData);

        Iterable l = jsonDecode(body);
        //print("Here2");
        List<MIHNotification> notifications = List<MIHNotification>.from(
            l.map((model) => MIHNotification.fromJson(model)));
        notifi = notifications;
      } else {
        notifi = [];
      }
      setState(() {
        notifiList = notifi;
      });
      notificationPopUp();
    }
  }

  void notificationPopUp() {
    if (hasNewNotifications()) {
      showDialog(
        barrierColor: const Color(0x01000000),
        context: context,
        builder: (context) {
          return MIHNotificationMessage(
            arguments: NotificationArguments(
              "Unread Notifications",
              "You have unread notifications waiting for you.",
              () {
                Navigator.of(context).pop();
                //Scaffold.of(context).openEndDrawer();
              },
            ),
          );
        },
      );
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    proPicController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      pbswitch = setApps(persHTList, busHTList);
      businessUserSwitch = false;
      notifiList = widget.notifications;
    });
    if (!widget.personalSelected) {
      setState(() {
        _selectedIndex = 1;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationPopUp();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double width = size.width;
    final double height = size.height;

    return SwipeDetector(
      onSwipeLeft: (offset) {
        if (_selectedIndex == 0) {
          setState(() {
            _selectedIndex = 1;
          });
        }
        //print("swipe left");
      },
      onSwipeRight: (offset) {
        if (_selectedIndex == 1) {
          setState(() {
            _selectedIndex = 0;
          });
        }
        //print("swipe right");
      },
      child: MIHLayoutBuilder(
        actionButton: getActionButton(),
        header: getHeader(),
        secondaryActionButton: getSecondaryActionButton(),
        body: getBody(width, height),
        actionDrawer: getActionDrawer(),
        secondaryActionDrawer: getSecondaryActionDrawer(),
        bottomNavBar: getBottomNavBar(),
        pullDownToRefresh: true,
        onPullDown: refreshNotifications,
      ),
    );
  }
}
