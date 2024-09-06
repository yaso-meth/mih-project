import 'package:flutter/material.dart';
import 'package:patient_manager/main.dart';

class MIHWarningMessage extends StatefulWidget {
  final String warningType;
  const MIHWarningMessage({
    super.key,
    required this.warningType,
  });

  @override
  State<MIHWarningMessage> createState() => _MIHDeleteMessageState();
}

class _MIHDeleteMessageState extends State<MIHWarningMessage> {
  var messageTypes = <String, Widget>{};
  late double popUpWidth;
  late double? popUpheight;
  late double popUpTitleSize;
  late double popUpSubtitleSize;
  late double popUpBodySize;
  late double popUpIconSize;
  late double popUpPaddingSize;
  late double width;
  late double height;

  void checkScreenSize() {
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
      setState(() {
        popUpWidth = (width / 4) * 2;
        popUpheight = null;
        popUpTitleSize = 25.0;
        popUpSubtitleSize = 20.0;
        popUpBodySize = 15;
        popUpPaddingSize = 25.0;
        popUpIconSize = 100;
      });
    } else {
      setState(() {
        popUpWidth = width - (width * 0.1);
        popUpheight = null;
        popUpTitleSize = 20.0;
        popUpSubtitleSize = 18.0;
        popUpBodySize = 15;
        popUpPaddingSize = 15.0;
        popUpIconSize = 100;
      });
    }
  }

  void setNoAccess() {
    messageTypes["No Access"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: popUpIconSize,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
                //const SizedBox(height: 15),
                Text(
                  "Access Pending",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "Your access request is currently being reviewed.\nOnce approved, you'll be able to view patient data.\nPlease follow up with the patient to approve your access request.",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
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

  void setExpiredAccess() {
    messageTypes["Expired Access"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: popUpIconSize,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
                //const SizedBox(height: 15),
                Text(
                  "Access Expired",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "You no longer have access to this patient profile. The authorized access period has ended. Access to a patients profile is limited to 7 days from appointment date.",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
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

  Widget? getDeleteMessage(String type) {
    return messageTypes[type];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setState(() {
      width = size.width;
      height = size.height;
    });
    checkScreenSize();
    setNoAccess();
    setExpiredAccess();
    //print(size);
    // setState(() {
    //   width = size.width;
    //   height = size.height;
    // });
    return Dialog(child: getDeleteMessage(widget.warningType));
  }
}
