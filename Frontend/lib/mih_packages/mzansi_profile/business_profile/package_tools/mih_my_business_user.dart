import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_image_display.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_update_my_business_user_details.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:provider/provider.dart';

class MihMyBusinessUser extends StatefulWidget {
  const MihMyBusinessUser({
    super.key,
  });

  @override
  State<MihMyBusinessUser> createState() => _MihMyBusinessUserState();
}

class _MihMyBusinessUserState extends State<MihMyBusinessUser> {
  final fileNameController = TextEditingController();
  final signtureController = TextEditingController();
  PlatformFile? userPicFile;
  PlatformFile? newSelectedSignaturePic;

  void editBizUserProfileWindow(
      MzansiProfileProvider mzansiProfileProvider, double width) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => MihUpdateMyBusinessUserDetails(),
    );
  }

  String getDisplayText(
      MzansiProfileProvider profileProvider, String originalText) {
    int textLength = originalText.length >= 13 ? 13 : 6;
    String displayText = "";
    if (profileProvider.hideBusinessUserDetails) {
      for (int i = 0; i < textLength; i++) {
        displayText += "●";
      }
    } else {
      displayText = originalText;
    }
    return displayText;
  }

  Widget buildEmployeeInfoCard(MzansiProfileProvider profileProvider) {
    TextStyle titleStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
    TextStyle subtitleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
    TextStyle subtitleHeadingStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "Employee Info Card",
      onWindowTapClose: null,
      backgroundColor: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      foregroundColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      windowBody: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${profileProvider.user!.fname} ${profileProvider.user!.lname}",
                      style: titleStyle,
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Title: ",
                            style: subtitleHeadingStyle,
                          ),
                          TextSpan(
                            text: profileProvider.businessUser!.title,
                            style: subtitleStyle,
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: "Access: ",
                            style: subtitleHeadingStyle,
                          ),
                          TextSpan(
                            text: getDisplayText(profileProvider,
                                profileProvider.businessUser!.access),
                            style: subtitleStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void setControllers() {
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    fileNameController.text =
        mzansiProfileProvider.user!.pro_pic_path.split("/").last;
    signtureController.text =
        mzansiProfileProvider.businessUser!.sig_path.split("/").last;
  }

  @override
  void dispose() {
    super.dispose();
    fileNameController.dispose();
    signtureController.dispose();
    userPicFile = null;
    newSelectedSignaturePic = null;
  }

  @override
  void initState() {
    super.initState();
    setControllers();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(screenWidth),
    );
  }

  Widget getBody(double width) {
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        return Stack(
          children: [
            MihSingleChildScroll(
              child: Padding(
                padding: MzansiInnovationHub.of(context)!.theme.screenType ==
                        "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.2)
                    : EdgeInsets.symmetric(horizontal: width * 0.075),
                child: Column(
                  children: [
                    Center(
                      child: MihCircleAvatar(
                        imageFile: mzansiProfileProvider.userProfilePicture,
                        width: 150,
                        editable: false,
                        fileNameController: fileNameController,
                        userSelectedfile: userPicFile,
                        frameColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        backgroundColor: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        onChange: (_) {},
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildEmployeeInfoCard(mzansiProfileProvider),
                    const SizedBox(height: 10),
                    Container(
                      width: 300,
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Signature:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: mzansiProfileProvider.hideBusinessUserDetails
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(300 * 0.1),
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                    sigmaX: 15.0, sigmaY: 15.0),
                                child: MihImageDisplay(
                                  key: UniqueKey(),
                                  imageFile: mzansiProfileProvider
                                      .businessUserSignature,
                                  width: 300,
                                  height: 200,
                                  editable: false,
                                  fileNameController: signtureController,
                                  userSelectedfile: newSelectedSignaturePic,
                                  onChange: (selectedFile) {},
                                ),
                              ),
                            )
                          : MihImageDisplay(
                              key: UniqueKey(),
                              imageFile:
                                  mzansiProfileProvider.businessUserSignature,
                              width: 300,
                              height: 200,
                              editable: false,
                              fileNameController: signtureController,
                              userSelectedfile: newSelectedSignaturePic,
                              onChange: (selectedFile) {},
                            ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: MihButton(
                        onPressed: () {
                          editBizUserProfileWindow(
                              mzansiProfileProvider, width);
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "Edit Profile",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 5,
              top: 5,
              child: MihButton(
                width: 40,
                height: 40,
                onPressed: () {
                  mzansiProfileProvider.setHideBusinessUserDetails(
                      !mzansiProfileProvider.hideBusinessUserDetails);
                },
                buttonColor: mzansiProfileProvider.hideBusinessUserDetails
                    ? MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark")
                    : MihColors.getRedColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                child: Icon(
                  mzansiProfileProvider.hideBusinessUserDetails
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
