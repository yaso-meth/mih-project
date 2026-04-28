import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:flutter/material.dart';

class MihCalculatorTile extends StatefulWidget {
  final double packageSize;

  const MihCalculatorTile({
    super.key,
    required this.packageSize,
  });

  @override
  State<MihCalculatorTile> createState() => _MihCalculatorTileState();
}

class _MihCalculatorTileState extends State<MihCalculatorTile> {
  @override
  Widget build(BuildContext context) {
    return MihPackageTile(
      onTap: () {
        context.pushNamed(
          "mihCalculator",
        );
      },
      packageName: "Calculator",
      packageIcon: Icon(
        MihIcons.calculator,
        color: MihColors.secondary(),
        // size: widget.packageSize,
      ),
      iconSize: widget.packageSize,
      textColor: MihColors.secondary(),
    );
  }
}
