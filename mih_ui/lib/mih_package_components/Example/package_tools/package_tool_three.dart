import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_profile_links.dart';

class PackageToolThree extends StatefulWidget {
  const PackageToolThree({super.key});

  @override
  State<PackageToolThree> createState() => _PackageToolThreeState();
}

class _PackageToolThreeState extends State<PackageToolThree> {
  List<ProfileLink> links = [
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "YouTube",
      custom_name: "",
      destination: "https://www.youtube.com/@MzansiInnovationHub",
      order: 1,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Threads",
      custom_name: "",
      destination: "https://www.threads.com/@mzansi.innovation.hub",
      order: 2,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "TikTok",
      custom_name: "",
      destination: "https://www.tiktok.com/@mzansiinnovationhub",
      order: 3,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "WhatsApp",
      custom_name: "",
      destination: "https://whatsapp.com/channel/0029Vax3INCIyPtMn8KgeM2F",
      order: 4,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Twitch",
      custom_name: "",
      destination: "https://www.twitch.tv/mzansiinnovationhub",
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
      destination: "https://www.linkedin.com/in/yasien-meth-172352108/",
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
          "https://git.mzansi-innovation-hub.co.za/yaso_meth/mzansi_vim",
      order: 11,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Telegram",
      custom_name: "",
      destination: "https://t.me/unisagroupschannel",
      order: 11,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Pinterest",
      custom_name: "",
      destination: "https://za.pinterest.com/food/tomato-based-recipes-ideas/",
      order: 11,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Snapchat",
      custom_name: "",
      destination: "https://www.snapchat.com/",
      order: 11,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Messenger",
      custom_name: "",
      destination: "https://www.messenger.com/",
      order: 11,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Medium",
      custom_name: "",
      destination:
          "https://medium.com/flutter-community/the-ultimate-guide-flutter-architecture-template-ii-f86f9aa222e6",
      order: 11,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Substack",
      custom_name: "",
      destination: "https://substack.com/@flutterbytes",
      order: 11,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Spotify",
      custom_name: "",
      destination: "https://open.spotify.com/album/2oss3QgSxdNikts0shvMMo",
      order: 11,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "YouTube Music",
      custom_name: "",
      destination:
          "https://music.youtube.com/playlist?list=OLAK5uy_m9x66mE1zyhom3o_NPxmjf60HU1BjTXEE",
      order: 11,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Apple Music",
      custom_name: "",
      destination: "https://music.apple.com/us/album/bastholile/1812031316",
      order: 11,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Patreon",
      custom_name: "",
      destination: "https://www.patreon.com/c/MzansiInnovationHub",
      order: 11,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Loolio",
      custom_name: "",
      destination: "https://www.loolio.com/user/mzansiinnovationhub",
      order: 11,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "WeChat",
      custom_name: "",
      destination: "https://www.wechat.com/en",
      order: 11,
    ),
    ProfileLink(
      idprofile_links: 1,
      app_id: "1234",
      business_id: "",
      site_name: "Other",
      custom_name: "My App",
      destination: "https://app.mzansi-innovation-hub.co.za/about",
      order: 12,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     MihProfileLinks(
        //       links: links,
        //       // links: [],
        //     ),
        //     const SizedBox(
        //       height: 20,
        //     ),
        Column(
      children: [
        MihProfileLinks(
          links: links,
          // links: [],
        ),
        Expanded(
          child: ReorderableListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                key: ValueKey("$index"),
                title: Text("Link SIte: ${links[index].site_name}"),
              );
            },
            itemCount: links.length,
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                var link = links.removeAt(oldIndex);
                links.insert(newIndex, link);
              });
            },
          ),
        ),
      ],
    );
    //   ],
    // );
  }
}
