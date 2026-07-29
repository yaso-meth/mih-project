import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_image_display.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_update_my_business_user_details.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
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
      color: MihColors.primary(),
    );
    TextStyle subtitleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: MihColors.primary(),
    );
    TextStyle subtitleHeadingStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: MihColors.primary(),
    );
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "Employee Info Card",
      onWindowTapClose: null,
      backgroundColor: MihColors.secondary(),
      foregroundColor: MihColors.primary(),
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
      backgroundColor: MihColors.primary(),
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
              scrollbarOn: true,
              child: Padding(
                padding: MzansiInnovationHub.of(context)!.theme.screenType ==
                        "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.2)
                    : EdgeInsets.symmetric(horizontal: width * 0.075),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          MihCircleAvatar(
                            imageFile: mzansiProfileProvider.userProfilePicture,
                            width: 150,
                            expandable: true,
                            editable: false,
                            fileNameController: fileNameController,
                            userSelectedfile: userPicFile,
                            frameColor: MihColors.secondary(),
                            backgroundColor: MihColors.primary(),
                            onChange: (_) {},
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: MihButton(
                              onPressed: () {
                                editBizUserProfileWindow(
                                    mzansiProfileProvider, width);
                              },
                              buttonColor: MihColors.green(),
                              width: 35,
                              height: 35,
                              child: Icon(
                                Icons.edit,
                                color: MihColors.primary(),
                              ),
                            ),
                          ),
                        ],
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
                      child: MihImageDisplay(
                        imageFile: mzansiProfileProvider.businessUserSignature,
                        height: 200,
                        expandable: true,
                        editable: false,
                        blur: mzansiProfileProvider.hideBusinessUserDetails,
                      ),
                    ),
                    const SizedBox(height: 20),
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
                    ? MihColors.green()
                    : MihColors.red(),
                child: Icon(
                  mzansiProfileProvider.hideBusinessUserDetails
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: MihColors.primary(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
