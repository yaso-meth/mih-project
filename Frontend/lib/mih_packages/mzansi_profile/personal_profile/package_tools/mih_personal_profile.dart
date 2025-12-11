import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_profile_links.dart';
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

  List<ProfileLink> getTempLinks() {
    return [
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Youtube",
        web_link: "https://www.youtube.com/@MzansiInnovationHub",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Threads",
        web_link: "https://www.threads.com/@mzansi.innovation.hub",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "TikTok",
        web_link: "https://www.tiktok.com/@mzansiinnovationhub",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "WhatsApp",
        web_link: "https://whatsapp.com/channel/0029Vax3INCIyPtMn8KgeM2F",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Twitch",
        web_link: "https://www.twitch.tv/mzansiinnovationhub",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Instagram",
        web_link: "https://www.instagram.com/mzansi.innovation.hub/",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "X",
        web_link: "https://x.com/mzansi_inno_hub",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "LinkedIn",
        web_link: "https://www.linkedin.com/in/yasien-meth-172352108/",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Facebook",
        web_link: "https://www.facebook.com/profile.php?id=61565345762136",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Reddit",
        web_link: "https://www.reddit.com/r/Mzani_Innovation_Hub/",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Discord",
        web_link: "https://discord.gg/ZtTZYd5d",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "My App",
        web_link: "https://app.mzansi-innovation-hub.co.za/about",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
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
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: MihButton(
                          onPressed: () {
                            editProfileWindow(width);
                          },
                          buttonColor: MihColors.getGreenColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          width: 35,
                          height: 35,
                          child: Icon(
                            Icons.edit,
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
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
                            : "",
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
                  const SizedBox(height: 15.0),
                  Stack(
                    children: [
                      MihProfileLinks(
                        // links: mzansiProfileProvider.personalLinks,
                        links: getTempLinks(),
                        buttonSize: 80,
                        paddingOn: false,
                      ),
                      Positioned(
                        top: 5,
                        left: 5,
                        child: MihButton(
                          onPressed: () {
                            editProfileWindow(width);
                          },
                          buttonColor: MihColors.getGreenColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          width: 35,
                          height: 35,
                          child: Icon(
                            Icons.link,
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                          ),
                        ),
                      ),
                    ],
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
