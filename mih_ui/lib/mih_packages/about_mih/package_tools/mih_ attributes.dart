import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:url_launcher/url_launcher.dart';

class MihAttributes extends StatefulWidget {
  const MihAttributes({super.key});

  @override
  State<MihAttributes> createState() => _MihAttributesState();
}

class _MihAttributesState extends State<MihAttributes> {
  Future<void> launchUrlLink(Uri linkUrl) async {
    if (!await launchUrl(linkUrl)) {
      throw Exception('Could not launch $linkUrl');
    }
  }

  Widget displayAttribution(IconData resource, String creator, String link) {
    return GestureDetector(
      onTap: () {
        launchUrlLink(
          Uri.parse(
            link,
          ),
        );
      },
      child: Column(
        children: [
          Icon(
            resource,
            color: MihColors.secondary(),
            size: 100,
          ),
          const SizedBox(height: 5),
          Text(
            creator,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    String message =
        "Some APIs, Icons and Assets used in MIH were sourced from third party providers.\n";
    message +=
        "We are grateful to the talented creators for providing these resources.\n";
    message +=
        "As per the terms for free use for these third party providers, the following assets require attribution";

    return MihSingleChildScroll(
      scrollbarOn: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            Icon(
              MihIcons.mihLogo,
              color: MihColors.secondary(),
              size: 165,
            ),
            const SizedBox(
              height: 10,
            ),
            SelectableText(
              message,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 900,
              child: Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 10,
                spacing: 10,
                children: [
                  displayAttribution(MihIcons.mihRing, "Tarah Meth",
                      "https://www.linkedin.com/in/tarah-meth-3b6309254/"),
                  displayAttribution(MihIcons.mihLogo, "Tarah Meth",
                      "https://www.linkedin.com/in/tarah-meth-3b6309254/"),
                  displayAttribution(
                      MihIcons.ollama, "Ollama", "https://ollama.com/"),
                  displayAttribution(MihIcons.wallet, "Freepik",
                      "https://www.flaticon.com/free-icon/wallet-passes-app_3884407?term=wallet&page=1&position=21&origin=search&related_id=3884407"),
                  displayAttribution(MihIcons.patientFile, "RaftelDesign",
                      "https://www.flaticon.com/free-icon/patient_2376100?term=medication&page=1&position=6&origin=search&related_id=2376100"),
                  displayAttribution(MihIcons.patientFile, "Srip",
                      "https://www.flaticon.com/free-icon/hospital_1233930?term=medical+snake&page=1&position=7&origin=search&related_id=1233930"),
                  displayAttribution(MihIcons.calendar, "Freepik",
                      "https://www.flaticon.com/free-icon/calendar_2278049?term=calendar&page=1&position=5&origin=search&related_id=2278049"),
                  displayAttribution(MihIcons.calculator, "Freepik",
                      "https://www.flaticon.com/free-icon/calculator_2374409?term=calculator&page=1&position=20&origin=search&related_id=2374409"),
                  displayAttribution(MihIcons.info, "Chanut",
                      "https://www.flaticon.com/free-icon/info_151776?term=about&page=1&position=8&origin=search&related_id=151776"),
                  displayAttribution(MihIcons.user, "Freepik",
                      "https://www.flaticon.com/free-icon/user_1077063?term=profile&page=1&position=6&origin=search&related_id=1077063"),
                  displayAttribution(MihIcons.business, "Gravisio",
                      "https://www.flaticon.com/free-icon/contractor_11813336?term=company+profile&page=1&position=2&origin=search&related_id=11813336"),
                  displayAttribution(MihIcons.doctor, "Vector Tank",
                      "https://www.flaticon.com/free-icon/doctor_10215061?term=doctor&page=1&position=73&origin=search&related_id=10215061"),
                  displayAttribution(MihIcons.addUser, "Freepik",
                      "https://www.flaticon.com/free-icon/add-user_748137?term=profile+add&page=1&position=1&origin=search&related_id=748137"),
                  displayAttribution(MihIcons.addBusiness, "kerismaker",
                      "https://www.flaticon.com/free-icon/business_13569850?term=company+add&page=1&position=25&origin=search&related_id=13569850"),
                  displayAttribution(MihIcons.calculator, "fawazahmed0",
                      "https://github.com/fawazahmed0/exchange-api"),
                  displayAttribution(MihIcons.iDontKnow, "Freepik",
                      "https://www.flaticon.com/free-icon/i-dont-know_5359909?term=i+dont+know&page=1&position=7&origin=search&related_id=5359909"),
                  displayAttribution(MihIcons.accessControls, "Freepik",
                      "https://www.flaticon.com/free-icon/access-control_7426564?term=user+access&page=1&position=19&origin=search&related_id=7426564"),
                  displayAttribution(MihIcons.appleMusic, "Mayor Icons",
                      "https://www.flaticon.com/free-icon/music_7566196?term=apple+music&related_id=7566196"),
                  displayAttribution(MihIcons.discord, "Freepik",
                      "https://www.flaticon.com/free-icon/discord_5968898?term=discord&page=1&position=3&origin=search&related_id=5968898"),
                  displayAttribution(MihIcons.facebook, "High Quality Icons",
                      "https://www.flaticon.com/free-icon/facebook_2175193?term=facebook&page=1&position=5&origin=search&related_id=2175193"),
                  displayAttribution(MihIcons.git, "Pocike",
                      "https://www.flaticon.com/free-icon/facebook_2175193?term=facebook&page=1&position=5&origin=search&related_id=2175193"),
                  displayAttribution(MihIcons.instagram, "Freepik",
                      "https://www.flaticon.com/free-icon/instagram_1384031?term=instagram&page=1&position=5&origin=search&related_id=1384031"),
                  displayAttribution(MihIcons.linkedin, "Raijulislam",
                      "https://www.flaticon.com/free-icon/linkedin_3536569?term=linkedin&page=1&position=2&origin=search&related_id=3536569"),
                  displayAttribution(MihIcons.medium, "Freepik",
                      "https://www.flaticon.com/free-icon/medium_5968885?term=medium&page=1&position=7&origin=search&related_id=5968885"),
                  displayAttribution(MihIcons.messenger, "Freepik",
                      "https://www.flaticon.com/free-icon/chat_9333888?term=messenger&page=1&position=8&origin=search&related_id=9333888"),
                  displayAttribution(MihIcons.pinterest, "Pixel Perfect",
                      "https://www.flaticon.com/free-icon/pinterest_733622?term=pinterest&page=1&position=6&origin=search&related_id=733622"),
                  displayAttribution(MihIcons.reddit, "NajmunNahar",
                      "https://www.flaticon.com/free-icon/reddit_3128263?term=reddit&page=1&position=5&origin=search&related_id=3128263"),
                  displayAttribution(MihIcons.snapchat, "Pixel Perfect",
                      "https://www.flaticon.com/free-icon/snapchat_733627?term=snapchat&page=1&position=6&origin=search&related_id=733627"),
                  displayAttribution(MihIcons.spotify, "Freepik",
                      "https://www.flaticon.com/free-icon/spotify-logo_87409?term=spotify&page=1&position=2&origin=search&related_id=87409"),
                  displayAttribution(MihIcons.threads, "Freepik",
                      "https://www.flaticon.com/free-icon/threads_12105336?term=threads&page=1&position=1&origin=search&related_id=12105336"),
                  displayAttribution(MihIcons.tiktok, "Freepik",
                      "https://www.flaticon.com/free-icon/tik-tok_3046120?term=tiktok&page=1&position=1&origin=search&related_id=3046120"),
                  displayAttribution(MihIcons.wechat, "Pixel Perfect",
                      "https://www.flaticon.com/free-icon/wechat_732142?term=wechat&page=1&position=2&origin=search&related_id=732142"),
                  displayAttribution(MihIcons.whatsapp, "Pixel Perfect",
                      "https://www.flaticon.com/free-icon/whatsapp_2111774?term=whatsapp&page=1&position=8&origin=search&related_id=2111774"),
                  displayAttribution(MihIcons.x, "Freepik",
                      "https://www.flaticon.com/free-icon/twitter_5968958?term=x&page=1&position=5&origin=search&related_id=5968958"),
                  displayAttribution(MihIcons.iDontKnow, "Freepik",
                      "https://www.flaticon.com/free-icon/i-dont-know_5359909?term=i+dont+know&page=1&position=7&origin=search&related_id=5359909"),
                  displayAttribution(MihIcons.youtube, "Freepik",
                      "https://www.flaticon.com/free-icon/youtube_152810?term=youtube&page=1&position=9&origin=search&related_id=152810"),
                  displayAttribution(MihIcons.youtubeMusic, "Kawalanicon",
                      "https://www.flaticon.com/free-icon/music_15069232?term=youtube+music&page=1&position=4&origin=search&related_id=15069232"),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
