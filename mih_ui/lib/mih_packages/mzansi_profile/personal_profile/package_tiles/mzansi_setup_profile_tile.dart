import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:flutter/material.dart';

class MzansiSetupProfileTile extends StatefulWidget {
  final double packageSize;

  const MzansiSetupProfileTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MzansiSetupProfileTile> createState() => _MzansiSetupProfileTileState();
}

class _MzansiSetupProfileTileState extends State<MzansiSetupProfileTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        context.goNamed(
          'mzansiProfileManage',
        );
      },
      packageName: "Set Up Profile",
      packageIcon: Icon(
        MihIcons.profileSetup,
        color: MihColors.secondary(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
