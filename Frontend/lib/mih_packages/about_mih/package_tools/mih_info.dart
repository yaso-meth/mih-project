import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import "package:universal_html/js.dart" as js;
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class MihInfo extends StatefulWidget {
  const MihInfo({super.key});

  @override
  State<MihInfo> createState() => _MihInfoState();
}

class _MihInfoState extends State<MihInfo> {
  final Uri _tiktokUrl =
      Uri.parse('https://www.tiktok.com/@mzansi.innovation.hub');
  final Uri _whatsappUrl =
      Uri.parse('https://whatsapp.com/channel/0029Vax3INCIyPtMn8KgeM2F');
  final Uri _twitch = Uri.parse('https://www.twitch.tv/mzansi_innovation_hub');
  final Uri _kick = Uri.parse('https://kick.com/mzansi-innovation-hub');
  final Uri _threadsUrl =
      Uri.parse('https://www.threads.net/@mzansi.innovation.hub');
  final Uri _instagramUrl =
      Uri.parse('https://www.instagram.com/mzansi.innovation.hub');
  final Uri _youtubeUrl =
      Uri.parse('https://www.youtube.com/@mzansiinnovationhub');
  final Uri _xUrl = Uri.parse('https://x.com/mzansi_inno_hub');
  final Uri _linkedinUrl =
      Uri.parse('https://www.linkedin.com/company/mzansi-innovation-hub/');
  final Uri _facebookUrl =
      Uri.parse('https://www.facebook.com/profile.php?id=61565345762136');
  final Uri _redditUrl =
      Uri.parse('https://www.reddit.com/r/Mzani_Innovation_Hub/');

  void installMihTrigger() {
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
      // _showIOSInstallationGuide();
      launchSocialUrl(
        Uri.parse(
          "https://apps.apple.com/za/app/mzansi-innovation-hub/id6743310890",
        ),
      );
    } else if (MzanziInnovationHub.of(context)!.theme.getPlatform() ==
        "Android") {
      //Installed Android App
      // _showIOSInstallationGuide();
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
      js.context.callMethod("presentAddToHome");
    }
  }

  // void _showIOSInstallationGuide() {
  //   double windowFontSize = 17.0;
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return MihPackageWindow(
  //         fullscreen: false,
  //         windowTitle: "MIH Installation Guide (iOS)",
  //         windowTools: const [],
  //         onWindowTapClose: () {
  //           Navigator.of(context).pop();
  //         },
  //         windowBody: [
  //           Align(
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               "In order to install MIH on your iPhone, please follow the below steps:- ",
  //               textAlign: TextAlign.left,
  //               style: TextStyle(
  //                 color:
  //                     MzanziInnovationHub.of(context)!.theme.secondaryColor(),
  //                 fontSize: windowFontSize,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           Align(
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               "1. Launch MIH on Safari.",
  //               textAlign: TextAlign.left,
  //               style: TextStyle(
  //                 color:
  //                     MzanziInnovationHub.of(context)!.theme.secondaryColor(),
  //                 fontSize: windowFontSize,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           Align(
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               "2. Tap the Share Button.",
  //               textAlign: TextAlign.left,
  //               style: TextStyle(
  //                 color:
  //                     MzanziInnovationHub.of(context)!.theme.secondaryColor(),
  //                 fontSize: windowFontSize,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           Align(
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               "3. Scroll down and tap \"Add to Home Screen\".",
  //               textAlign: TextAlign.left,
  //               style: TextStyle(
  //                 color:
  //                     MzanziInnovationHub.of(context)!.theme.secondaryColor(),
  //                 fontSize: windowFontSize,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           Align(
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               "4. Choose a name for the shortcut (Optional).",
  //               textAlign: TextAlign.left,
  //               style: TextStyle(
  //                 color:
  //                     MzanziInnovationHub.of(context)!.theme.secondaryColor(),
  //                 fontSize: windowFontSize,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           Align(
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               "5. Tap \"Add\".",
  //               textAlign: TextAlign.left,
  //               style: TextStyle(
  //                 color:
  //                     MzanziInnovationHub.of(context)!.theme.secondaryColor(),
  //                 fontSize: windowFontSize,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           Align(
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               "That's it! Now you can tap the MIH icon on your home screen to open it quickly.",
  //               textAlign: TextAlign.left,
  //               style: TextStyle(
  //                 color:
  //                     MzanziInnovationHub.of(context)!.theme.secondaryColor(),
  //                 fontSize: windowFontSize,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 10),
  //           Align(
  //             alignment: Alignment.centerLeft,
  //             child: Text(
  //               "If you are still having trouble, please click on the button below to view a video guide.",
  //               textAlign: TextAlign.left,
  //               style: TextStyle(
  //                 color: MzanziInnovationHub.of(context)!.theme.errorColor(),
  //                 fontSize: windowFontSize,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //           const SizedBox(height: 15),
  //           SizedBox(
  //             width: 300,
  //             height: 50,
  //             child: MIHButton(
  //               onTap: () {
  //                 launchSocialUrl(
  //                   Uri.parse(
  //                     "https://www.youtube.com/watch?v=KVK78IV28JY",
  //                   ),
  //                 );
  //               },
  //               buttonText: "Video Guide",
  //               buttonColor:
  //                   MzanziInnovationHub.of(context)!.theme.secondaryColor(),
  //               textColor:
  //                   MzanziInnovationHub.of(context)!.theme.primaryColor(),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget founderBio() {
    String bio = "";
    bio += "BSc Computer Science & Information Systems\n";
    bio += "(University of the Western Cape)\n";
    bio +=
        "6 Year of banking experience with one of the big 5 banks of South Africa.";
    ImageProvider logoFrame =
        MzanziInnovationHub.of(context)!.theme.altLogoFrame();
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              CircleAvatar(
                backgroundColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                backgroundImage: const AssetImage(
                    "lib/mih_components/mih_package_components/assets/images/founder.jpg"),
                //'https://media.licdn.com/dms/image/D4D03AQGd1-QhjtWWpA/profile-displayphoto-shrink_400_400/0/1671698053061?e=2147483647&v=beta&t=a3dJI5yxs5-KeXjj10LcNCFuC9IOfa8nNn3k_Qyr0CA'),
                radius: 75,
              ),
              SizedBox(
                width: 165,
                child: Image(image: logoFrame),
              )
            ],
          ),
        ),
        SizedBox(
          width: 400,
          child: Text(
            bio,
            textAlign: TextAlign.center,
            style: const TextStyle(
              //fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget founderTitle() {
    String heading = "Yasien Meth (Founder & CEO)";
    return Column(
      children: [
        Text(
          heading,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget ourVision() {
    String heading = "Our Vision";
    String vision =
        "Digitizing Mzansi one process at a time. Discover essential Mzansi apps to streamline your personal and professional life. Simplify your daily tasks with our user-friendly solutions.";

    return SizedBox(
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            heading,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            vision,
            textAlign: TextAlign.center,
            style: const TextStyle(
              //fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget ourMission() {
    String heading = "Our Mission";
    String mission =
        "Bridge the digital divide in Mzansi, ensuring that everyone can benefit from the power of technology. We empower lives by providing simple, elegant solutions that elevate daily experiences. With our user-friendly approach, we're making the digital world accessible to all, ensuring no one is left behind in the digital revolution.";

    return SizedBox(
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            heading,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            mission,
            textAlign: TextAlign.center,
            style: const TextStyle(
              //fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget mihSocials() {
    String heading = "Follow Our Journey";
    return Column(
      children: [
        Text(
          heading,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 500,
          height: 600,
          child: GridView.builder(
            padding: const EdgeInsets.only(
                // left: width / 10,
                // right: width / 10,
                // //bottom: height / 5,
                // top: 20,
                ),
            physics: const NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            itemCount: getSocialsList().length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 15, maxCrossAxisExtent: 150),
            itemBuilder: (context, index) {
              return getSocialsList()[index];
            },
          ),
        ),
      ],
    );
  }

  List<Widget> getSocialsList() {
    List<Widget> socials = [];
    socials.add(MIHTile(
      onTap: () {
        launchSocialUrl(_youtubeUrl);
      },
      tileName: "YouTube",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.youtube,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 175,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        launchSocialUrl(_tiktokUrl);
      },
      tileName: "TikTok",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.tiktok,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        launchSocialUrl(_twitch);
      },
      tileName: "Twitch",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.twitch,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        launchSocialUrl(_threadsUrl);
      },
      tileName: "Threads",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.threads,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        launchSocialUrl(_whatsappUrl);
      },
      tileName: "Whatsapp",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.whatsapp,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        launchSocialUrl(_instagramUrl);
      },
      tileName: "Instagram",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.instagram,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================

    socials.add(MIHTile(
      onTap: () {
        launchSocialUrl(_xUrl);
      },
      tileName: "X",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.xTwitter,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        launchSocialUrl(_linkedinUrl);
      },
      tileName: "LinkedIn",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.linkedin,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        launchSocialUrl(_facebookUrl);
      },
      tileName: "FaceBook",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.facebook,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        launchSocialUrl(_redditUrl);
      },
      tileName: "Reddit",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.reddit,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        launchSocialUrl(_kick);
      },
      tileName: "Kick",
      tileIcon: Center(
        child: Text(
          "KICK",
          style: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            fontWeight: FontWeight.bold,
            fontSize: 100,
          ),
        ),
        // FaIcon(
        //   FontAwesomeIcons.tv,
        //   color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        //   size: 200,
        // ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    return socials;
  }

  Future<void> launchSocialUrl(Uri linkUrl) async {
    if (!await launchUrl(linkUrl)) {
      throw Exception('Could not launch $linkUrl');
    }
  }

  String getInstallButtonText() {
    final isWebAndroid =
        kIsWeb && (defaultTargetPlatform == TargetPlatform.android);
    final isWebIos = kIsWeb && (defaultTargetPlatform == TargetPlatform.iOS);

    if (isWebAndroid) {
      return "Install MIH (Play Store)";
    } else if (isWebIos) {
      return "Install MIH (PWA)";
    } else if (MzanziInnovationHub.of(context)!.theme.getPlatform() ==
        "Android") {
      return "Update MIH (Play Store)";
    } else if (MzanziInnovationHub.of(context)!.theme.getPlatform() == "iOS") {
      return "Update MIH (App Store)";
    } else {
      return "Install MIH (PWA)";
    }
  }

  void shareMIHLink(BuildContext context, String message, String link) {
    String shareText = "$message: $link";
    Share.share(
      shareText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Column(
            children: [
              SizedBox(
                width: 165,
                child: FittedBox(
                  child: Icon(
                    MihIcons.mihLogo,
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Mzansi Innovation Hub",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              Text(
                "MIH App Version: ${MzanziInnovationHub.of(context)!.theme.getLatestVersion()}",
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 10,
                runSpacing: 10,
                children: [
                  ourVision(),
                  ourMission(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: MIHButton(
                        onTap: () {
                          installMihTrigger();
                        },
                        buttonText: getInstallButtonText(),
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: MIHButton(
                        onTap: () {
                          launchSocialUrl(
                            Uri.parse(
                              "https://www.youtube.com/playlist?list=PLuT35kJIui0H5kXjxNOZlHoOPZbQLr4qh",
                            ),
                          );
                        },
                        buttonText: "MIH Beginners Guide",
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      ),
                    ),
                  ]),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                // spacing: 10,
                // runSpacing: 10,
                children: [
                  founderTitle(),
                  founderBio(),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(),
              ),
              mihSocials(),
            ],
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: MihFloatingMenu(
            icon: Icons.share,
            children: [
              SpeedDialChild(
                child: Icon(
                  Icons.vpn_lock,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
                label: "MIH - Web",
                labelBackgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                labelStyle: TextStyle(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                onTap: () {
                  shareMIHLink(
                    context,
                    "Check out the MIH app on the Web",
                    "https://app.mzansi-innovation-hub.co.za/",
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.apple,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
                label: "MIH - iOS",
                labelBackgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                labelStyle: TextStyle(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                onTap: () {
                  shareMIHLink(
                    context,
                    "Check out the MIH app on the App Store",
                    "https://apps.apple.com/za/app/mzansi-innovation-hub/id6743310890",
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.android,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
                label: "MIH - Android",
                labelBackgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                labelStyle: TextStyle(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                onTap: () {
                  shareMIHLink(
                    context,
                    "Check out the MIH app on the Play Store",
                    "https://play.google.com/store/apps/details?id=za.co.mzansiinnovationhub.mih",
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
