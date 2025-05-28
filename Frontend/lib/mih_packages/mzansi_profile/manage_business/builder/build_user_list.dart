import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:supertokens_flutter/http.dart' as http;

import '../../../../main.dart';
import '../../../../mih_components/mih_inputs_and_buttons/mih_button.dart';
import '../../../../mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import '../../../../mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import '../../../../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../../../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../../../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../../../../mih_env/env.dart';
import '../../../../mih_objects/app_user.dart';
import '../../../../mih_objects/arguments.dart';

class BuildUserList extends StatefulWidget {
  final List<AppUser> users;
  final BusinessArguments arguments;

  const BuildUserList({
    super.key,
    required this.users,
    required this.arguments,
  });

  @override
  State<BuildUserList> createState() => _BuildUserListState();
}

class _BuildUserListState extends State<BuildUserList> {
  TextEditingController accessController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();

  final baseAPI = AppEnviroment.baseApiUrl;

  Future<void> createBusinessUserAPICall(int index) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var response = await http.post(
      Uri.parse("$baseAPI/business-user/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": widget.arguments.business!.business_id,
        "app_id": widget.users[index].app_id,
        "signature": "",
        "sig_path": "",
        "title": typeController.text,
        "access": accessController.text,
      }),
    );
    if (response.statusCode == 201) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        '/business-profile/manage',
        arguments: BusinessArguments(
          widget.arguments.signedInUser,
          widget.arguments.businessUser,
          widget.arguments.business,
        ),
      );
      String message =
          "${widget.users[index].username} is now apart of your team with ${accessController.text} access to ${widget.arguments.business!.Name}";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  bool isRequiredFieldsCaptured() {
    if (accessController.text.isEmpty || typeController.text.isEmpty) {
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

  String hideEmail(String email) {
    var firstLetter = email[0];
    var end = email.split("@")[1];
    return "$firstLetter********@$end";
  }

  void addEmployeePopUp(int index) {
    setState(() {
      //accessController.text = widget.users[index].access;
      //typeController.text = widget.users[index].title;
      // var fnameInitial = widget.users[index].fname[0];
      // var lnameInitial = widget.users[index].lname[0];
      fnameController.text = widget.users[index].username;
      lnameController.text = hideEmail(widget.users[index].email);
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MihPackageWindow(
            fullscreen: false,
            windowTitle: "Add Employee",
            windowBody: Column(
              children: [
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: fnameController,
                  hintText: "Username Name",
                  editable: false,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: lnameController,
                  hintText: "Email",
                  editable: false,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MIHDropdownField(
                  controller: typeController,
                  hintText: "Title",
                  dropdownOptions: const ["Doctor", "Assistant"],
                  required: true,
                  editable: true,
                  enableSearch: false,
                ),
                const SizedBox(height: 10.0),
                MIHDropdownField(
                  controller: accessController,
                  hintText: "Access",
                  dropdownOptions: const ["Full", "Partial"],
                  required: true,
                  editable: true,
                  enableSearch: false,
                ),
                const SizedBox(height: 15.0),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: MIHButton(
                    buttonText: "Add",
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    textColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    onTap: () {
                      if (isRequiredFieldsCaptured()) {
                        createBusinessUserAPICall(index);
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const MIHErrorMessage(
                                errorType: "Input Error");
                          },
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            ),
            onWindowTapClose: () {
              Navigator.pop(context);
            }));
  }

  @override
  void dispose() {
    accessController.dispose();
    typeController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemCount: widget.users.length,
      itemBuilder: (context, index) {
        var isYou = "";
        if (widget.arguments.signedInUser.app_id ==
            widget.users[index].app_id) {
          isYou = "(You)";
        }
        return ListTile(
          title: Text("@${widget.users[index].username} $isYou"),
          subtitle: Text(
            "Email: ${hideEmail(widget.users[index].email)}",
            style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          onTap: () {
            addEmployeePopUp(index);
          },
        );
      },
    );
  }
}
