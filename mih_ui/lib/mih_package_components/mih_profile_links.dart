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
    switch (link.site_name.toLowerCase()) {
      case "youtube":
        // iconData = FontAwesomeIcons.youtube;
        iconData = MihIcons.youtube;
        btnColor = const Color(0xFFFF0000);
        break;
      case "tiktok":
        iconData = MihIcons.tiktok;
        btnColor = const Color(0xFF000000);
        break;
      case "twitch":
        iconData = MihIcons.twitch;
        btnColor = const Color(0xFF6441a5);
        break;
      case "threads":
        iconData = MihIcons.threads;
        btnColor = const Color(0xFF000000);
        break;
      case "whatsapp":
        iconData = MihIcons.whatsapp;
        btnColor = const Color(0xFF25D366);
        break;
      case "instagram":
        iconData = MihIcons.instagram;
        btnColor = const Color(0xFFF56040);
        break;
      case "x":
        iconData = MihIcons.x;
        btnColor = const Color(0xFF000000);
        break;
      case "linkedin":
        iconData = MihIcons.linkedin;
        btnColor = const Color(0xFF0a66c2);
        break;
      case "facebook":
        iconData = MihIcons.facebook;
        btnColor = const Color(0xFF4267B2);
        break;
      case "reddit":
        iconData = MihIcons.reddit;
        btnColor = const Color(0xFFFF4500);
        break;
      case "discord":
        iconData = MihIcons.discord;
        btnColor = const Color(0xFF5865F2);
        break;
      case "git":
        iconData = MihIcons.git;
        btnColor = const Color(0xFFf14e32);
        break;
      case "telegram":
        iconData = MihIcons.telegram;
        btnColor = const Color(0xFF0088cc);
        break;
      case "pinterest":
        iconData = MihIcons.pinterest;
        btnColor = const Color(0xFFe60023);
        break;
      case "snapchat":
        iconData = MihIcons.snapchat;
        btnColor = const Color(0xFFfffc00);
        iconColor = Colors.black;
        break;
      case "messenger":
        iconData = MihIcons.messenger;
        btnColor = const Color(0xFF0084ff);
        break;
      case "medium":
        iconData = MihIcons.medium;
        btnColor = const Color(0xFF000000);
        break;
      case "substack":
        iconData = MihIcons.substack;
        btnColor = const Color(0xFFFF7731);
        break;
      case "spotify":
        iconData = MihIcons.spotify;
        btnColor = const Color(0xFF1db954);
        iconColor = Colors.black;
        break;
      case "yt music":
        iconData = MihIcons.youtubeMusic;
        btnColor = const Color(0xFFFF0000);
        iconColor = Colors.white;
        break;
      case "apple music":
        iconData = MihIcons.appleMusic;
        btnColor = const Color(0xFFff4e6b);
        break;
      case "patreon":
        iconData = MihIcons.patreon;
        btnColor = const Color(0xFF000000);
        break;
      case "loolio":
        iconData = MihIcons.loolio;
        btnColor = const Color(0xFF24244a);
        iconColor = const Color(0xFF5fc343);
        break;
      case "wechat":
        iconData = MihIcons.wechat;
        btnColor = const Color(0xFFff4e6b);
        break;
      default:
        // iconData = FontAwesomeIcons.link;
        iconData = MihIcons.link;
        btnColor = MihColors.secondary();
        iconColor = MihColors.primary();
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MihButton(
          width: widget.buttonSize ?? 70,
          height: widget.buttonSize ?? 70,
          onPressed: () {
            launchSocialUrl(Uri.parse(link.destination));
          },
          buttonColor: btnColor,
          child: Icon(
            iconData,
            color: iconColor,
            size: 50,
          ),
        ),
        const SizedBox(height: 2),
        if (link.custom_name.isNotEmpty)
          Text(
            link.custom_name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        // link.custom_name.isNotEmpty
        //     ? Text(link.custom_name)
        //     : Text(link.site_name),
      ],
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
              runAlignment: WrapAlignment.center,
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
