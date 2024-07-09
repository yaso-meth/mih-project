import 'package:flutter/material.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/theme/mihTheme.dart';

class MySuccessMessage extends StatefulWidget {
  final String successType;
  final String successMessage;
  const MySuccessMessage({
    super.key,
    required this.successType,
    required this.successMessage,
  });

  @override
  State<MySuccessMessage> createState() => _MySuccessMessageState();
}

class _MySuccessMessageState extends State<MySuccessMessage> {
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
            color: MyTheme().primaryColor(),
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: MyTheme().successColor(), width: 5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: 100,
                color: MyTheme().successColor(),
              ),
              const SizedBox(height: 15),
              Text(
                "Success!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MyTheme().successColor(),
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  message,
                  style: TextStyle(
                    color: MyTheme().secondaryColor(),
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                height: 100,
                child: MyButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  buttonText: "Dismiss",
                  buttonColor: MyTheme().successColor(),
                  textColor: MyTheme().primaryColor(),
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
