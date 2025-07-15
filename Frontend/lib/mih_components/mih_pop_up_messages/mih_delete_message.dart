import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import '../../main.dart';

class MIHDeleteMessage extends StatefulWidget {
  final String deleteType;
  final void Function() onTap;
  const MIHDeleteMessage({
    super.key,
    required this.deleteType,
    required this.onTap,
  });

  @override
  State<MIHDeleteMessage> createState() => _MIHDeleteMessageState();
}

class _MIHDeleteMessageState extends State<MIHDeleteMessage> {
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
    if (MzansiInnovationHub.of(context)!.theme.screenType == "desktop") {
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

  void setDeleteNote() {
    messageTypes["Note"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
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
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                ),
                //const SizedBox(height: 15),
                Text(
                  "Are you sure you want to delete this?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "This note will be deleted permanently. Are you certain you want to delete it?",
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                MihButton(
                  onPressed: widget.onTap,
                  buttonColor:
                      MzansiInnovationHub.of(context)!.theme.errorColor(),
                  width: 300,
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              color: MzansiInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  void setFileNote() {
    messageTypes["File"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
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
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                ),
                //const SizedBox(height: 15),
                Text(
                  "Are you sure you want to delete this?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "This file will be deleted permanently. Are you certain you want to delete it?",
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                MihButton(
                  onPressed: widget.onTap,
                  buttonColor:
                      MzansiInnovationHub.of(context)!.theme.errorColor(),
                  width: 300,
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              color: MzansiInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  void setDeleteEmployee() {
    messageTypes["Employee"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
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
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                ),
                //const SizedBox(height: 15),
                Text(
                  "Are you sure you want to delete this?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "This team member will be deleted permanently from the business profile. Are you certain you want to delete it?",
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),

                MihButton(
                  onPressed: widget.onTap,
                  buttonColor:
                      MzansiInnovationHub.of(context)!.theme.errorColor(),
                  width: 300,
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              color: MzansiInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  void setDeleteAppointment() {
    messageTypes["Appointment"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
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
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                ),
                //const SizedBox(height: 15),
                Text(
                  "Are you sure you want to delete this?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "This appointment will be deleted permanently from your calendar. Are you certain you want to delete it?",
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                MihButton(
                  onPressed: widget.onTap,
                  buttonColor:
                      MzansiInnovationHub.of(context)!.theme.errorColor(),
                  width: 300,
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              color: MzansiInnovationHub.of(context)!.theme.errorColor(),
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  void setDeleteLoyaltyCard() {
    messageTypes["Loyalty Card"] = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(popUpPaddingSize),
          width: popUpWidth,
          height: popUpheight,
          decoration: BoxDecoration(
            color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
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
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                ),
                //const SizedBox(height: 15),
                Text(
                  "Are you sure you want to delete this?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpTitleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  "This Card will be deleted permanently from your Mzansi Wallet. Are you certain you want to delete it?",
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                MihButton(
                  onPressed: widget.onTap,
                  buttonColor:
                      MzansiInnovationHub.of(context)!.theme.errorColor(),
                  width: 300,
                  child: Text(
                    "Delete",
                    style: TextStyle(
                      color:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              color: MzansiInnovationHub.of(context)!.theme.errorColor(),
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
    setDeleteNote();
    setFileNote();
    setDeleteEmployee();
    setDeleteAppointment();
    setDeleteLoyaltyCard();
    //print(size);
    // setState(() {
    //   width = size.width;
    //   height = size.height;
    // });
    return Dialog(child: getDeleteMessage(widget.deleteType));
  }
}
