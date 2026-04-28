import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:flutter/material.dart';

class MzansiBusinessProfileTile extends StatefulWidget {
  final double packageSize;
  const MzansiBusinessProfileTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MzansiBusinessProfileTile> createState() =>
      _MzansiBusinessProfileTileState();
}

class _MzansiBusinessProfileTileState extends State<MzansiBusinessProfileTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        context.pushNamed(
          "businessProfileManage",
        );
        // Navigator.of(context).pushNamed(
        //   '/business-profile/manage',
        //   arguments: widget.arguments,
        // );
      },
      packageName: "Business Profile",
      packageIcon: Icon(
        MihIcons.businessProfile,
        color: MihColors.secondary(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
