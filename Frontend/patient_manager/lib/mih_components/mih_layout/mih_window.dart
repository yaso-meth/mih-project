import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MIHWindow extends StatefulWidget {
  final String windowTitle;
  final List<Widget> windowBody;
  final List<Widget> windowTools;
  final void Function() onWindowTapClose;
  const MIHWindow({
    super.key,
    required this.windowTitle,
    required this.windowBody,
    required this.windowTools,
    required this.onWindowTapClose,
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

  Widget getWidnowClose() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: widget.onWindowTapClose,
          icon: Icon(
            Icons.close,
            color: MzanziInnovationHub.of(context)!.theme.errorColor(),
            size: 35,
          ),
        ),
      ],
    );
  }

  Widget getWidnowTools() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: widget.windowTools,
    );
  }

  Widget getWidnowTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.windowTitle,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            fontSize: windowTitleSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget getWidnowHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(
          flex: 2,
          child: getWidnowTools(),
        ),
        Flexible(
          flex: 2,
          child: getWidnowTitle(),
        ),
        Flexible(
          flex: 2,
          child: getWidnowClose(),
        ),
      ],
    );
  }

  Widget getWidnowBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.windowBody,
    );
  }

  Widget createWindow(Widget header, Widget body) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: horizontralWindowPadding,
        vertical: vertticalWindowPadding,
      ),
      insetAnimationCurve: Easing.emphasizedDecelerate,
      insetAnimationDuration: Durations.short1,
      child: Container(
        //padding: const EdgeInsets.all(10),
        width: windowWidth,
        //height: windowHeight,
        decoration: BoxDecoration(
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              width: 5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [header, body],
          ),
        ),
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
    return createWindow(
      getWidnowHeader(),
      getWidnowBody(),
    );
  }
}
