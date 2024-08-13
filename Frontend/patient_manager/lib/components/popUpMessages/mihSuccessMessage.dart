import 'package:flutter/material.dart';
import 'package:patient_manager/components/inputsAndButtons/mihButton.dart';
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

  void setSuccessmessage() {
    messageTypes["Success"] = Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          width: 500.0,
          // height: 375.0,
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
                size: 100,
                color: MzanziInnovationHub.of(context)!.theme.successColor(),
              ),
              const SizedBox(height: 15),
              Text(
                "Success!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MzanziInnovationHub.of(context)!.theme.successColor(),
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Center(
                  child: Text(
                    message,
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                height: 100,
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
  void initState() {
    message = widget.successMessage;
    setSuccessmessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(child: getSuccessMessage(widget.successType));
  }
}
