import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_business_info_card.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';

class MihBusinessDetailsView extends StatefulWidget {
  final Business business;
  final String? startUpSearch;
  const MihBusinessDetailsView({
    super.key,
    required this.business,
    required this.startUpSearch,
  });

  @override
  State<MihBusinessDetailsView> createState() => _MihBusinessDetailsViewState();
}

class _MihBusinessDetailsViewState extends State<MihBusinessDetailsView> {
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
        MihFileApi.getMinioFileUrl(widget.business.logo_path, context);
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
    double profilePictureWidth = 150;
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.2)
                    : EdgeInsets.symmetric(horizontal: width * 0.075),
            child: Column(
              children: [
                FutureBuilder(
                    future: futureImageUrl,
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                              ConnectionState.done &&
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
                    }),
                // Center(
                //   child: MihCircleAvatar(
                //     imageFile: widget.logoImage,
                //     width: 150,
                //     editable: false,
                //     fileNameController: fileNameController,
                //     userSelectedfile: imageFile,
                //     frameColor:
                //         MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                //     backgroundColor:
                //         MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                //     onChange: (selectedfile) {
                //       setState(() {
                //         imageFile = selectedfile;
                //       });
                //     },
                //   ),
                // ),
                FittedBox(
                  child: Text(
                    widget.business.Name,
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
                    widget.business.type,
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
                // FittedBox(
                //   child: Text(
                //     "Mission & Vision",
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.bold,
                //       color: MzansiInnovationHub.of(context)!
                //           .theme
                //           .secondaryColor(),
                //     ),
                //   ),
                // ),
                Center(
                  child: SizedBox(
                    width: 700,
                    child: Text(
                      widget.business.mission_vision.isNotEmpty
                          ? widget.business.mission_vision
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
                const SizedBox(height: 10),
                RatingBar.readOnly(
                  size: 50,
                  alignment: Alignment.center,
                  filledIcon: Icons.star,
                  emptyIcon: Icons.star_border,
                  halfFilledIcon: Icons.star_half,
                  filledColor: MihColors.getYellowColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  // MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  emptyColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  halfFilledColor: MihColors.getYellowColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  // MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  isHalfAllowed: true,
                  initialRating: widget.business.rating.isNotEmpty
                      ? double.parse(widget.business.rating)
                      : 0,
                  maxRating: 5,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 700,
                  child: MihBusinessCard(
                    business: widget.business,
                    startUpSearch: widget.startUpSearch,
                    // businessid: widget.business.business_id,
                    // businessName: widget.business.Name,
                    // cellNumber: widget.business.contact_no,
                    // email: widget.business.bus_email,
                    // gpsLocation: widget.business.gps_location,
                    // rating: widget.business.rating.isNotEmpty
                    //     ? double.parse(widget.business.rating)
                    //     : 0,
                    // website: widget.business.website,
                    width: width,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
