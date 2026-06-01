import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:provider/provider.dart';

class MzansiSetupBusinessProfileTile extends StatefulWidget {
  final double packageSize;
  const MzansiSetupBusinessProfileTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MzansiSetupBusinessProfileTile> createState() =>
      _MzansiSetupBusinessProfileTileState();
}

class _MzansiSetupBusinessProfileTileState
    extends State<MzansiSetupBusinessProfileTile> {
  @override
  Widget build(BuildContext context) {
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    return MihPackageTile(
      onTap: () {
        context.pushNamed(
          'businessProfileSetup',
          extra: profileProvider.user,
        );
        // Navigator.of(context).pushNamed(
        //   '/business-profile/set-up',
        //   arguments: widget.signedInUser,
        // );
      },
      packageName: "Set Up Business",
      packageIcon: Icon(
        MihIcons.businessSetup,
        color: MihColors.secondary(),
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
