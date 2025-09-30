import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_install_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:redacted/redacted.dart';
import 'package:share_plus/share_plus.dart';

class MihInfo extends StatefulWidget {
  const MihInfo({super.key});

  @override
  State<MihInfo> createState() => _MihInfoState();
}

class _MihInfoState extends State<MihInfo> {
  late Future<int> _futureUserCount;
  late Future<int> _futureBusinessCount;
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

  Widget founderBio() {
    String bio = "";
    bio += "BSc Computer Science & Information Systems\n";
    bio += "(University of the Western Cape)\n";
    bio +=
        "6 Year of banking experience with one of the big 5 banks of South Africa.";
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
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: CircleAvatar(
                  backgroundColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  backgroundImage: const AssetImage(
                      "lib/mih_components/mih_package_components/assets/images/founder.jpg"),
                  //'https://media.licdn.com/dms/image/D4D03AQGd1-QhjtWWpA/profile-displayphoto-shrink_400_400/0/1671698053061?e=2147483647&v=beta&t=a3dJI5yxs5-KeXjj10LcNCFuC9IOfa8nNn3k_Qyr0CA'),
                  radius: 75,
                ),
              ),
              Icon(
                MihIcons.mihRing,
                size: 165,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
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
              fontSize: 17,
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
              fontSize: 17,
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
              fontSize: 17,
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
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          size: 175,
        ),
      ),
      p: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      s: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          size: 200,
        ),
      ),
      p: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      s: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          size: 200,
        ),
      ),
      p: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      s: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          size: 200,
        ),
      ),
      p: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      s: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          size: 200,
        ),
      ),
      p: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      s: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          size: 200,
        ),
      ),
      p: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      s: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          size: 200,
        ),
      ),
      p: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      s: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          size: 200,
        ),
      ),
      p: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      s: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          size: 200,
        ),
      ),
      p: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      s: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          size: 200,
        ),
      ),
      p: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      s: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
            color: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            fontWeight: FontWeight.bold,
            fontSize: 100,
          ),
        ),
        // FaIcon(
        //   FontAwesomeIcons.tv,
        //   color: MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        //   size: 200,
        // ),
      ),
      p: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      s: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    ));
    //==================================================================
    return socials;
  }

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
    IconData platformIcon;
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
          color: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
        const SizedBox(width: 10),
        Text(
          btnText,
          style: TextStyle(
            color: MihColors.getPrimaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void shareMIHLink(BuildContext context, String message, String link) {
    String shareText = "$message: $link";
    Share.share(
      shareText,
    );
  }

  Widget displayBusinessCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder<int>(
          future: _futureBusinessCount,
          builder: (context, snapshot) {
            bool isLoading = true;
            String userCount = "⚠️";
            if (snapshot.connectionState == ConnectionState.waiting) {
              isLoading = true;
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasError) {
              isLoading = false;
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              isLoading = false;
              userCount = snapshot.data.toString();
            } else {
              isLoading = true;
            }
            return SizedBox(
              child: Text(
                userCount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ).redacted(
              context: context,
              redact: isLoading,
              configuration: RedactedConfiguration(
                defaultBorderRadius: BorderRadius.circular(5),
                redactedColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark",
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        Text(
          "Businesses",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget displayUserCount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder<int>(
          future: _futureUserCount,
          builder: (context, snapshot) {
            bool isLoading = true;
            String userCount = "⚠️";
            if (snapshot.connectionState == ConnectionState.waiting) {
              isLoading = true;
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasError) {
              isLoading = false;
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              isLoading = false;
              userCount = snapshot.data.toString();
            } else {
              isLoading = true;
            }
            return SizedBox(
              child: Text(
                userCount,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
              ),
            ).redacted(
              context: context,
              redact: isLoading,
              configuration: RedactedConfiguration(
                defaultBorderRadius: BorderRadius.circular(5),
                redactedColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark",
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        Text(
          "Users",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _futureUserCount = MihUserServices().fetchUserCount();
    _futureBusinessCount = MihBusinessDetailsServices().fetchBusinessCount();
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
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
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Mzansi Innovation Hub",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              Text(
                "MIH App Version: ${MzansiInnovationHub.of(context)!.theme.getLatestVersion()}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                ),
              ),
              // ===================== Divider
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //     vertical: 10.0,
              //     horizontal: 25,
              //   ),
              //   child: Divider(
              //     thickness: 1,
              //     color: MihColors.getGreyColor(
              //         MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              //   ),
              // ),
              const SizedBox(
                height: 10,
              ),
              // Text(
              //   "The MIH Community",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 22,
              //   ),
              // ),
              Wrap(
                alignment: WrapAlignment.spaceAround,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 25,
                runSpacing: 10,
                children: [
                  displayUserCount(),
                  displayBusinessCount(),
                ],
              ),
              Text(
                "The MIH Community",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              // ===================== Divider
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 25,
                ),
                child: Divider(
                  thickness: 1,
                  color: MihColors.getGreyColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    ourVision(),
                    ourMission(),
                  ],
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    MihButton(
                      onPressed: () {
                        MihInstallServices().installMihTrigger(context);
                      },
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
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
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.youtube,
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "MIH Beginners Guide",
                            style: TextStyle(
                              color: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
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
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.patreon,
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Support Our Journey",
                            style: TextStyle(
                              color: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
              const SizedBox(
                height: 10,
              ),
              // ===================== Divider
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 25,
                ),
                child: Divider(
                  thickness: 1,
                  color: MihColors.getGreyColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
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
              // ===================== Divider
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 25,
                ),
                child: Divider(
                  thickness: 1,
                  color: MihColors.getGreyColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
              mihSocials(),
            ],
          ),
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: MihFloatingMenu(
            icon: Icons.share,
            children: [
              SpeedDialChild(
                child: Icon(
                  Icons.vpn_lock,
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                label: "MIH - Web",
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
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                label: "MIH - iOS",
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
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                label: "MIH - Android",
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
