import 'package:flutter/material.dart';
import '../../main.dart';
import '../../mih_objects/arguments.dart';

class MIHNotificationMessage extends StatefulWidget {
  final NotificationArguments arguments;
  const MIHNotificationMessage({
    super.key,
    required this.arguments,
  });

  @override
  State<MIHNotificationMessage> createState() => _MIHNotificationMessageState();
}

class _MIHNotificationMessageState extends State<MIHNotificationMessage>
    with SingleTickerProviderStateMixin {
  //var messageTypes = <String, Widget>{};
  late AnimationController _animationController;
  late Animation<Offset> _scaleAnimation;
  late double popUpWidth;
  late double? popUpheight;
  late double popUpTitleSize;
  late double popUpSubtitleSize;
  late double popUpBodySize;
  late double popUpIconSize;
  late double popUpPaddingSize;
  late Color primary;
  late Color secondary;
  Size? size;

  void checkScreenSize() {
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
      setState(() {
        popUpWidth = (size!.width / 4) * 2;
        popUpheight = 90;
        popUpTitleSize = 20.0;
        popUpSubtitleSize = 20.0;
        popUpBodySize = 15;
        popUpPaddingSize = 25.0;
        popUpIconSize = 100;
      });
    } else {
      setState(() {
        popUpWidth = size!.width;
        popUpheight = 90;
        popUpTitleSize = 20.0;
        popUpSubtitleSize = 18.0;
        popUpBodySize = 15;
        popUpPaddingSize = 5.0;
        popUpIconSize = 100;
      });
    }
  }

  Widget notifyPopUp() {
    //messageTypes["Input Error"] =
    return GestureDetector(
      onTap: widget.arguments.onTap,
      child: Container(
        padding:
            EdgeInsets.symmetric(vertical: 5, horizontal: popUpPaddingSize),
        alignment: Alignment.topLeft,
        width: popUpWidth,
        height: popUpheight,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: secondary, width: 5.0),
        ),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            //const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications,
                  color: secondary,
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    widget.arguments.title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondary,
                      fontSize: popUpTitleSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                SizedBox(
                  width: popUpWidth,
                  child: Text(
                    widget.arguments.body,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: secondary,
                      fontSize: popUpBodySize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      primary = MzanziInnovationHub.of(context)!.theme.primaryColor();
      secondary = MzanziInnovationHub.of(context)!.theme.errorColor();
    });
    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 300), // Adjust the duration as needed
    );

    _scaleAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(_animationController);

    // Start the animation when
    // the dialog is displayed
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    checkScreenSize();
    //setInputError();

    //print(size);
    // setState(() {
    //   width = size.width;
    //   height = size.height;
    // });
    return SlideTransition(
      position: _scaleAnimation,
      child: Dialog(
        insetPadding: const EdgeInsets.only(
          top: 45,
          left: 5,
          right: 5,
        ),
        shadowColor: secondary,
        alignment: Alignment.topCenter,
        child: notifyPopUp(),
      ),
    );
    // return SlideTransition(
    //   position: Tween<Offset>(
    //     begin: const Offset(0, -1),
    //     end: Offset.zero,
    //   ).animate(widget.animationController),
    //   child: Dialog(
    //     alignment: Alignment.topCenter,
    //     child: NotifyPopUp(),
    //   ),
    // );
  }
}
