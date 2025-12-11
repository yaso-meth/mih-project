import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tile.dart';
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
    Color iconColor;
    switch (link.destination.toLowerCase()) {
      case "youtube":
        iconData = FontAwesomeIcons.youtube;
        iconColor = const Color(0xFFFF0000);
        break;
      case "tiktok":
        iconData = FontAwesomeIcons.tiktok;
        iconColor = const Color(0xFF000000);
        break;
      case "twitch":
        iconData = FontAwesomeIcons.twitch;
        iconColor = const Color(0xFF6441a5);
        break;
      case "threads":
        iconData = FontAwesomeIcons.threads;
        iconColor = const Color(0xFF000000);
        break;
      case "whatsapp":
        iconData = FontAwesomeIcons.whatsapp;
        iconColor = const Color(0xFF25D366);
        break;
      case "instagram":
        iconData = FontAwesomeIcons.instagram;
        iconColor = const Color(0xFFF56040);
        break;
      case "x":
        iconData = FontAwesomeIcons.xTwitter;
        iconColor = const Color(0xFF000000);
        break;
      case "linkedin":
        iconData = FontAwesomeIcons.linkedin;
        iconColor = const Color(0xFF0a66c2);
        break;
      case "facebook":
        iconData = FontAwesomeIcons.facebook;
        iconColor = const Color(0xFF4267B2);
        break;
      case "reddit":
        iconData = FontAwesomeIcons.reddit;
        iconColor = const Color(0xFFFF4500);
        break;
      case "discord":
        iconData = FontAwesomeIcons.discord;
        iconColor = const Color(0xFF5865F2);
        break;
      default:
        iconData = FontAwesomeIcons.link;
        iconColor = MihColors.getPrimaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark");
    }

    return MihPackageTile(
      onTap: () {
        launchSocialUrl(Uri.parse(link.web_link));
      },
      appName: link.destination,
      appIcon: Icon(
        iconData,
        color: iconColor,
      ),
      iconSize: 200,
      textColor: Colors.black,
      // MihColors.getPrimaryColor(
      //     MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
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
                  : EdgeInsets.symmetric(horizontal: width * 0.075)
              : EdgeInsetsGeometry.all(0),
          child: Material(
            color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark")
                .withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(25),
            elevation: 10,
            shadowColor: Colors.black,
            child: Container(
              width: 500,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                borderRadius: BorderRadius.circular(10),
              ),
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
                      runSpacing: 15,
                      spacing: 15,
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
            ),
          ),
        );
      },
    );
  }
}
