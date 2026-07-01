import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supertokens_flutter/supertokens.dart';

class MihPersonalQrCode extends StatefulWidget {
  final AppUser? user;
  const MihPersonalQrCode({
    super.key,
    required this.user,
  });

  @override
  State<MihPersonalQrCode> createState() => _MihPersonalQrCodeState();
}

class _MihPersonalQrCodeState extends State<MihPersonalQrCode> {
  late AppUser user;
  late Future<String> futureImageUrl;
  PlatformFile? file;
  int qrSize = 500;
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? personalQRImageFile;
  bool _isUserSignedIn = false;
  final String _qrCodedata = "${AppEnviroment.baseAppUrl}/mzansi-profile/view/";

  Future<void> _checkUserSession() async {
    final doesSessionExist = await SuperTokens.doesSessionExist();
    setState(() {
      _isUserSignedIn = doesSessionExist;
    });
  }

  String getQrCodeData(int qrSize) {
    String color =
        MihColors.primary().toARGB32().toRadixString(16).substring(2, 8);
    // KenLogger.warning(color);
    String bgColor =
        MihColors.secondary().toARGB32().toRadixString(16).substring(2, 8);
    // KenLogger.warning(bgColor);
    String encodedData =
        Uri.encodeComponent("$_qrCodedata${user.username.toLowerCase()}");
    return "https://api.qrserver.com/v1/create-qr-code/?data=$encodedData&size=${qrSize}x$qrSize&bgcolor=$bgColor&color=$color";
  }

  Future<void> saveImage(Uint8List imageBytes) async {
    final String filename =
        "${user.username}_QR_Code_${DateTime.now().millisecondsSinceEpoch}";
    // "${user.username}_QR_Code_${DateTime.now().millisecondsSinceEpoch}.png";
    if (kIsWeb) {
      await FileSaver.instance.saveFile(
        name: filename,
        bytes: imageBytes,
        fileExtension: "png",
        mimeType: MimeType.png,
      );
    } else if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.windows) {
      // Use File Picker to get a save path on Desktop
      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Please select where to save your QR Code:',
        fileName: filename,
        bytes: imageBytes,
      );
      if (outputFile != null) {
        // final file = File(outputFile);
        // await file.writeAsBytes(imageBytes);
        KenLogger.success("Saved to $outputFile");
      }
    } else {
      await FileSaver.instance.saveAs(
        name: filename,
        bytes: imageBytes,
        fileExtension: "png",
        mimeType: MimeType.png,
      );
    }
  }

  Future<void> downloadQrCode() async {
    if (_isUserSignedIn) {
      await screenshotController.capture().then((image) {
        // KenLogger.success("Image Captured: $image");
        setState(() {
          personalQRImageFile = image;
        });
      }).catchError((onError) {
        KenLogger.error(onError);
      });
      // KenLogger.success("QR Code Image Captured : $businessQRImageFile");
      saveImage(personalQRImageFile!);
    } else {
      showSignInRequiredAlert();
    }
  }

  void showSignInRequiredAlert() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          windowBody: Column(
            children: [
              Icon(
                MihIcons.mihLogo,
                size: 100,
                color: MihColors.secondary(),
              ),
              Text(
                "Let's Get Started",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MihColors.primary(),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Ready to dive in to the world of MIH?\nSign in or create a free MIH account to unlock all the powerful features of the MIH app. It's quick and easy!",
                style: TextStyle(
                  color: MihColors.secondary(),
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
                  buttonColor: MihColors.green(),
                  elevation: 10,
                  width: 300,
                  child: Text(
                    "Sign In/ Create Account",
                    style: TextStyle(
                      color: MihColors.primary(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget displayPersonalQRCode(double profilePictureWidth) {
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    return Screenshot(
      controller: screenshotController,
      child: Material(
        color: MihColors.secondary().withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(25),
        elevation: 10,
        shadowColor: Colors.black,
        child: Container(
          decoration: BoxDecoration(
            color: MihColors.secondary(),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  widget.user == null
                      ? MihCircleAvatar(
                          imageFile: profileProvider.userProfilePicture,
                          width: profilePictureWidth,
                          expandable: true,
                          editable: false,
                          fileNameController: TextEditingController(),
                          userSelectedfile: file,
                          frameColor: MihColors.primary(),
                          backgroundColor: MihColors.secondary(),
                          onChange: () {},
                        )
                      : FutureBuilder(
                          future: futureImageUrl,
                          builder: (context, asyncSnapshot) {
                            if (asyncSnapshot.connectionState ==
                                    ConnectionState.done &&
                                asyncSnapshot.hasData) {
                              if (asyncSnapshot.requireData != "" ||
                                  asyncSnapshot.requireData.isNotEmpty) {
                                return MihCircleAvatar(
                                  imageFile: CachedNetworkImageProvider(
                                      asyncSnapshot.requireData),
                                  width: profilePictureWidth,
                                  expandable: true,
                                  editable: false,
                                  fileNameController: TextEditingController(),
                                  userSelectedfile: file,
                                  frameColor: MihColors.primary(),
                                  backgroundColor: MihColors.secondary(),
                                  onChange: () {},
                                );
                              } else {
                                return Icon(
                                  MihIcons.mihIDontKnow,
                                  size: profilePictureWidth,
                                  color: MihColors.primary(),
                                );
                              }
                            } else {
                              return Icon(
                                MihIcons.mihRing,
                                size: profilePictureWidth,
                                color: MihColors.primary(),
                              );
                            }
                          },
                        ),
                  FittedBox(
                    child: Text(
                      user.username,
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: MihColors.primary(),
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      "${user.fname} ${user.lname}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: MihColors.primary(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FittedBox(
                        child: Text(
                          "Powered by MIH",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: MihColors.primary(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        MihIcons.mihLogo,
                        size: 20,
                        color: MihColors.primary(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: CachedNetworkImage(
                      imageUrl: getQrCodeData(qrSize.toInt()),
                      placeholder: (context, url) => FittedBox(
                        child: const Mihloadingcircle(),
                      ),
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
                        color: MihColors.primary(),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void shareMIHLink(BuildContext context, String message, String link) {
    String shareText = "$message: $link";
    SharePlus.instance.share(
      ShareParams(text: shareText),
    );
  }

  @override
  void initState() {
    super.initState();
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    if (widget.user != null) {
      user = widget.user!;
    } else {
      user = profileProvider.user!;
    }
    _checkUserSession();
    futureImageUrl = MihFileApi.getMinioFileUrl(user.pro_pic_path);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Consumer(builder: (
      BuildContext context,
      MzansiDirectoryProvider directoryProvider,
      Widget? child,
    ) {
      return MihPackageToolBody(
        backgroundColor: MihColors.primary(),
        borderOn: false,
        innerHorizontalPadding: 10,
        bodyItem: getBody(screenSize, context),
      );
    });
  }

  Widget getBody(Size screenSize, BuildContext context) {
    double profilePictureWidth = 150;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        MihSingleChildScroll(
          scrollbarOn: true,
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
                child: displayPersonalQRCode(profilePictureWidth),
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
                    color: MihColors.primary(),
                  ),
                  label: "Download QR Code",
                  labelBackgroundColor: MihColors.green(),
                  labelStyle: TextStyle(
                    color: MihColors.primary(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: MihColors.green(),
                  onTap: () {
                    downloadQrCode();
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.share_rounded,
                    color: MihColors.primary(),
                  ),
                  label: "Share Profile",
                  labelBackgroundColor: MihColors.green(),
                  labelStyle: TextStyle(
                    color: MihColors.primary(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: MihColors.green(),
                  onTap: () {
                    shareMIHLink(
                      context,
                      "Check out ${user.username} on the MIH app's Mzansi Directory",
                      "$_qrCodedata${user.username.toLowerCase()}",
                    );
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.copy_rounded,
                    color: MihColors.primary(),
                  ),
                  label: "Copy Link",
                  labelBackgroundColor: MihColors.green(),
                  labelStyle: TextStyle(
                    color: MihColors.primary(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: MihColors.green(),
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(
                          text: "$_qrCodedata${user.username.toLowerCase()}"),
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      MihSnackBar(
                        child: Text("Link Copied!"),
                      ),
                    );
                  },
                ),
              ]),
        )
      ],
    );
  }
}
