import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_profile_links.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_install_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
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
                      "lib/mih_package_components/assets/images/founder.jpg"),
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
    SharePlus.instance.share(
      ShareParams(text: shareText),
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
          "People",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget mihDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 25,
      ),
      child: Divider(
        thickness: 1,
        color: MihColors.getGreyColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      ),
    );
  }

  Widget aboutHeadings() {
    return Column(
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
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget communityCounter() {
    return Column(
      children: [
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
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget callToActionsButtons() {
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
                MihInstallServices().installMihTrigger(context);
              },
              buttonColor: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.youtube,
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.patreon,
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget womenForChange() {
    String heading = "MIH Stands with Women For Change SA";
    String mission =
        "South Africa is facing a devastating crisis of Gender-Based Violence and Femicide (GBVF), with at least 15 women murdered and 117 women reporting rape daily, often at the hands of known individuals, as highlighted by a shocking 33.8% rise in femicide in the last year, despite the existence of the National Strategic Plan on GBVF (NSP GBVF). Due to the government's lack of urgent action and funding for the NSP GBVF's implementation, organizations like Women For Change are urgently calling for the immediate declaration of GBVF as a National Disaster to mobilize resources and political will for decisive action, which must include judicial reforms (like opposing bail and implementing harsher sentences), immediate funding of the NSP GBVF and the new National Council, making the National Sex Offenders Register publicly accessible, and mandating comprehensive GBVF education and continuous public awareness campaigns.";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: SizedBox(
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
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                MihButton(
                  onPressed: () {
                    launchSocialUrl(
                      Uri.parse(
                        "https://www.tiktok.com/@womenforchange.sa",
                      ),
                    );
                  },
                  buttonColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.tiktok,
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "@womenforchange.sa",
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
                        "https://www.change.org/p/declare-gbvf-a-national-disaster-in-south-africa",
                      ),
                    );
                  },
                  buttonColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        Icons.edit,
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Sign Petition",
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
              ],
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
      ),
    );
  }

  Widget missionAndVission() {
    return Column(
      children: [
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
          height: 10,
        ),
      ],
    );
  }

  Widget founderDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        founderTitle(),
        founderBio(),
      ],
    );
  }

  Widget mihSocials() {
    List<ProfileLink> links = [
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Youtube",
        web_link: "https://www.youtube.com/@MzansiInnovationHub",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "TikTok",
        web_link: "https://www.tiktok.com/@mzansiinnovationhub",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Twitch",
        web_link: "https://www.twitch.tv/mzansiinnovationhub",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Threads",
        web_link: "https://www.threads.com/@mzansi.innovation.hub",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "WhatsApp",
        web_link: "https://whatsapp.com/channel/0029Vax3INCIyPtMn8KgeM2F",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Instagram",
        web_link: "https://www.instagram.com/mzansi.innovation.hub/",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "X",
        web_link: "https://x.com/mzansi_inno_hub",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "LinkedIn",
        web_link: "https://www.linkedin.com/company/mzansi-innovation-hub/",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Facebook",
        web_link: "https://www.facebook.com/profile.php?id=61565345762136",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Reddit",
        web_link: "https://www.reddit.com/r/Mzani_Innovation_Hub/",
      ),
    ];
    return Column(
      children: [
        Text(
          "Follow Our Journey",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        MihProfileLinks(links: links),
        const SizedBox(
          height: 25,
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
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return Stack(
      children: [
        MihSingleChildScroll(
          scrollbarOn: true,
          child: Column(
            children: [
              aboutHeadings(),
              communityCounter(),
              callToActionsButtons(),
              // mihDivider(),
              // womenForChange(),
              mihDivider(),
              missionAndVission(),
              mihDivider(),
              founderDetails(),
              mihDivider(),
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
                  Icons.android,
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                label: "Android",
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
              SpeedDialChild(
                child: Icon(
                  Icons.apple,
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                label: "iOS",
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
                  Icons.store,
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                label: "Huawei",
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
                    "Check out the MIH app on the App Gallery",
                    "https://appgallery.huawei.com/app/C113315335?pkgName=za.co.mzansiinnovationhub.mih",
                  );
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.vpn_lock,
                  color: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                label: "Web",
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
            ],
          ),
        )
      ],
    );
  }
}
