import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_profile_links.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';

class PackageToolThree extends StatefulWidget {
  const PackageToolThree({super.key});

  @override
  State<PackageToolThree> createState() => _PackageToolThreeState();
}

class _PackageToolThreeState extends State<PackageToolThree> {
  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
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
        destination: "Threads",
        web_link: "https://www.threads.com/@mzansi.innovation.hub",
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
        destination: "WhatsApp",
        web_link: "https://whatsapp.com/channel/0029Vax3INCIyPtMn8KgeM2F",
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
        web_link: "https://www.linkedin.com/in/yasien-meth-172352108/",
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
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "Discord",
        web_link: "https://discord.gg/ZtTZYd5d",
      ),
      ProfileLink(
        idprofile_links: 1,
        app_id: "1234",
        business_id: "",
        destination: "My App",
        web_link: "https://app.mzansi-innovation-hub.co.za/about",
      ),
    ];

    return Stack(
      children: [
        MihSingleChildScroll(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MihProfileLinks(
                links: links,
                // links: [],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
