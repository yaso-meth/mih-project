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
  //double paddingSize = 10;

  double getPaddingSize() {
    if (widget.borderOn) {
      return 10;
    } else {
      return 0;
    }
  }

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
    Size screenSize = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.only(
        left: getPaddingSize(),
        right: getPaddingSize(),
        bottom: getPaddingSize(),
        top: 0,
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 10,
          top: getPaddingSize(),
        ),
        width: screenSize.width,
        height: screenSize.height,
        decoration: getBoader(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: widget.bodyItems,
          ),
        ),
      ),
    );
  }
}
