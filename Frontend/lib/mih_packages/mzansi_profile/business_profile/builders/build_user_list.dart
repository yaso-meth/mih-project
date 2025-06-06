import 'dart:convert';

import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

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
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
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

  void addEmployeePopUp(int index, double width) {
    setState(() {
      //accessController.text = widget.users[index].access;
      //typeController.text = widget.users[index].title;
      // var fnameInitial = widget.users[index].fname[0];
      // var lnameInitial = widget.users[index].lname[0];
      usernameController.text = widget.users[index].username;
      emailController.text = hideEmail(widget.users[index].email);
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MihPackageWindow(
            fullscreen: false,
            windowTitle: "Add Employee",
            windowBody: Padding(
              padding:
                  MzanziInnovationHub.of(context)!.theme.screenType == "desktop"
                      ? EdgeInsets.symmetric(horizontal: width * 0.05)
                      : const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                children: [
                  MihForm(
                    formKey: _formKey,
                    formFields: [
                      MihTextFormField(
                        fillColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        inputColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        controller: usernameController,
                        multiLineInput: false,
                        requiredText: true,
                        readOnly: true,
                        hintText: "Username",
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        inputColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        controller: emailController,
                        multiLineInput: false,
                        requiredText: true,
                        readOnly: true,
                        hintText: "Email",
                      ),
                      const SizedBox(height: 15.0),
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
                      Center(
                        child: MihButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
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
                            }
                          },
                          buttonColor: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          width: 300,
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: MzanziInnovationHub.of(context)!
                                  .theme
                                  .primaryColor(),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onWindowTapClose: () {
              Navigator.pop(context);
            }));
  }

  @override
  void dispose() {
    accessController.dispose();
    typeController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
            addEmployeePopUp(index, screenWidth);
          },
        );
      },
    );
  }
}
