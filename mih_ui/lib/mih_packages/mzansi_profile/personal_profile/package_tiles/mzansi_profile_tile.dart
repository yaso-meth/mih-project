import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:flutter/material.dart';

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
        context.pushNamed(
          'mzansiProfileManage',
        );
      },
      packageName: "Mzansi Profile",
      packageIcon: Icon(
        MihIcons.mihLogo,
        color: MihColors.secondary(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
