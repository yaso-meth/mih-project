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
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:provider/provider.dart';
import 'package:qr_bar_code/code/src/code_generate.dart';
import 'package:qr_bar_code/code/src/code_type.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:supertokens_flutter/supertokens.dart';

class MihBusinessQrCode extends StatefulWidget {
  final Business? business;
  const MihBusinessQrCode({
    super.key,
    required this.business,
  });

  @override
  State<MihBusinessQrCode> createState() => _MihBusinessQrCodeState();
}

class _MihBusinessQrCodeState extends State<MihBusinessQrCode> {
  late Business business;
  PlatformFile? file;
  late String _businessShare;
  int qrSize = 500;
  bool _isUserSignedIn = false;
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? businessQRImageFile;

  Future<void> _checkUserSession() async {
    final doesSessionExist = await SuperTokens.doesSessionExist();
    setState(() {
      _isUserSignedIn = doesSessionExist;
    });
  }

  Future<void> saveImage(Uint8List imageBytes) async {
    final String filename =
        "${business.Name}_QR_Code_${DateTime.now().millisecondsSinceEpoch}";
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
          businessQRImageFile = image;
        });
      }).catchError((onError) {
        KenLogger.error(onError);
      });
      // KenLogger.success("QR Code Image Captured : $businessQRImageFile");
      saveImage(businessQRImageFile!);
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

  Widget displayBusinessQRCode(double profilePictureWidth) {
    MzansiProfileProvider profileprovider =
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
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: widget.business == null
                        ? MihCircleAvatar(
                            imageFile: profileprovider.businessProfilePicture,
                            width: profilePictureWidth,
                            expandable: true,
                            editable: false,
                            fileNameController: TextEditingController(),
                            userSelectedfile: file,
                            frameColor: MihColors.primary(),
                            backgroundColor: MihColors.secondary(),
                            onChange: null,
                          )
                        : MihCircleAvatar(
                            imageFile: CachedNetworkImageProvider(
                              MihFileApi.getMinioFileUrlV2(business.logo_path),
                            ),
                            width: profilePictureWidth,
                            expandable: true,
                            editable: false,
                            fileNameController: TextEditingController(),
                            userSelectedfile: file,
                            frameColor: MihColors.primary(),
                            backgroundColor: MihColors.secondary(),
                            onChange: null,
                          ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: FittedBox(
                        child: Text(
                          business.Name,
                          style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: MihColors.primary(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: FittedBox(
                      child: Text(
                        business.type,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: MihColors.primary(),
                        ),
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
                            fontSize: 18,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: LayoutBuilder(builder: (context, constraints) {
                      final double codesize = constraints.maxWidth < qrSize
                          ? constraints.maxWidth
                          : qrSize.toDouble();
                      return Code(
                        color: MihColors.primary(),
                        data: "$_businessShare${business.business_id}",
                        codeType: CodeType.qrCode(),
                        width: codesize,
                        height: codesize,
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: FittedBox(
                      child: Text(
                        "Scan & Connect",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: MihColors.primary(),
                        ),
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
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    if (widget.business != null) {
      business = widget.business!;
    } else {
      business = profileProvider.business!;
    }
    _checkUserSession();
    _businessShare = "${AppEnviroment.baseAppUrl}/business-profile/view/";
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(screenSize, context),
    );
  }

  Widget getBody(Size screenSize, BuildContext context) {
    double profilePictureWidth =
        MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
            ? 225
            : 200;
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
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: displayBusinessQRCode(profilePictureWidth),
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
                  label: "Share Business",
                  labelBackgroundColor: MihColors.green(),
                  labelStyle: TextStyle(
                    color: MihColors.primary(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: MihColors.green(),
                  onTap: () {
                    shareMIHLink(
                      context,
                      "Check out ${business.Name} on the MIH app's Mzansi Directory",
                      "$_businessShare${business.business_id}",
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
                          text: "$_businessShare${business.business_id}"),
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
