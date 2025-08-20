import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tools.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/components/mih_app_drawer.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/mih_home_error.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/package_tools/mih_business_home.dart';
import 'package:mzansi_innovation_hub/mih_packages/mih_home/package_tools/mih_personal_home.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_service_calls.dart';

// ignore: must_be_immutable
class MihHome extends StatefulWidget {
  // final AppUser signedInUser;
  // final BusinessUser? businessUser;
  // final Business? business;
  // final Patient? patient;
  // final List<MIHNotification> notifications;
  // final ImageProvider<Object>? propicFile;
  // final bool isUserNew;
  // final bool isBusinessUser;
  // final bool isBusinessUserNew;
  // final bool isDevActive;
  final bool personalSelected;
  const MihHome({
    super.key,
    // required this.signedInUser,
    // required this.businessUser,
    // required this.business,
    // required this.patient,
    // required this.notifications,
    // required this.propicFile,
    // required this.isUserNew,
    // required this.isBusinessUser,
    // required this.isBusinessUserNew,
    // required this.isDevActive,
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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    profileData = MIHApiCalls().getProfile(10, context);
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
              message: "Getting your Data...",
            ),
          );
        } else if (asyncSnapshot.connectionState == ConnectionState.done &&
            asyncSnapshot.hasData) {
          return MihPackage(
            appActionButton: getAction(asyncSnapshot.data!.profilePicUrl),
            appTools:
                getTools(asyncSnapshot.data!.signedInUser.type != "personal"),
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
