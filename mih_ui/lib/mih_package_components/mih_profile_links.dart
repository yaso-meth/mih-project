import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MihProfileLinks extends StatefulWidget {
  final List<ProfileLink> links;
  final double? buttonSize;
  final bool? paddingOn;
  const MihProfileLinks({
    super.key,
    required this.links,
    this.buttonSize,
    this.paddingOn,
  });

  @override
  State<MihProfileLinks> createState() => _MihProfileLinksState();
}

class _MihProfileLinksState extends State<MihProfileLinks> {
  Widget displayLinkButton(ProfileLink link) {
    IconData iconData;
    Color btnColor;
    Color iconColor = Colors.white;
    switch (link.destination.toLowerCase()) {
      case "youtube":
        iconData = FontAwesomeIcons.youtube;
        btnColor = const Color(0xFFFF0000);
        break;
      case "tiktok":
        iconData = FontAwesomeIcons.tiktok;
        btnColor = const Color(0xFF000000);
        break;
      case "twitch":
        iconData = FontAwesomeIcons.twitch;
        btnColor = const Color(0xFF6441a5);
        break;
      case "threads":
        iconData = FontAwesomeIcons.threads;
        btnColor = const Color(0xFF000000);
        break;
      case "whatsapp":
        iconData = FontAwesomeIcons.whatsapp;
        btnColor = const Color(0xFF25D366);
        break;
      case "instagram":
        iconData = FontAwesomeIcons.instagram;
        btnColor = const Color(0xFFF56040);
        break;
      case "x":
        iconData = FontAwesomeIcons.xTwitter;
        btnColor = const Color(0xFF000000);
        break;
      case "linkedin":
        iconData = FontAwesomeIcons.linkedin;
        btnColor = const Color(0xFF0a66c2);
        break;
      case "facebook":
        iconData = FontAwesomeIcons.facebook;
        btnColor = const Color(0xFF4267B2);
        break;
      case "reddit":
        iconData = FontAwesomeIcons.reddit;
        btnColor = const Color(0xFFFF4500);
        break;
      case "discord":
        iconData = FontAwesomeIcons.discord;
        btnColor = const Color(0xFF5865F2);
        break;
      case "git":
        iconData = FontAwesomeIcons.git;
        btnColor = const Color(0xFF73A952);
        break;
      default:
        iconData = FontAwesomeIcons.link;
        btnColor = MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark");
    }
    return MihButton(
      onPressed: () {
        launchSocialUrl(Uri.parse(link.web_link));
      },
      buttonColor: btnColor,
      child: FaIcon(
        iconData,
        color: iconColor,
        size: 33,
      ),
    );
    // return MihPackageTile(
    //   onTap: () {
    //     launchSocialUrl(Uri.parse(link.web_link));
    //   },
    //   appName: link.destination,
    //   appIcon: Icon(
    //     iconData,
    //     color: btnColor,
    //   ),
    //   iconSize: 200,
    //   textColor: Colors.black,
    //   // MihColors.getPrimaryColor(
    //   //     MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    // );
  }

  Future<void> launchSocialUrl(Uri linkUrl) async {
    if (!await launchUrl(linkUrl)) {
      throw Exception('Could not launch $linkUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          Widget? child) {
        return Padding(
          padding: widget.paddingOn == null || widget.paddingOn!
              ? MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.2)
                  : EdgeInsets.symmetric(horizontal: width * 0)
              : EdgeInsetsGeometry.all(0),
          child: widget.links.isEmpty
              ? SizedBox(
                  height: 35,
                  child: Text(
                    "No Profile Links",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                )
              : Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 10,
                  spacing: 10,
                  children: widget.links.map(
                    (link) {
                      return SizedBox(
                        width: widget.buttonSize ?? 80,
                        height: widget.buttonSize ?? 80,
                        child: displayLinkButton(link),
                      );
                    },
                  ).toList(),
                ),
        );
      },
    );
  }
}
