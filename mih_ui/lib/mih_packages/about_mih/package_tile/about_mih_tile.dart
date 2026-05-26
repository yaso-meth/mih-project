import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:flutter/material.dart';

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
        context.goNamed(
          "aboutMih",
        );
        // Navigator.of(context).pushNamed(
        //   '/about',
        //   arguments: 0,
        // );
      },
      packageName: "About MIH",
      packageIcon: Icon(
        MihIcons.aboutMih,
        color: MihColors.secondary(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
