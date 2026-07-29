import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';

class FounderDetails extends StatefulWidget {
  const FounderDetails({super.key});

  @override
  State<FounderDetails> createState() => _FounderDetailsState();
}

class _FounderDetailsState extends State<FounderDetails> {
  Widget founderTitle() {
    String heading = "Yasien Meth (Founder & CEO)";
    return Column(
      children: [
        Text(
          heading,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget founderBio() {
    String bio = "";
    bio += "BSc Computer Science & Information Systems\n";
    bio += "(University of the Western Cape)\n";
    bio +=
        "6 Year of banking experience with one of the big 5 banks of South Africa.";
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10,
      runSpacing: 10,
      children: [
        SizedBox(
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: CircleAvatar(
                  backgroundColor: MihColors.primary(),
                  backgroundImage: const AssetImage(
                      "lib/mih_package_components/assets/images/founder.jpg"),
                  //'https://media.licdn.com/dms/image/D4D03AQGd1-QhjtWWpA/profile-displayphoto-shrink_400_400/0/1671698053061?e=2147483647&v=beta&t=a3dJI5yxs5-KeXjj10LcNCFuC9IOfa8nNn3k_Qyr0CA'),
                  radius: 75,
                ),
              ),
              Icon(
                MihIcons.mihRing,
                size: 165,
                color: MihColors.secondary(),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 400,
          child: Text(
            bio,
            textAlign: TextAlign.center,
            style: const TextStyle(
              //fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        founderTitle(),
        founderBio(),
      ],
    );
  }
}
