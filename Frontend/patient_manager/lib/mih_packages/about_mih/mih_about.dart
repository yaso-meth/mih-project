import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_action.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_body.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_header.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_tile.dart';
import 'package:patient_manager/main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:html' as html;

class MIHAbout extends StatefulWidget {
  const MIHAbout({
    super.key,
  });

  @override
  State<MIHAbout> createState() => _MIHAboutState();
}

class _MIHAboutState extends State<MIHAbout> {
  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "About",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  MIHBody getBody() {
    String vision =
        "Digitizing Mzansi one process at a time. Discover essential Mzansi apps to streamline your personal and professional life. Simplify your daily tasks with our user-friendly solutions.";
    return MIHBody(
      borderOn: false,
      bodyItems: [
        SizedBox(
          width: 165,
          child: Image(
              image: MzanziInnovationHub.of(context)!.theme.altLogoImage()),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Mzansi Innovation Hub",
          style: TextStyle(
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
            fontSize: 15,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Divider(),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            founderProPic(),
            founderBio(),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Divider(),
        ),
        mihSocials(),
      ],
    );
  }

  Widget founderBio() {
    String bio = "";
    bio += "BSc Comnputer Science & Information Systems\n";
    bio += "(University of the Western Cap)\n";
    bio +=
        "6 Year of banking experience with one of the big 5 banks of South Africa.";
    return SizedBox(
      width: 400,
      child: Column(
        children: [
          Text(
            bio,
            textAlign: TextAlign.center,
            style: const TextStyle(
              //fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget founderProPic() {
    String heading = "Yasien Meth (Founder & CEO)";
    ImageProvider logoFrame =
        MzanziInnovationHub.of(context)!.theme.altLogoFrame();
    return Column(
      children: [
        Text(
          heading,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Stack(
          alignment: Alignment.center,
          fit: StackFit.loose,
          children: [
            CircleAvatar(
              backgroundColor:
                  MzanziInnovationHub.of(context)!.theme.primaryColor(),
              backgroundImage: const AssetImage("images/founder.jpg"),
              //'https://media.licdn.com/dms/image/D4D03AQGd1-QhjtWWpA/profile-displayphoto-shrink_400_400/0/1671698053061?e=2147483647&v=beta&t=a3dJI5yxs5-KeXjj10LcNCFuC9IOfa8nNn3k_Qyr0CA'),
              radius: 75,
            ),
            SizedBox(
              width: 165,
              child: Image(image: logoFrame),
            )
          ],
        ),
      ],
    );
  }

  Widget mihSocials() {
    String heading = "MIH Socials";
    return Column(
      children: [
        Text(
          heading,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 500,
          height: 300,
          child: GridView.builder(
            padding: const EdgeInsets.only(
                // left: width / 10,
                // right: width / 10,
                // //bottom: height / 5,
                // top: 20,
                ),
            // physics: ,
            // shrinkWrap: true,
            itemCount: getSocialsList().length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 15, maxCrossAxisExtent: 150),
            itemBuilder: (context, index) {
              return getSocialsList()[index];
            },
          ),
        ),
      ],
    );
  }

  List<Widget> getSocialsList() {
    List<Widget> socials = [];
    socials.add(MIHTile(
      onTap: () {
        html.window
            .open('https://www.tiktok.com/@mzansi.innovation.hub', 'new tab');
      },
      tileName: "TikTok",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.tiktok,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        html.window
            .open('https://www.instagram.com/mzansi.innovation.hub', 'new tab');
      },
      tileName: "Instagram",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.instagram,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        html.window
            .open('https://www.youtube.com/@mzansiinnovationhub', 'new tab');
      },
      tileName: "YouTube",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.youtube,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 175,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        html.window.open('https://x.com/mzansi_inno_hub', 'new tab');
      },
      tileName: "X",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.xTwitter,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        html.window.open(
            'https://www.linkedin.com/company/mzansi-innovation-hub/',
            'new tab');
      },
      tileName: "LinkedIn",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.linkedin,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    socials.add(MIHTile(
      onTap: () {
        html.window.open(
            'https://www.facebook.com/profile.php?id=61565345762136',
            'new tab');
      },
      tileName: "FaceBook",
      tileIcon: Center(
        child: FaIcon(
          FontAwesomeIcons.facebook,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      p: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      s: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    ));
    //==================================================================
    return socials;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(),
      body: getBody(),
    );
  }
}
