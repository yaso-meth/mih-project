import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih_app_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          arguments: widget.signedInUser,
        );
      },
      appName: "Mzansi Wallet",
      appIcon: Container(
        padding: const EdgeInsets.all(25),
        child: FaIcon(
          FontAwesomeIcons.wallet,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: widget.packageSize,
        ),
      ),
      iconSize: 200,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
