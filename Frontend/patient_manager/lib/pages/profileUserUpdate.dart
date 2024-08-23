import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/components/popUpMessages/mihErrorMessage.dart';
import 'package:patient_manager/components/popUpMessages/mihSuccessMessage.dart';
import 'package:patient_manager/components/inputsAndButtons/mihTextInput.dart';
import 'package:patient_manager/components/inputsAndButtons/mihButton.dart';
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
  final FocusNode _focusNode = FocusNode();

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
    print("is username valid ${isUsernameValid(usernameController.text)}");
    if (isUsernameValid(usernameController.text) == false) {
      usernamePopUp();
    } else {
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
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void successPopUp(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MIHSuccessMessage(
          successType: "Success",
          successMessage: message,
        );
      },
    );
  }

  void usernamePopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Invalid Username");
      },
    );
  }

  bool isUsernameValid(String username) {
    return RegExp(r'^(?=[a-zA-Z0-9._]{8,20}$)(?!.*[_.]{2})[^_.].*[^_.]$')
        .hasMatch(username);
  }

  void submitForm() {
    if (isFieldsFilled()) {
      updateUserApiCall();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    _focusNode.dispose();
    super.dispose();
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
    return Scaffold(
      appBar: const MIHAppBar(barTitle: "Update Profile"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: KeyboardListener(
            focusNode: _focusNode,
            autofocus: true,
            onKeyEvent: (event) async {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                submitForm();
              }
            },
            child: Column(
              children: [
                const Text(
                  "Personal Profile:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 15.0),
                MIHTextField(
                  controller: usernameController,
                  hintText: "Username",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: fnameController,
                  hintText: "First Name",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
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
                      "Activate Business Account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
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
                const SizedBox(height: 30.0),
                SizedBox(
                  width: 500.0,
                  height: 50.0,
                  child: MIHButton(
                    buttonText: "Update",
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    textColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    onTap: () {
                      submitForm();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
