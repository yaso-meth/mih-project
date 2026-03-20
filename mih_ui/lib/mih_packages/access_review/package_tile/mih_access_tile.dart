import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:flutter/material.dart';

class MihAccessTile extends StatefulWidget {
  final double packageSize;

  const MihAccessTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MihAccessTile> createState() => _MihAccessTileState();
}

class _MihAccessTileState extends State<MihAccessTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      authenticateUser: true,
      onTap: () {
        context.goNamed(
          "mihAccess",
        );
        // Navigator.of(context).pushNamed(
        //   '/mih-access',
        //   arguments: widget.signedInUser,
        // );
      },
      packageName: "Access Controls",
      packageIcon: Icon(
        MihIcons.accessControl,
        color: MihColors.secondary(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
