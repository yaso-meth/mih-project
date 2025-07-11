import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tile.dart';

class MzansiDirectoryTile extends StatefulWidget {
  final double packageSize;
  const MzansiDirectoryTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MzansiDirectoryTile> createState() => _MzansiDirectoryTileState();
}

class _MzansiDirectoryTileState extends State<MzansiDirectoryTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mzansi-directory',
          // arguments: WalletArguments(widget.signedInUser, 0),
        );
      },
      appName: "Mzansi Directory",
      appIcon: Icon(
        MihIcons.mzansiDirectory,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
