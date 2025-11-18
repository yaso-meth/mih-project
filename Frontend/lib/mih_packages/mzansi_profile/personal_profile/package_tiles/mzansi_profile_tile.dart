import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tile.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MzansiProfileTile extends StatefulWidget {
  final double packageSize;

  const MzansiProfileTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MzansiProfileTile> createState() => _MzansiProfileTileState();
}

class _MzansiProfileTileState extends State<MzansiProfileTile> {
  @override
  Widget build(BuildContext context) {
    // ImageProvider logo = MzansiInnovationHub.of(context)!.theme.logoImage();
    return MihPackageTile(
      onTap: () {
        context.goNamed(
          'mzansiProfileManage',
        );
      },
      appName: "Mzansi Profile",
      appIcon: Icon(
        MihIcons.mihLogo,
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
