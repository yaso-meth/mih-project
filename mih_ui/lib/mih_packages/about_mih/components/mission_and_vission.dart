import 'package:flutter/material.dart';

class MissionAndVission extends StatefulWidget {
  const MissionAndVission({super.key});

  @override
  State<MissionAndVission> createState() => _MissionAndVissionState();
}

class _MissionAndVissionState extends State<MissionAndVission> {
  Widget ourVision() {
    String heading = "Our Vision";
    String vision =
        "Digitizing Mzansi one process at a time. Discover essential Mzansi apps to streamline your personal and professional life. Simplify your daily tasks with our user-friendly solutions.";
    return SizedBox(
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
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
          Text(
            vision,
            textAlign: TextAlign.center,
            style: const TextStyle(
              //fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  Widget ourMission() {
    String heading = "Our Mission";
    String mission =
        "Bridge the digital divide in Mzansi, ensuring that everyone can benefit from the power of technology. We empower lives by providing simple, elegant solutions that elevate daily experiences. With our user-friendly approach, we're making the digital world accessible to all, ensuring no one is left behind in the digital revolution.";
    return SizedBox(
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
          Text(
            mission,
            textAlign: TextAlign.center,
            style: const TextStyle(
              //fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 10,
            runSpacing: 10,
            children: [
              ourVision(),
              ourMission(),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
