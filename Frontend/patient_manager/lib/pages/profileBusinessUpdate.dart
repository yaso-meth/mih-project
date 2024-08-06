import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/businessUser.dart';
import 'package:supertokens_flutter/http.dart' as http;

class ProfileBusinessUpdate extends StatefulWidget {
  //final BusinessUserScreenArguments arguments;
  final AppUser signedInUser;
  final BusinessUser? businessUser;
  const ProfileBusinessUpdate({
    super.key,
    required this.signedInUser,
    required this.businessUser,
  });

  @override
  State<ProfileBusinessUpdate> createState() => _ProfileBusinessUpdateState();
}

class _ProfileBusinessUpdateState extends State<ProfileBusinessUpdate> {
  final FocusNode _focusNode = FocusNode();
  final baseAPI = AppEnviroment.baseApiUrl;
  final tempController = TextEditingController();

  Future<AppUser> getUserDetails() async {
    //print("pat man drawer: " + endpointUserData + widget.userEmail);
    var response = await http
        .get(Uri.parse("$baseAPI/user/${widget.signedInUser.app_id}"));

    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      // print("here");
      String body = response.body;
      var decodedData = jsonDecode(body);
      AppUser u = AppUser.fromJson(decodedData);
      // print(u.email);
      //setState(() {
      //_widgetOptions = setLayout(u);
      //});
      return u;
    } else {
      throw Exception("Error: GetUserData status code ${response.statusCode}");
    }
  }

  @override
  void initState() {
    print("signed in user: ${widget.signedInUser.app_id}");
    print("business User: ${widget.businessUser}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MIHAppBar(barTitle: "Update Business"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: KeyboardListener(
            focusNode: _focusNode,
            autofocus: true,
            onKeyEvent: (event) async {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                //submitForm();
              }
            },
            child: Column(
              children: [
                const Text(
                  "Business profile:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 15.0),
                MyTextField(
                  controller: tempController,
                  hintText: "Username",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MyTextField(
                  controller: tempController,
                  hintText: "First Name",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MyTextField(
                  controller: tempController,
                  hintText: "Last Name",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                const Row(
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
                    SizedBox(
                      width: 25,
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
                    textColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    onTap: () {
                      //submitForm();
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
