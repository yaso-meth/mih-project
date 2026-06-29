import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_install_services.dart';
import 'package:url_launcher/url_launcher.dart';

class CallToActionButtons extends StatefulWidget {
  const CallToActionButtons({super.key});

  @override
  State<CallToActionButtons> createState() => _CallToActionButtonsState();
}

class _CallToActionButtonsState extends State<CallToActionButtons> {
  Future<void> launchSocialUrl(Uri linkUrl) async {
    if (!await launchUrl(linkUrl)) {
      throw Exception('Could not launch $linkUrl');
    }
  }

  Widget getInstallButtonText() {
    final isWebAndroid =
        kIsWeb && (defaultTargetPlatform == TargetPlatform.android);
    final isWebIos = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS);
    String btnText = "";
    FaIconData platformIcon;
    if (isWebAndroid) {
      btnText = "Install MIH";
      platformIcon = FontAwesomeIcons.googlePlay;
    } else if (isWebIos) {
      btnText = "Install MIH";
      platformIcon = FontAwesomeIcons.appStoreIos;
    } else if (MzansiInnovationHub.of(context)!.theme.getPlatform() ==
        "Android") {
      btnText = "Update MIH";
      platformIcon = FontAwesomeIcons.googlePlay;
    } else if (MzansiInnovationHub.of(context)!.theme.getPlatform() == "iOS") {
      btnText = "Update MIH";
      platformIcon = FontAwesomeIcons.appStoreIos;
    } else {
      btnText = "Install MIH";
      platformIcon = FontAwesomeIcons.globe;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          platformIcon,
          color: MihColors.primary(),
        ),
        const SizedBox(width: 10),
        Text(
          btnText,
          style: TextStyle(
            color: MihColors.primary(),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            MihButton(
              onPressed: () {
                if (MzansiInnovationHub.of(context)!.theme.getPlatform() ==
                    "Android") {
                  showDialog(
                    context: context,
                    builder: (context) {
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
                                launchSocialUrl(
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
                                launchSocialUrl(
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
                    },
                  );
                } else {
                  MihInstallServices().installMihTrigger(context);
                }
              },
              buttonColor: MihColors.green(),
              width: 300,
              child: getInstallButtonText(),
            ),
            MihButton(
              onPressed: () {
                launchSocialUrl(
                  Uri.parse(
                    "https://www.youtube.com/playlist?list=PLuT35kJIui0H5kXjxNOZlHoOPZbQLr4qh",
                  ),
                );
              },
              buttonColor: MihColors.green(),
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.youtube,
                    color: MihColors.primary(),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "MIH Beginners Guide",
                    style: TextStyle(
                      color: MihColors.primary(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            MihButton(
              onPressed: () {
                launchSocialUrl(
                  Uri.parse(
                    "https://patreon.com/MzansiInnovationHub?utm_medium=unknown&utm_source=join_link&utm_campaign=creatorshare_creator&utm_content=copyLink",
                  ),
                );
              },
              buttonColor: MihColors.green(),
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.patreon,
                    color: MihColors.primary(),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Support Our Journey",
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
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
