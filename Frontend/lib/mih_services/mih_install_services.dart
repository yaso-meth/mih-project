import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:pwa_install/pwa_install.dart';
// import 'package:universal_html/js.dart' as js;
import 'package:url_launcher/url_launcher.dart';

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
    } else if (MzanziInnovationHub.of(context)!.theme.getPlatform() ==
        "Android") {
      //Installed Android App
      launchSocialUrl(
        Uri.parse(
          "https://play.google.com/store/apps/details?id=za.co.mzansiinnovationhub.mih",
        ),
      );
    } else if (MzanziInnovationHub.of(context)!.theme.getPlatform() == "iOS") {
      launchSocialUrl(
        Uri.parse(
          "https://apps.apple.com/za/app/mzansi-innovation-hub/id6743310890",
        ),
      );
    } else {
      //Web
      if (PWAInstall().installPromptEnabled) {
        try {
          PWAInstall().promptInstall_();
        } catch (e) {
          errorMessage = e.toString();
          debugPrint('Error prompting install: $e');
        }
      } else {
        // Fallback for unsupported platforms
        debugPrint('Install prompt not available for this platform.');
      }
      // js.context.callMethod("presentAddToHome");
    }
  }
}
