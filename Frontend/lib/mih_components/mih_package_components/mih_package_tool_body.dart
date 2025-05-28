import 'package:mzansi_innovation_hub/main.dart';
import 'package:flutter/material.dart';

class MihPackageToolBody extends StatefulWidget {
  final bool borderOn;
  final Widget bodyItem;
  const MihPackageToolBody({
    super.key,
    required this.borderOn,
    required this.bodyItem,
  });

  @override
  State<MihPackageToolBody> createState() => _MihPackageToolBodyState();
}

class _MihPackageToolBodyState extends State<MihPackageToolBody> {
  late double _innerBodyPadding;
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
      _innerBodyPadding = 10.0;
      return BoxDecoration(
        color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 3.0),
      );
    } else {
      _innerBodyPadding = 0.0;
      return BoxDecoration(
        color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            width: 3.0),
      );
    }
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
        height: screenSize.height,
        decoration: getBoader(),
        child: Padding(
          padding: EdgeInsets.all(_innerBodyPadding),
          child: widget.bodyItem,
        ),
      ),
    );
  }
}
