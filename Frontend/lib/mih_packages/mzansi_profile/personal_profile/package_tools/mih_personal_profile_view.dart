import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MihPersonalProfileView extends StatefulWidget {
  final AppUser user;
  const MihPersonalProfileView({
    super.key,
    required this.user,
  });

  @override
  State<MihPersonalProfileView> createState() => _MihPersonalProfileViewState();
}

class _MihPersonalProfileViewState extends State<MihPersonalProfileView> {
  late Future<String> futureImageUrl;
  PlatformFile? file;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureImageUrl =
        MihFileApi.getMinioFileUrl(widget.user.pro_pic_path, context);
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
    double profilePictureWidth = 150;
    return MihSingleChildScroll(
      child: Padding(
        padding: MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
            ? EdgeInsets.symmetric(horizontal: width * 0.2)
            : EdgeInsets.symmetric(horizontal: width * 0.075),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder(
                future: futureImageUrl,
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState == ConnectionState.done &&
                      asyncSnapshot.hasData) {
                    if (asyncSnapshot.requireData != "") {
                      return MihCircleAvatar(
                        imageFile: NetworkImage(asyncSnapshot.requireData),
                        width: profilePictureWidth,
                        editable: false,
                        fileNameController: TextEditingController(),
                        userSelectedfile: file,
                        frameColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        backgroundColor: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        onChange: () {},
                      );
                    } else {
                      return Icon(
                        MihIcons.iDontKnow,
                        size: profilePictureWidth,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      );
                    }
                  } else {
                    return Icon(
                      MihIcons.mihRing,
                      size: profilePictureWidth,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    );
                  }
                  // return Center(
                  //   child: MihCircleAvatar(
                  //     imageFile: propicPreview,
                  //     width: 150,
                  //     editable: false,
                  //     fileNameController: proPicController,
                  //     userSelectedfile: proPic,
                  //     frameColor: MzansiInnovationHub.of(context)!
                  //         .theme
                  //         .secondaryColor(),
                  //     backgroundColor:
                  //         MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  //     onChange: (selectedImage) {
                  //       setState(() {
                  //         proPic = selectedImage;
                  //       });
                  //     },
                  //   ),
                  // );
                }),
            FittedBox(
              child: Text(
                widget.user.username.isNotEmpty
                    ? widget.user.username
                    : "Username",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
            ),
            FittedBox(
              child: Text(
                widget.user.fname.isNotEmpty
                    ? "${widget.user.fname} ${widget.user.lname}"
                    : "Name Surname",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
            ),
            FittedBox(
              child: Text(
                widget.user.type.toUpperCase(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Center(
              child: SizedBox(
                width: 700,
                child: Text(
                  widget.user.purpose.isNotEmpty
                      ? widget.user.purpose
                      : "No Personal Mission added yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            // Center(
            //   child: MihButton(
            //     onPressed: () {
            //       // Connect with the user
            //     },
            //     buttonColor:
            //         MihColors.getGreenColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            //     width: 300,
            //     child: Text(
            //       widget.user.username.isEmpty
            //           ? "Set Up Profile"
            //           : "Edit Profile",
            //       style: TextStyle(
            //         color:
            //             MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            //         fontSize: 20,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
