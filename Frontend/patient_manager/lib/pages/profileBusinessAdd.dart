import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/components/myDropdownInput.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/components/mySuccessMessage.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:supertokens_flutter/http.dart' as http;

class ProfileBusinessAdd extends StatefulWidget {
  //final BusinessUserScreenArguments arguments;
  final AppUser signedInUser;
  const ProfileBusinessAdd({
    super.key,
    required this.signedInUser,
  });

  @override
  State<ProfileBusinessAdd> createState() => _ProfileBusinessAddState();
}

class _ProfileBusinessAddState extends State<ProfileBusinessAdd> {
  final FocusNode _focusNode = FocusNode();
  final baseAPI = AppEnviroment.baseApiUrl;
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final regController = TextEditingController();
  final logonameController = TextEditingController();

  Future<void> createBusinessUserAPICall(String business_id) async {
    var response = await http.post(
      Uri.parse("$baseAPI/business-user/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "app_id": widget.signedInUser.app_id,
        "signature": "",
        "title": ""
      }),
    );
    if (response.statusCode == 201) {
      // var businessResponse = jsonDecode(response.body);
      // print(businessResponse);

      // create business profile
      // setState(() {
      //   futueNotes = fetchNotes(endpoint + widget.patientAppId.toString());
      // });
      Navigator.of(context).pushNamed('/home');
      String message =
          "Your business profile is now live! You can now start connecting with customers and growing your business.";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> createBusinessProfileAPICall() async {
    var response = await http.post(
      Uri.parse("$baseAPI/business/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "Name": nameController.text,
        "type": typeController.text,
        "registration_no": regController.text,
        "logo_name": logonameController.text,
        "logo_path": "${widget.signedInUser.app_id}/${logonameController.text}",
      }),
    );
    if (response.statusCode == 201) {
      var businessResponse = jsonDecode(response.body);
      print(businessResponse);
      createBusinessUserAPICall(businessResponse['business_id']);
      // create business profile
      // setState(() {
      //   futueNotes = fetchNotes(endpoint + widget.patientAppId.toString());
      // });
      // Navigator.of(context).pushNamed('/home', arguments: widget.signedInUser);
      // String message =
      //     "Your business profile is now live! You can now start connecting with customers and growing your business.";
      // successPopUp(message);
    } else {
      internetConnectionPopUp();
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

  void submitForm() {
    createBusinessProfileAPICall();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MIHAppBar(barTitle: "Add Business"),
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
                  "Add Business Profile:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 15.0),
                MyTextField(
                  controller: regController,
                  hintText: "Registration No.",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MyTextField(
                  controller: nameController,
                  hintText: "Business Name",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MyDropdownField(
                  controller: typeController,
                  hintText: "Business Type",
                  dropdownOptions: const ["Doctors Office", "Other"],
                  required: true,
                  editable: true,
                ),
                const SizedBox(height: 10.0),
                MyTextField(
                  controller: logonameController,
                  hintText: "Logo",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 500.0,
                  height: 100.0,
                  child: MyButton(
                    buttonText: "Add",
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
