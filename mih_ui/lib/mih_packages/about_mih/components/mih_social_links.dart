import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_profile_links.dart';

class MihSocialLinks extends StatefulWidget {
  const MihSocialLinks({super.key});

  @override
  State<MihSocialLinks> createState() => _MihSocialLinksState();
}

class _MihSocialLinksState extends State<MihSocialLinks> {
  List<ProfileLink> links = [
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Youtube",
      custom_name: "",
      destination: "https://www.youtube.com/@MzansiInnovationHub",
      order: 1,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "TikTok",
      custom_name: "",
      destination: "https://www.tiktok.com/@mzansiinnovationhub",
      order: 2,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Twitch",
      custom_name: "",
      destination: "https://www.twitch.tv/mzansiinnovationhub",
      order: 3,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Threads",
      custom_name: "",
      destination: "https://www.threads.com/@mzansi.innovation.hub",
      order: 4,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "WhatsApp",
      custom_name: "",
      destination: "https://whatsapp.com/channel/0029Vax3INCIyPtMn8KgeM2F",
      order: 5,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Instagram",
      custom_name: "",
      destination: "https://www.instagram.com/mzansi.innovation.hub/",
      order: 6,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "X",
      custom_name: "",
      destination: "https://x.com/mzansi_inno_hub",
      order: 7,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "LinkedIn",
      custom_name: "",
      destination: "https://www.linkedin.com/company/mzansi-innovation-hub/",
      order: 8,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Facebook",
      custom_name: "",
      destination: "https://www.facebook.com/profile.php?id=61565345762136",
      order: 9,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Reddit",
      custom_name: "",
      destination: "https://www.reddit.com/r/Mzani_Innovation_Hub/",
      order: 10,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Git",
      custom_name: "",
      destination:
          "https://git.mzansi-innovation-hub.co.za/yaso_meth/mih-project",
      order: 11,
    ),
  ];
  @override
  Widget build(BuildContext context) {
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
        MihProfileLinks(
          links: links,
          displayCustomName: false,
        ),
        const SizedBox(
          height: 75,
        ),
      ],
    );
  }
}
