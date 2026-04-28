import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:flutter/material.dart';

class MzansiAiTile extends StatefulWidget {
  final double packageSize;

  const MzansiAiTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MzansiAiTile> createState() => _MzansiAiTileState();
}

class _MzansiAiTileState extends State<MzansiAiTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        context.pushNamed(
          'mzansiAi',
        );
        // Navigator.of(context).pushNamed(
        //   '/mzansi-ai',
        //   arguments: MzansiAiArguments(
        //     widget.signedInUser,
        //     "",
        //   ),
        // );
      },
      packageName: "Mzansi AI",
      packageIcon: Icon(
        MihIcons.mzansiAi,
        color: MihColors.secondary(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
