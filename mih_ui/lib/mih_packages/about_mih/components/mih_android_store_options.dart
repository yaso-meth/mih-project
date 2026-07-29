import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_install_services.dart';

class MihAndroidStoreOptions extends StatefulWidget {
  const MihAndroidStoreOptions({super.key});

  @override
  State<MihAndroidStoreOptions> createState() => _MihAndroidStoreOptionsState();
}

class _MihAndroidStoreOptionsState extends State<MihAndroidStoreOptions> {
  @override
  Widget build(BuildContext context) {
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "Select Option",
      onWindowTapClose: () {
        context.pop();
      },
      windowBody: Column(
        children: [
          Text(
            "Please select the platform you want to install/ Update MIH from",
            style: TextStyle(
              color: MihColors.secondary(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          MihButton(
            onPressed: () {
              MihInstallServices().launchSocialUrl(
                Uri.parse(
                  "https://play.google.com/store/apps/details?id=za.co.mzansiinnovationhub.mih",
                ),
              );
            },
            buttonColor: MihColors.green(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.googlePlay,
                  color: MihColors.primary(),
                ),
                const SizedBox(width: 10),
                Text(
                  "Play Store",
                  style: TextStyle(
                    color: MihColors.primary(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          MihButton(
            onPressed: () {
              MihInstallServices().launchSocialUrl(
                Uri.parse(
                  "https://appgallery.huawei.com/app/C113315335?pkgName=za.co.mzansiinnovationhub.mih",
                ),
              );
            },
            buttonColor: MihColors.green(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.store,
                  color: MihColors.primary(),
                ),
                const SizedBox(width: 10),
                Text(
                  "App Gallery",
                  style: TextStyle(
                    color: MihColors.primary(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
