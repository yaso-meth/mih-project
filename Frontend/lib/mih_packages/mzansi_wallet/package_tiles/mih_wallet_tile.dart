import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tile.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MihWalletTile extends StatefulWidget {
  final AppUser signedInUser;
  const MihWalletTile({
    super.key,
    required this.signedInUser,
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
      appIcon: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FaIcon(
          FontAwesomeIcons.wallet,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          size: 200,
        ),
      ),
      iconSize: 200,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
