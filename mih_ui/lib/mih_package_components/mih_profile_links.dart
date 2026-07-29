import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MihProfileLinks extends StatefulWidget {
  final List<ProfileLink> links;
  final double? buttonSize;
  final bool displayCustomName;
  const MihProfileLinks({
    super.key,
    required this.links,
    required this.displayCustomName,
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
      case "play store":
        iconData = MihIcons.playStore;
        btnColor = const Color(0xFF01875f);
        iconColor = const Color(0xFFe6f3ef);
        break;
      case "app store":
        iconData = MihIcons.appStore;
        btnColor = const Color(0xFF0066cc);
        break;
      case "app gallery":
        iconData = MihIcons.appGallery;
        btnColor = const Color(0xFFCF0A2C);
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
            size: widget.buttonSize != null
                ? widget.buttonSize! * 0.65
                : 70 * 0.7,
          ),
        ),
        if (widget.displayCustomName && link.custom_name != '')
          const SizedBox(height: 2),
        if (widget.displayCustomName && link.custom_name != '')
          Text(
            link.custom_name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
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
        return Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          runSpacing: 10,
          spacing: 10,
          children: widget.links.map(
            (link) {
              return displayLinkButton(link);
            },
          ).toList(),
        );
      },
    );
  }
}
