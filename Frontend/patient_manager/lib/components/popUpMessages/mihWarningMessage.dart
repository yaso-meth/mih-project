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
  late double width;
  late double height;

  void setNoAccess() {
    messageTypes["No Access"] = Stack(
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
                  "Access Pending",
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
                    "Your access request is currently being reviewed.\n\nOnce approved, you'll be able to view patient data.\n\nPlease follow up with the patient to approve your access request.",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
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
          padding: const EdgeInsets.all(10.0),
          width: 500.0,
          height: (height / 3) * 1,
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
                  "Access Expired",
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
                    "You no longer have access to this patient profile. The authorized access period has ended. Access to a patients profile is limited to 7 days from appointment date.",
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
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
