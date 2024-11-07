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

  double getHorizontalPaddingSize(Size screenSize) {
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
      if (widget.borderOn) {
        return 10;
      } else {
        return 0;
      }
    } else {
      // mobile
      if (widget.borderOn) {
        return 10;
      } else {
        return 0;
      }
    }
  }

  double getVerticalPaddingSize(Size screenSize) {
    // mobile
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
        left: getHorizontalPaddingSize(screenSize),
        right: getHorizontalPaddingSize(screenSize),
        bottom: getVerticalPaddingSize(screenSize),
        top: 0,
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 10,
          top: getVerticalPaddingSize(screenSize),
        ),
        width: screenSize.width,
        height: screenSize.height,
        decoration: getBoader(),
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: widget.bodyItems,
            ),
          ),
        ),
      ),
    );
  }
}
