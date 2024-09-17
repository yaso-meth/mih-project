import 'package:flutter/material.dart';
import 'package:patient_manager/MIH_Components/inputsAndButtons/mihButton.dart';
import 'package:patient_manager/main.dart';

class MIHSuccessMessage extends StatefulWidget {
  final String successType;
  final String successMessage;
  const MIHSuccessMessage({
    super.key,
    required this.successType,
    required this.successMessage,
  });

  @override
  State<MIHSuccessMessage> createState() => _MIHSuccessMessageState();
}

class _MIHSuccessMessageState extends State<MIHSuccessMessage> {
  var messageTypes = <String, Widget>{};
  late String message;
  late double popUpWidth;
  late double? popUpheight;
  late double popUpTitleSize;
  late double popUpSubtitleSize;
  late double popUpBodySize;
  late double popUpIconSize;
  late double popUpPaddingSize;
  late Size? size;

  void checkScreenSize() {
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
      setState(() {
        popUpWidth = (size!.width / 4) * 2;
        popUpheight = null;
        popUpTitleSize = 25.0;
        popUpSubtitleSize = 20.0;
        popUpBodySize = 15;
        popUpPaddingSize = 25.0;
        popUpIconSize = 100;
      });
    } else {
      setState(() {
        popUpWidth = size!.width - (size!.width * 0.1);
        popUpheight = null;
        popUpTitleSize = 20.0;
        popUpSubtitleSize = 18.0;
        popUpBodySize = 15;
        popUpPaddingSize = 15.0;
        popUpIconSize = 100;
      });
    }
  }

  void setSuccessmessage() {
    messageTypes["Success"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.successColor(),
                width: 5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: popUpIconSize,
                color: MzanziInnovationHub.of(context)!.theme.successColor(),
              ),
              //const SizedBox(height: 15),
              Text(
                "Success!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MzanziInnovationHub.of(context)!.theme.successColor(),
                  fontSize: popUpTitleSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: Text(
                  message,
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 300,
                height: 50,
                child: MIHButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  buttonText: "Dismiss",
                  buttonColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
                  textColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget? getSuccessMessage(String type) {
    return messageTypes[type];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    checkScreenSize();
    message = widget.successMessage;
    setSuccessmessage();
    return Dialog(child: getSuccessMessage(widget.successType));
  }
}
