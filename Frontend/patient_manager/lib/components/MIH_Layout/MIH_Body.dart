import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MIHBody extends StatefulWidget {
  final bool borderOn;
  final List<Widget> bodyItems;
  const MIHBody({
    super.key,
    required this.borderOn,
    required this.bodyItems,
  });

  @override
  State<MIHBody> createState() => _MIHBodyState();
}

class _MIHBodyState extends State<MIHBody> {
  double paddingSize = 10;

  Decoration? getBoader() {
    if (widget.borderOn) {
      return BoxDecoration(
        color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 3.0),
      );
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(
          left: paddingSize,
          right: paddingSize,
          bottom: paddingSize,
        ),
        child: Container(
          //height: height - 100,
          decoration: getBoader(),
          child: Column(
            children: widget.bodyItems,
          ),
        ),
      ),
    );
  }
}
