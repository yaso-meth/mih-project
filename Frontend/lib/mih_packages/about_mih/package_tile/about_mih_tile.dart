import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';

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
    return MihPackageTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/about',
          arguments: 0,
        );
      },
      appName: "About MIH",
      appIcon: Icon(
        MihIcons.aboutMih,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
