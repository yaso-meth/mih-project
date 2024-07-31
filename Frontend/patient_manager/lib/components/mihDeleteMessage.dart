import 'package:flutter/material.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/main.dart';

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
  late double width;
  late double height;

  void setDeleteNote() {
    messageTypes["Note"] = Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          width: 500.0,
          height: (height / 3) * 1.5,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 100,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
                const SizedBox(height: 15),
                Text(
                  "Are you sure you want to delete this?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "This note will be deleted permanently. Are you certain you want to delete it?",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                    width: 300,
                    height: 100,
                    child: MyButton(
                      onTap: widget.onTap,
                      buttonText: "Delete",
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      textColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    ))
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

  void setFileNote() {
    messageTypes["File"] = Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          width: 500.0,
          height: (height / 3) * 1.5,
          decoration: BoxDecoration(
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                width: 5.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 100,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
                const SizedBox(height: 15),
                Text(
                  "Are you sure you want to delete this?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text(
                    "This file will be deleted permanently. Are you certain you want to delete it?",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                    width: 300,
                    height: 100,
                    child: MyButton(
                      onTap: widget.onTap,
                      buttonText: "Delete",
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      textColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    ))
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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setState(() {
      width = size.width;
      height = size.height;
    });
    setDeleteNote();
    setFileNote();

    //print(size);
    // setState(() {
    //   width = size.width;
    //   height = size.height;
    // });
    return Dialog(child: getDeleteMessage(widget.deleteType));
  }
}
