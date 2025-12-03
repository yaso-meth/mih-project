import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_business_info_card.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:provider/provider.dart';

class MihBusinessDetailsView extends StatefulWidget {
  const MihBusinessDetailsView({
    super.key,
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
    MzansiDirectoryProvider directoryProvider =
        context.read<MzansiDirectoryProvider>();
    futureImageUrl = MihFileApi.getMinioFileUrl(
        directoryProvider.selectedBusiness!.logo_path);
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
    return Consumer<MzansiDirectoryProvider>(
      builder: (BuildContext context, MzansiDirectoryProvider directoryProvider,
          Widget? child) {
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
                    FutureBuilder(
                        future: futureImageUrl,
                        builder: (context, asyncSnapshot) {
                          if (asyncSnapshot.connectionState ==
                                  ConnectionState.done &&
                              asyncSnapshot.hasData) {
                            if (asyncSnapshot.requireData != "") {
                              return MihCircleAvatar(
                                imageFile: CachedNetworkImageProvider(
                                    asyncSnapshot.requireData),
                                width: profilePictureWidth,
                                editable: false,
                                fileNameController: TextEditingController(),
                                userSelectedfile: file,
                                frameColor: MihColors.getSecondaryColor(
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
                                        "Dark"),
                                backgroundColor: MihColors.getPrimaryColor(
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
                                        "Dark"),
                                onChange: () {},
                              );
                            } else {
                              return Icon(
                                MihIcons.iDontKnow,
                                size: profilePictureWidth,
                                color: MihColors.getSecondaryColor(
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
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
                        directoryProvider.selectedBusiness!.Name,
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
                        directoryProvider.selectedBusiness!.type,
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
                          directoryProvider
                                  .selectedBusiness!.mission_vision.isNotEmpty
                              ? directoryProvider
                                  .selectedBusiness!.mission_vision
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
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      // MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                      emptyColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      halfFilledColor: MihColors.getYellowColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      // MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                      isHalfAllowed: true,
                      initialRating:
                          directoryProvider.selectedBusiness!.rating.isNotEmpty
                              ? double.parse(
                                  directoryProvider.selectedBusiness!.rating)
                              : 0,
                      maxRating: 5,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 700,
                      child: MihBusinessCard(
                        business: directoryProvider.selectedBusiness!,
                        width: width,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
