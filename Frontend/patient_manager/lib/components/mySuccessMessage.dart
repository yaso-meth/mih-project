import 'package:flutter/material.dart';
import 'package:patient_manager/components/mybutton.dart';

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
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: Colors.green, width: 5.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 100,
                color: Colors.green,
              ),
              const SizedBox(height: 15),
              const Text(
                "Success!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black,
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
                  buttonColor: Colors.green,
                  textColor: Colors.white,
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
