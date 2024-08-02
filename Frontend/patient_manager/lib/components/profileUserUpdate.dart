import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/components/mySuccessMessage.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:supertokens_flutter/http.dart' as http;

class ProfileUserUpdate extends StatefulWidget {
  final AppUser signedInUser;
  //final String userEmail;
  const ProfileUserUpdate({
    super.key,
    required this.signedInUser,
  });

  @override
  State<ProfileUserUpdate> createState() => _ProfileUserUpdateState();
}

class _ProfileUserUpdateState extends State<ProfileUserUpdate> {
  final usernameController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  late bool businessUser;

  bool isFieldsFilled() {
    if (fnameController.text.isEmpty ||
        lnameController.text.isEmpty ||
        usernameController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> updateUserApiCall() async {
    //print("Here1");
    //userEmail = getLoginUserEmail() as String;
    //print(userEmail);
    //print("Here2");
    //await getOfficeIdByUser(docOfficeIdApiUrl + userEmail);
    //print(futureDocOfficeId.toString());
    //print("Here3");
    var profileType;
    if (businessUser) {
      profileType = "business";
    } else {
      profileType = "personal";
    }

    var response = await http.put(
      Uri.parse("${AppEnviroment.baseApiUrl}/user/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "idusers": widget.signedInUser.idUser,
        "username": usernameController.text,
        "fnam": fnameController.text,
        "lname": lnameController.text,
        "type": profileType,
      }),
    );
    //print("Here4");
    //print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.of(context)
          .popAndPushNamed('/', arguments: widget.signedInUser);
      String message =
          "${widget.signedInUser.email}'s information has been updated successfully!";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  bool isBusinessUser() {
    if (widget.signedInUser.type == "personal") {
      return false;
    } else {
      return true;
    }
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MyErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void successPopUp(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MySuccessMessage(
          successType: "Success",
          successMessage: message,
        );
      },
    );
  }

  @override
  void initState() {
    setState(() {
      fnameController.text = widget.signedInUser.fname;
      lnameController.text = widget.signedInUser.lname;
      usernameController.text = widget.signedInUser.username;
      businessUser = isBusinessUser();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Personal profile:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        const SizedBox(height: 15.0),
        MyTextField(
          controller: usernameController,
          hintText: "Username",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10.0),
        MyTextField(
          controller: fnameController,
          hintText: "First Name",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10.0),
        MyTextField(
          controller: lnameController,
          hintText: "Last Name",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Activate Business",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              width: 25,
            ),
            Switch(
              value: businessUser,
              onChanged: (bool value) {
                setState(() {
                  businessUser = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        SizedBox(
          width: 500.0,
          height: 100.0,
          child: MyButton(
            buttonText: "Update",
            buttonColor:
                MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            onTap: () {
              if (isFieldsFilled()) {
                updateUserApiCall();
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const MyErrorMessage(errorType: "Input Error");
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
