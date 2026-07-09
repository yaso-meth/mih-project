import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/components/mih_android_store_options.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/components/mih_linux_install_instructions.dart';
import 'package:mzansi_innovation_hub/mih_packages/about_mih/components/mih_linux_update_instructions.dart';
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
    final isWebLinux =
        kIsWeb && (defaultTargetPlatform == TargetPlatform.linux);
    if (isWebAndroid) {
      showDialog(
        context: context,
        builder: (context) => MihAndroidStoreOptions(),
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
      showDialog(
        context: context,
        builder: (context) => MihAndroidStoreOptions(),
      );
    } else if (MzansiInnovationHub.of(context)!.theme.getPlatform() == "iOS") {
      launchSocialUrl(
        Uri.parse(
          "https://apps.apple.com/za/app/mzansi-innovation-hub/id6743310890",
        ),
      );
    } else if (isWebLinux) {
      showDialog(
        context: context,
        builder: (context) => MihLinuxInstallInstructions(),
      );
    } else if (MzansiInnovationHub.of(context)!.theme.getPlatform() ==
        "Linux") {
      showDialog(
        context: context,
        builder: (context) => MihLinuxUpdateInstructions(),
      );
    } else {
      //Web
      triggerWebInstall();
    }
  }
}
