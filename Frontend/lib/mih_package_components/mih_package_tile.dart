import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_yt_video_player.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';

class MihPackageTile extends StatefulWidget {
  final String appName;
  final String? ytVideoID;
  final Widget appIcon;
  final void Function() onTap;
  final double iconSize;
  final Color textColor;
  final bool? authenticateUser;
  const MihPackageTile({
    super.key,
    required this.onTap,
    required this.appName,
    this.ytVideoID,
    required this.appIcon,
    required this.iconSize,
    required this.textColor,
    this.authenticateUser,
  });

  @override
  State<MihPackageTile> createState() => _MihPackageTileState();
}

class _MihPackageTileState extends State<MihPackageTile> {
  final LocalAuthentication _auth = LocalAuthentication();

  void displayHint() {
    if (widget.ytVideoID != null) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return MihPackageWindow(
            fullscreen: false,
            windowTitle: widget.appName,
            // windowTools: const [],
            onWindowTapClose: () {
              Navigator.pop(context);
            },
            windowBody: MIHYTVideoPlayer(
              videoYTLink: widget.ytVideoID!,
            ),
          );
        },
      );
    }
  }

  Future<bool> isUserAuthenticated() async {
    final bool canAuthWithBio = await _auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthWithBio || await _auth.isDeviceSupported();
    print("Auth Available: $canAuthenticate");
    if (canAuthenticate) {
      try {
        final bool didBioAuth = await _auth.authenticate(
          localizedReason: "Authenticate to access ${widget.appName}",
          options: const AuthenticationOptions(
            biometricOnly: false,
          ),
        );
        if (didBioAuth) {
          return true;
        } else {
          authErrorPopUp();
        }
        // print("Authenticated: $didBioAuth");
      } catch (error) {
        print("Auth Error: $error");
        authErrorPopUp();
      }
    } else {
      print("Auth Error: No Biometrics Available");
      authErrorPopUp();
    }
    return false;
  }

  void authErrorPopUp() {
    MihAlertServices().errorAdvancedAlert(
      "Biometric Authentication Required",
      "Hi there! To jump into the ${widget.appName} Package, you'll need to authenticate yourself with your devices biometrics, please set up biometric authentication (like fingerprint, face ID, pattern or pin) on your device first.\n\nIf you have already set up biometric authentication, press \"Authenticate now\" to try again or press \"Set Up Authentication\" to go to your device settings.",
      [
        MihButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          buttonColor: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          width: 300,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        MihButton(
          onPressed: () {
            AppSettings.openAppSettings(
              type: AppSettingsType.security,
            );
            Navigator.of(context).pop();
          },
          buttonColor: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          width: 300,
          child: Text(
            "Set Up Authentication",
            style: TextStyle(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        MihButton(
          onPressed: () {
            Navigator.of(context).pop();
            authenticateUser();
          },
          buttonColor: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          width: 300,
          child: Text(
            "Authenticate Now",
            style: TextStyle(
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      context,
    );
  }

  Future<void> authenticateUser() async {
    if (widget.authenticateUser != null &&
        widget.authenticateUser! &&
        !kIsWeb) {
      if (await isUserAuthenticated()) {
        widget.onTap();
      }
    } else {
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.topCenter,
      // color: Colors.black,
      // width: widget.iconSize,
      // height: widget.iconSize + widget.iconSize / 3,
      child: GestureDetector(
        onTap: () async {
          authenticateUser();
        },
        onLongPress: null, // Do this later
        child: Column(
          children: [
            Flexible(
              flex: 3,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double iconHeight = constraints.maxWidth;
                  return Container(
                    width: iconHeight,
                    height: iconHeight,
                    child:
                        FittedBox(fit: BoxFit.fitHeight, child: widget.appIcon),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Flexible(
              flex: 1,
              child: FittedBox(
                child: Text(
                  widget.appName,
                  textAlign: TextAlign.center,
                  // softWrap: true,
                  // overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
