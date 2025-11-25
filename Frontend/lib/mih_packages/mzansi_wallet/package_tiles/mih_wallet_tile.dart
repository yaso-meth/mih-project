import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MihWalletTile extends StatefulWidget {
  final double packageSize;

  const MihWalletTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MihWalletTile> createState() => _MihWalletTileState();
}

class _MihWalletTileState extends State<MihWalletTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      // authenticateUser: true,
      onTap: () {
        context.goNamed(
          'mzansiWallet',
        );
        // Navigator.of(context).pushNamed(
        //   '/mzansi-wallet',
        //   arguments: WalletArguments(widget.signedInUser, 0),
        // );
      },
      appName: "Mzansi Wallet",
      appIcon: Icon(
        MihIcons.mzansiWallet,
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      primaryColor: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      secondaryColor: MihColors.getPrimaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
  }
}
