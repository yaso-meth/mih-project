import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/mih_objects/arguments.dart';

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
  Size? size;

  void checkScreenSize() {
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
      setState(() {
        popUpWidth = (size!.width / 4) * 2;
        popUpheight = 90;
        popUpTitleSize = 20.0;
        popUpSubtitleSize = 20.0;
        popUpBodySize = 15;
        popUpPaddingSize = 5.0;
        popUpIconSize = 100;
      });
    } else {
      setState(() {
        popUpWidth = size!.width - 20;
        popUpheight = 90;
        popUpTitleSize = 20.0;
        popUpSubtitleSize = 18.0;
        popUpBodySize = 15;
        popUpPaddingSize = 15.0;
        popUpIconSize = 100;
      });
    }
  }

  Widget NotifyPopUp() {
    //messageTypes["Input Error"] =
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          alignment: Alignment.topLeft,
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            // border: Border.all(
            //     color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            //     width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                //const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      color:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    ),
                    Flexible(
                      child: Text(
                        widget.arguments.title,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                          fontSize: popUpTitleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      widget.arguments.body,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        fontSize: popUpBodySize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          width: 50,
          height: 50,
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close,
              color: MzanziInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
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

    _animationController = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 200), // Adjust the duration as needed
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
        insetAnimationDuration: const Duration(milliseconds: 1000),
        insetAnimationCurve: Curves.bounceIn,
        alignment: Alignment.topCenter,
        child: NotifyPopUp(),
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
