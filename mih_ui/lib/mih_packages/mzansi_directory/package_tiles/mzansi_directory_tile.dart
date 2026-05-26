import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';

class MzansiDirectoryTile extends StatefulWidget {
  final double packageSize;
  const MzansiDirectoryTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MzansiDirectoryTile> createState() => _MzansiDirectoryTileState();
}

class _MzansiDirectoryTileState extends State<MzansiDirectoryTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        context.goNamed(
          "mzansiDirectory",
        );
        // Navigator.of(context).pushNamed(
        //   '/mzansi-directory',
        //   arguments: MzansiDirectoryArguments(
        //     personalSearch: true,
        //     startSearchText: null,
        //   ),
        // );
      },
      packageName: "Mzansi Directory",
      packageIcon: Icon(
        MihIcons.mzansiDirectory,
        color: MihColors.secondary(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
