import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
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
        context.goNamed(
          'businessProfileSetup',
          extra: profileProvider.user,
        );
        // Navigator.of(context).pushNamed(
        //   '/business-profile/set-up',
        //   arguments: widget.signedInUser,
        // );
      },
      appName: "Set Up Business",
      appIcon: Icon(
        MihIcons.businessSetup,
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
    );
  }
}
