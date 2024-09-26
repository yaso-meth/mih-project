import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MIHWindow extends StatefulWidget {
  final String windowTitle;
  final List<Widget> windowItems;
  final List<Widget> actionItems;
  final void Function() onTapClose;
  const MIHWindow({
    super.key,
    required this.windowTitle,
    required this.windowItems,
    required this.actionItems,
    required this.onTapClose,
  });

  @override
  State<MIHWindow> createState() => _MIHWindowState();
}

class _MIHWindowState extends State<MIHWindow> {
  late double windowTitleSize;
  late double horizontralWindowPadding;
  late double vertticalWindowPadding;
  late double windowWidth;
  late double windowHeight;
  late double width;
  late double height;

  void checkScreenSize() {
    print("screen width: $width");
    print("screen height: $height");
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
      setState(() {
        windowTitleSize = 25;
        horizontralWindowPadding = width / 7;
        vertticalWindowPadding = 25;
        windowWidth = width;
        windowHeight = height;
      });
    } else {
      setState(() {
        windowTitleSize = 20;
        horizontralWindowPadding = 10;
        vertticalWindowPadding = 10;
        windowWidth = width;
        windowHeight = height;
      });
    }
  }

  List<Widget> getWindowItems() {
    List<Widget> temp = [];
    temp.add(const SizedBox(height: 10));
    temp.add(
      SizedBox(
        width: windowWidth - 150,
        child: Text(
          widget.windowTitle,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            fontSize: windowTitleSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
      temp.addAll(widget.windowItems);
      return temp;
    } else {
      //temp.add(const SizedBox(height: 25));
      temp.addAll(widget.windowItems);
      return temp;
    }
  }

  Widget windowPopUp() {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: horizontralWindowPadding,
        vertical: vertticalWindowPadding,
      ),
      insetAnimationCurve: Easing.emphasizedDecelerate,
      insetAnimationDuration: Durations.short1,
      child: Stack(
        children: [
          Container(
            //padding: const EdgeInsets.all(10),
            width: windowWidth,
            height: windowHeight,
            decoration: BoxDecoration(
              color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  width: 5.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: getWindowItems(),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            height: 50,
            child: IconButton(
              onPressed: widget.onTapClose,
              icon: Icon(
                Icons.close,
                color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                size: 35,
              ),
            ),
          ),
          Positioned(
              top: 5,
              left: 5,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: widget.actionItems,
              )),
        ],
      ),
    );
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
    var size = MediaQuery.of(context).size;
    setState(() {
      width = size.width;
      height = size.height;
    });
    checkScreenSize();
    return windowPopUp();
  }
}
