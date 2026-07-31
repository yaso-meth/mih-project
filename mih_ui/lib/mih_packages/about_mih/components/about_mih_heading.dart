import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_providers/about_mih_provider.dart';
import 'package:provider/provider.dart';

class AboutMihHeading extends StatefulWidget {
  const AboutMihHeading({super.key});

  @override
  State<AboutMihHeading> createState() => _AboutMihHeadingState();
}

class _AboutMihHeadingState extends State<AboutMihHeading> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AboutMihProvider>(
      builder: (BuildContext context, AboutMihProvider aboutProvider,
          Widget? child) {
        return Column(
          children: [
            SizedBox(
              width: 165,
              child: FittedBox(
                child: Icon(
                  MihIcons.mihLogo,
                  color: MihColors.secondary(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Mzansi Innovation Hub",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            Text(
              "MIH App Version: ${aboutProvider.version}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }
}
