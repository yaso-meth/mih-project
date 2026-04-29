import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MihProfileLinks extends StatefulWidget {
  final List<ProfileLink> links;
  final double? buttonSize;
  const MihProfileLinks({
    super.key,
    required this.links,
    this.buttonSize,
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
        btnColor = MihColors.secondary();
        iconColor = Colors.black;
    }
    return MihButton(
      width: widget.buttonSize ?? 70,
      height: widget.buttonSize ?? 70,
      onPressed: () {
        launchSocialUrl(Uri.parse(link.web_link));
      },
      buttonColor: btnColor,
      child: FaIcon(
        iconData,
        color: iconColor,
        size: 40,
      ),
    );
    // return MihPackageTile(
    //   onTap: () {
    //     launchSocialUrl(Uri.parse(link.web_link));
    //   },
    //   packageName: link.destination,
    //   packageIcon: Icon(
    //     iconData,
    //     color: btnColor,
    //   ),
    //   iconSize: 200,
    //   textColor: Colors.black,
    //   // MihColors.primary(
    //   //     ),
    // );
  }

  Future<void> launchSocialUrl(Uri linkUrl) async {
    if (!await launchUrl(linkUrl)) {
      throw Exception('Could not launch $linkUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          Widget? child) {
        // return widget.links.isEmpty
        //     ? SizedBox(
        //         height: 35,
        //         child: Text(
        //           "No Links Added",
        //           textAlign: TextAlign.center,
        //           style: TextStyle(
        //             fontSize: 25,
        //             fontWeight: FontWeight.bold,
        //             color: MihColors.secondary(),
        //           ),
        //         ),
        //       )
        //     :
        return Column(
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              runSpacing: 10,
              spacing: 10,
              children: widget.links.map(
                (link) {
                  return displayLinkButton(link);
                },
              ).toList(),
            ),
          ],
        );
      },
    );
  }
}
