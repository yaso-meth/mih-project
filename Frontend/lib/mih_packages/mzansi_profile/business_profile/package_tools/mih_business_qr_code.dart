import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:url_launcher/url_launcher.dart';

class MihBusinessQrCode extends StatefulWidget {
  final Business business;
  final String? startUpSearch;
  const MihBusinessQrCode({
    super.key,
    required this.business,
    required this.startUpSearch,
  });

  @override
  State<MihBusinessQrCode> createState() => _MihBusinessQrCodeState();
}

class _MihBusinessQrCodeState extends State<MihBusinessQrCode> {
  late Future<String> futureImageUrl;
  PlatformFile? file;
  late String qrCodedata;
  int qrSize = 500;
  bool _isUserSignedIn = false;

  Future<void> _checkUserSession() async {
    final doesSessionExist = await SuperTokens.doesSessionExist();
    setState(() {
      _isUserSignedIn = doesSessionExist;
    });
  }

  String getQrCodeData(int qrSize) {
    String color = MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark")
        .toARGB32()
        .toRadixString(16)
        .substring(2, 8);
    // KenLogger.warning(color);
    String bgColor = MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark")
        .toARGB32()
        .toRadixString(16)
        .substring(2, 8);
    // KenLogger.warning(bgColor);
    String encodedData =
        Uri.encodeComponent("$qrCodedata${widget.business.business_id}");

    return "https://api.qrserver.com/v1/create-qr-code/?data=$encodedData&size=${qrSize}x${qrSize}&bgcolor=$bgColor&color=$color";
  }

  Future<void> downloadQrCode() async {
    if (_isUserSignedIn) {
      final Uri uri = Uri.parse(getQrCodeData(1024));
      if (!await launchUrl(uri)) {
        throw 'Could not launch $uri';
      }
    } else {
      showSignInRequiredAlert();
    }
  }

  void showSignInRequiredAlert() {
    showDialog(
      context: context,
      builder: (context) => MihPackageAlert(
        alertIcon: Column(
          children: [
            Icon(
              MihIcons.mihLogo,
              size: 125,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
            const SizedBox(height: 10),
          ],
        ),
        alertTitle: "Let's Get Started",
        alertBody: Column(
          children: [
            Text(
              "Ready to dive in to the world of MIH?\nSign in or create a free MIH account to unlock all the powerful features of the MIH app. It's quick and easy!",
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: MihButton(
                onPressed: () {
                  context.goNamed(
                    'mihHome',
                    extra: true,
                  );
                },
                buttonColor: MihColors.getGreenColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                elevation: 10,
                width: 300,
                child: Text(
                  "Sign In/ Create Account",
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
        alertColour: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkUserSession();
    futureImageUrl =
        MihFileApi.getMinioFileUrl(widget.business.logo_path, context);
    qrCodedata =
        "${AppEnviroment.baseAppUrl}/business-profile/view?business_id=";
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(screenSize, context),
    );
  }

  Widget getBody(Size screenSize, BuildContext context) {
    double profilePictureWidth = 150;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        MihSingleChildScroll(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Padding(
              padding:
                  MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                      ? EdgeInsets.symmetric(horizontal: screenSize.width * 0.2)
                      : EdgeInsets.symmetric(
                          horizontal: screenSize.width * 0), //.075),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Material(
                  color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode == "Dark")
                      .withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(25),
                  elevation: 10,
                  shadowColor: Colors.black,
                  child: Container(
                    decoration: BoxDecoration(
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FutureBuilder(
                              future: futureImageUrl,
                              builder: (context, asyncSnapshot) {
                                if (asyncSnapshot.connectionState ==
                                        ConnectionState.done &&
                                    asyncSnapshot.hasData) {
                                  if (asyncSnapshot.requireData != "") {
                                    return MihCircleAvatar(
                                      imageFile: NetworkImage(
                                          asyncSnapshot.requireData),
                                      width: profilePictureWidth,
                                      editable: false,
                                      fileNameController:
                                          TextEditingController(),
                                      userSelectedfile: file,
                                      frameColor: MihColors.getPrimaryColor(
                                          MzansiInnovationHub.of(context)!
                                                  .theme
                                                  .mode ==
                                              "Dark"),
                                      backgroundColor:
                                          MihColors.getSecondaryColor(
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
                                        MzansiInnovationHub.of(context)!
                                                .theme
                                                .mode ==
                                            "Dark"),
                                  );
                                }
                              },
                            ),
                            FittedBox(
                              child: Text(
                                widget.business.Name,
                                style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: MihColors.getPrimaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
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
                                  color: MihColors.getPrimaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 300,
                              height: 300,
                              child: CachedNetworkImage(
                                imageUrl: getQrCodeData(qrSize.toInt()),
                                placeholder: (context, url) =>
                                    const Mihloadingcircle(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(height: 10),
                            FittedBox(
                              child: Text(
                                "Scan & Connect",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: MihColors.getPrimaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: MihFloatingMenu(
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  child: Icon(
                    Icons.download_rounded,
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                  label: "Download QR Code",
                  labelBackgroundColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  labelStyle: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  onTap: () {
                    downloadQrCode();
                  },
                )
              ]),
        )
      ],
    );
  }
}
