import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutMihTile extends StatefulWidget {
  final double packageSize;
  const AboutMihTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<AboutMihTile> createState() => _AboutMihTileState();
}

class _AboutMihTileState extends State<AboutMihTile> {
  @override
  Widget build(BuildContext context) {
    return MihAppTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/about',
          arguments: 0,
        );
      },
      appName: "About MIH",
      appIcon: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(25),
        child: FaIcon(
          FontAwesomeIcons.circleInfo,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: widget.packageSize,
        ),
      ),
      // Icon(
      //   Icons.info,
      //   color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
      // ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
