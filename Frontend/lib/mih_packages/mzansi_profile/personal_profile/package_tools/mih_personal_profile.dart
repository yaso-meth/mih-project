import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/components/mih_edit_personal_profile_window.dart';
import 'package:provider/provider.dart';

class MihPersonalProfile extends StatefulWidget {
  const MihPersonalProfile({super.key});

  @override
  State<MihPersonalProfile> createState() => _MihPersonalProfileState();
}

class _MihPersonalProfileState extends State<MihPersonalProfile> {
  TextEditingController proPicController = TextEditingController();
  PlatformFile? newSelectedProPic;

  void editProfileWindow(double width) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer<MzansiProfileProvider>(
        builder: (BuildContext context,
            MzansiProfileProvider mzansiProfileProvider, Widget? child) {
          return MihEditPersonalProfileWindow();
        },
      ),
    );
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
        if (mzansiProfileProvider.user == null) {
          //Change to new user flow
          return Center(
            child: Mihloadingcircle(),
          );
        } else {
          return MihSingleChildScroll(
            child: Padding(
              padding:
                  MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                      ? EdgeInsets.symmetric(horizontal: width * 0.2)
                      : EdgeInsets.symmetric(horizontal: width * 0.075),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: MihCircleAvatar(
                      imageFile: mzansiProfileProvider.userProfilePicture,
                      width: 150,
                      editable: false,
                      fileNameController: proPicController,
                      userSelectedfile: newSelectedProPic,
                      frameColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      backgroundColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      onChange: (selectedImage) {
                        setState(() {
                          newSelectedProPic = selectedImage;
                        });
                      },
                      key: ValueKey(mzansiProfileProvider.userProfilePicUrl),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      mzansiProfileProvider.user!.username.isNotEmpty
                          ? mzansiProfileProvider.user!.username
                          : "username",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      mzansiProfileProvider.user!.fname.isNotEmpty
                          ? "${mzansiProfileProvider.user!.fname} ${mzansiProfileProvider.user!.lname}"
                          : "Name Surname",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      mzansiProfileProvider.user!.type == "business"
                          ? "Business".toUpperCase()
                          : "Personal".toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: SizedBox(
                      width: 700,
                      child: Text(
                        mzansiProfileProvider.user!.purpose.isNotEmpty
                            ? mzansiProfileProvider.user!.purpose
                            : "No Personal Mission added yet",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Center(
                    child: MihButton(
                      onPressed: () {
                        // Connect with the user
                        editProfileWindow(width);
                      },
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        mzansiProfileProvider.user!.username.isEmpty
                            ? "Set Up Profile"
                            : "Edit Profile",
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
          );
        }
      },
    );
  }
}
