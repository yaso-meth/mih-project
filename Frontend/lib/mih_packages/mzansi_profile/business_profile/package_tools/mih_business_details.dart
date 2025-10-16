import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_business_info_card.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_update_business_details_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:provider/provider.dart';

class MihBusinessDetails extends StatefulWidget {
  const MihBusinessDetails({
    super.key,
  });

  @override
  State<MihBusinessDetails> createState() => _MihBusinessDetailsState();
}

class _MihBusinessDetailsState extends State<MihBusinessDetails> {
  PlatformFile? newSelectedLogoPic;
  final fileNameController = TextEditingController();

  void editBizProfileWindow(
      MzansiProfileProvider mzansiProfileProvider, double width) {
    showDialog(
      context: context,
      builder: (context) => MihUpdateBusinessDetailsWindow(width: width),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(screenWidth, context),
    );
  }

  Widget getBody(double width, BuildContext context) {
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
                        imageFile: mzansiProfileProvider.businessProfilePicture,
                        width: 150,
                        editable: false,
                        fileNameController: fileNameController,
                        userSelectedfile: newSelectedLogoPic,
                        frameColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        backgroundColor: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        onChange: (selectedfile) {
                          setState(() {
                            newSelectedLogoPic = selectedfile;
                          });
                        },
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        mzansiProfileProvider.business!.Name,
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
                        mzansiProfileProvider.business!.type,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: SizedBox(
                        width: 700,
                        child: Text(
                          mzansiProfileProvider
                                  .business!.mission_vision.isNotEmpty
                              ? mzansiProfileProvider.business!.mission_vision
                              : "No Mission & Vision added yet",
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
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 700,
                      child: MihBusinessCard(
                        business: mzansiProfileProvider.business!,
                        startUpSearch: null,
                        width: width,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Center(
                      child: MihButton(
                        onPressed: () {
                          // Connect with the user
                          editBizProfileWindow(mzansiProfileProvider, width);
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
            // Positioned(
            //   right: 5,
            //   bottom: 10,
            //   child: MihFloatingMenu(
            //     animatedIcon: AnimatedIcons.menu_close,
            //     children: [
            //       SpeedDialChild(
            //         child: Icon(
            //           Icons.edit,
            //           color: MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            //         ),
            //         label: "Edit Profile",
            //         labelBackgroundColor:
            //             MihColors.getGreenColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            //         labelStyle: TextStyle(
            //           color: MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            //           fontWeight: FontWeight.bold,
            //         ),
            //         backgroundColor:
            //             MihColors.getGreenColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            //         onTap: () {
            //           editBizProfileWindow(width);
            //         },
            //       )
            //     ],
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
