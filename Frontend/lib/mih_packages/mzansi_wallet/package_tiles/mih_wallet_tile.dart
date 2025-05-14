import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_app_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';

class MihWalletTile extends StatefulWidget {
  final AppUser signedInUser;
  final double packageSize;

  const MihWalletTile({
    super.key,
    required this.signedInUser,
    required this.packageSize,
  });

  @override
  State<MihWalletTile> createState() => _MihWalletTileState();
}

class _MihWalletTileState extends State<MihWalletTile> {
  @override
  Widget build(BuildContext context) {
    return MihAppTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/mzansi-wallet',
          arguments: WalletArguments(widget.signedInUser, 0),
        );
      },
      appName: "Mzansi Wallet",
      appIcon: Icon(
        MihIcons.mzansiWallet,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
