import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';

class MihMineSweeperTile extends StatefulWidget {
  final double packageSize;
  const MihMineSweeperTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MihMineSweeperTile> createState() => _MihMineSweeperTileState();
}

class _MihMineSweeperTileState extends State<MihMineSweeperTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        context.pushNamed(
          "mihMinesweeper",
        );
      },
      packageName: "Minesweeper",
      packageIcon: Icon(
        MihIcons.mineSweeper,
        color: MihColors.secondary(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
