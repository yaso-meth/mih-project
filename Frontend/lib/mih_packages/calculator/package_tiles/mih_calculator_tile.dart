import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih_app_tile.dart';
import 'package:flutter/material.dart';

class MihCalculatorTile extends StatefulWidget {
  final bool personalSelected;
  const MihCalculatorTile({
    super.key,
    required this.personalSelected,
  });

  @override
  State<MihCalculatorTile> createState() => _MihCalculatorTileState();
}

class _MihCalculatorTileState extends State<MihCalculatorTile> {
  @override
  Widget build(BuildContext context) {
    return MihAppTile(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/calculator',
          arguments: widget.personalSelected,
        );
      },
      appName: "Calculator",
      appIcon: Padding(
        padding: const EdgeInsets.all(0),
        child: Icon(
          Icons.calculate,
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        ),
      ),
      iconSize: 200,
      primaryColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      secondaryColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
    );
  }
}
