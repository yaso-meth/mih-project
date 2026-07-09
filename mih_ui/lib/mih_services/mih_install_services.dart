import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mzansi_innovation_hub/mih_helpers/mih_install_stub.dart'
    if (dart.library.js_interop) 'package:mzansi_innovation_hub/mih_helpers/mih_install_web.dart';

class MihInstallServices {
  String? errorMessage;

  Future<void> launchSocialUrl(Uri linkUrl) async {
    if (!await launchUrl(linkUrl)) {
      throw Exception('Could not launch $linkUrl');
    }
  }

  void installMihTrigger(BuildContext context) {
    final isWebAndroid =
        kIsWeb && (defaultTargetPlatform == TargetPlatform.android);
    final isWebIos = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS);
    if (isWebAndroid) {
      launchSocialUrl(
        Uri.parse(
          "https://play.google.com/store/apps/details?id=za.co.mzansiinnovationhub.mih",
        ),
      );
    } else if (isWebIos) {
      //Show pop up for IOS
      launchSocialUrl(
        Uri.parse(
          "https://apps.apple.com/za/app/mzansi-innovation-hub/id6743310890",
        ),
      );
    } else if (MzansiInnovationHub.of(context)!.theme.getPlatform() ==
        "Android") {
      //Installed Android App
      launchSocialUrl(
        Uri.parse(
          "https://play.google.com/store/apps/details?id=za.co.mzansiinnovationhub.mih",
        ),
      );
    } else if (MzansiInnovationHub.of(context)!.theme.getPlatform() == "iOS") {
      launchSocialUrl(
        Uri.parse(
          "https://apps.apple.com/za/app/mzansi-innovation-hub/id6743310890",
        ),
      );
    } else if (MzansiInnovationHub.of(context)!.theme.getPlatform() ==
        "Linux") {
    } else {
      //Web
      triggerWebInstall();
    }
  }
}
