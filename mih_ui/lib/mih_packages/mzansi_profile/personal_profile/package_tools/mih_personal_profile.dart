import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_profile_links.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/components/mih_add_user_profile_links_window.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/components/mih_manage_user_profile_links_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
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

  void editProfileWindow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihEditPersonalProfileWindow(),
    );
  }

  void addProfileLinksWindow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihAddUserProfileLinksWindow(),
    );
  }

  void editProfileLinksWindow() {
    showDialog(
      context: context,
      // barrierDismissible: false,
      // builder: (context) => Placeholder(),
      builder: (context) => MihManageUserProfileLinksWindow(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
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
            scrollbarOn: true,
            child: Padding(
              padding:
                  MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                      ? EdgeInsets.symmetric(horizontal: width * 0.2)
                      : EdgeInsets.symmetric(horizontal: width * 0.075),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      MihCircleAvatar(
                        imageFile: mzansiProfileProvider.userProfilePicture,
                        width: 150,
                        expandable: true,
                        editable: false,
                        fileNameController: proPicController,
                        userSelectedfile: newSelectedProPic,
                        frameColor: MihColors.secondary(),
                        backgroundColor: MihColors.primary(),
                        onChange: (selectedImage) {
                          setState(() {
                            newSelectedProPic = selectedImage;
                          });
                        },
                        key: ValueKey(mzansiProfileProvider.userProfilePicUrl),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: MihButton(
                          onPressed: () {
                            editProfileWindow();
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
                  const SizedBox(height: 10.0),
                  FittedBox(
                    child: Text(
                      mzansiProfileProvider.user!.username.isNotEmpty
                          ? mzansiProfileProvider.user!.username
                          : "username",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: MihColors.secondary(),
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
                        color: MihColors.secondary(),
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      mzansiProfileProvider.business != null
                          ? "Business".toUpperCase()
                          : "Personal".toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: MihColors.secondary(),
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
                            : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: MihColors.secondary(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  MihProfileLinks(
                    links: mzansiProfileProvider.personalLinks,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MihButton(
                        onPressed: () {
                          addProfileLinksWindow();
                        },
                        buttonColor: MihColors.green(),
                        width: mzansiProfileProvider.personalLinks.isNotEmpty
                            ? 50
                            : null,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              color: MihColors.primary(),
                            ),
                            if (mzansiProfileProvider.personalLinks.isEmpty)
                              Text(
                                "Add Links",
                                style: TextStyle(
                                  color: MihColors.primary(),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      if (mzansiProfileProvider.personalLinks.isNotEmpty)
                        MihButton(
                          onPressed: () {
                            editProfileLinksWindow();
                          },
                          buttonColor: MihColors.green(),
                          width: 50,
                          height: 50,
                          child: Icon(
                            Icons.edit,
                            color: MihColors.primary(),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
