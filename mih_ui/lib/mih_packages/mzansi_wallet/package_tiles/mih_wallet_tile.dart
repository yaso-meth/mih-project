import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:flutter/material.dart';

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
        context.pushNamed(
          'mzansiWallet',
        );
        // Navigator.of(context).pushNamed(
        //   '/mzansi-wallet',
        //   arguments: WalletArguments(widget.signedInUser, 0),
        // );
      },
      packageName: "Mzansi Wallet",
      packageIcon: Icon(
        MihIcons.mzansiWallet,
        color: MihColors.secondary(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
