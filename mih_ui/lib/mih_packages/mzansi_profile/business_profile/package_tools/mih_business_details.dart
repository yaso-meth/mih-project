import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_business_info_card_v2.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_update_business_details_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
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
      barrierDismissible: false,
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
      backgroundColor: MihColors.primary(),
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
              scrollbarOn: true,
              child: Padding(
                padding: MzansiInnovationHub.of(context)!.theme.screenType ==
                        "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.2)
                    : EdgeInsets.symmetric(horizontal: width * 0),
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          MihCircleAvatar(
                            key: UniqueKey(),
                            imageFile:
                                mzansiProfileProvider.businessProfilePicture,
                            width: 150,
                            expandable: true,
                            editable: false,
                            fileNameController: fileNameController,
                            userSelectedfile: newSelectedLogoPic,
                            frameColor: MihColors.secondary(),
                            backgroundColor: MihColors.primary(),
                            onChange: (selectedfile) {
                              setState(() {
                                newSelectedLogoPic = selectedfile;
                              });
                            },
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: MihButton(
                              onPressed: () {
                                // editProfileWindow(width);
                                editBizProfileWindow(
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
                    FittedBox(
                      child: Text(
                        mzansiProfileProvider.business!.Name,
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: MihColors.secondary(),
                        ),
                      ),
                    ),
                    FittedBox(
                      child: Text(
                        mzansiProfileProvider.business!.type,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: MihColors.secondary(),
                        ),
                      ),
                    ),
                    RatingBar.readOnly(
                      size: 50,
                      alignment: Alignment.center,
                      filledIcon: Icons.star,
                      emptyIcon: Icons.star_border,
                      halfFilledIcon: Icons.star_half,
                      filledColor: MihColors.yellow(),
                      // MihColors.primary(),
                      emptyColor: MihColors.secondary(),
                      halfFilledColor: MihColors.yellow(),
                      // MihColors.primary(),
                      isHalfAllowed: true,
                      initialRating: mzansiProfileProvider
                              .business!.rating.isNotEmpty
                          ? double.parse(mzansiProfileProvider.business!.rating)
                          : 0,
                      maxRating: 5,
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
                            color: MihColors.secondary(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MihBusinessCardV2(
                      business: mzansiProfileProvider.business!,
                      // startUpSearch: null,
                      width: width,
                      viewMode: false,
                    ),
                    const SizedBox(height: 30.0),
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
