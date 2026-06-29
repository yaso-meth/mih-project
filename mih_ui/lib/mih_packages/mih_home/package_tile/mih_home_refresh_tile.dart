import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_providers/about_mih_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_wallet_provider.dart';
import 'package:provider/provider.dart';

class MihHomeRefreshTile extends StatefulWidget {
  final double packageSize;
  const MihHomeRefreshTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MihHomeRefreshTile> createState() => _MihHomeRefreshTileState();
}

class _MihHomeRefreshTileState extends State<MihHomeRefreshTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () async {
        MzansiProfileProvider profileProvider =
            context.read<MzansiProfileProvider>();
        profileProvider.triggerRefresh();
      },
      packageName: "Sync Data",
      packageIcon: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            MihIcons.mihRing,
            color: MihColors.secondary(),
          ),
          Center(
            child: Transform.scale(
              scale: 0.75,
              origin: Offset(-4, 0),
              child: Icon(
                Icons.cloud_sync_rounded,
                color: MihColors.secondary(),
              ),
            ),
          ),
        ],
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
