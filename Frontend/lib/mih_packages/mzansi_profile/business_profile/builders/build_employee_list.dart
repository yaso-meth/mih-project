import 'dart:convert';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_delete_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_employee.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

class BuildEmployeeList extends StatefulWidget {
  final List<BusinessEmployee> employees;
  final BusinessArguments arguments;

  const BuildEmployeeList({
    super.key,
    required this.employees,
    required this.arguments,
  });

  @override
  State<BuildEmployeeList> createState() => _BuildEmployeeListState();
}

class _BuildEmployeeListState extends State<BuildEmployeeList> {
  TextEditingController accessController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final baseAPI = AppEnviroment.baseApiUrl;

  Future<void> updateEmployeeAPICall(int index) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );

    var response = await http.put(
      Uri.parse("$baseAPI/business-user/employees/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": widget.employees[index].business_id,
        "app_id": widget.employees[index].app_id,
        "title": typeController.text,
        "access": accessController.text,
      }),
    );
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      //setState(() {});
      Navigator.of(context).pushNamed(
        '/business-profile/manage',
        arguments: BusinessArguments(
          widget.arguments.signedInUser,
          widget.arguments.businessUser,
          widget.arguments.business,
        ),
      );
      String message = "Your employees details have been updated.";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> deleteNoteApiCall(int index) async {
    var response = await http.delete(
      Uri.parse("$baseAPI/business-user/employees/delete/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": widget.employees[index].business_id,
        "app_id": widget.employees[index].app_id,
      }),
    );
    //print("Here4");
    //print(response.statusCode);
    if (response.statusCode == 200) {
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
          "The employee has been deleted successfully. This means they will no longer have access to your business profile";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
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

  bool isRequiredFieldsCaptured() {
    if (accessController.text.isEmpty || typeController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void updateEmployeePopUp(int index, double width) {
    setState(() {
      accessController.text = widget.employees[index].access;
      typeController.text = widget.employees[index].title;
      fnameController.text = widget.employees[index].fname;
      lnameController.text = widget.employees[index].lname;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Employee Details",
        menuOptions: [
          SpeedDialChild(
            child: Icon(
              Icons.delete,
              color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            ),
            label: "Delete Employee",
            labelBackgroundColor:
                MzanziInnovationHub.of(context)!.theme.successColor(),
            labelStyle: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              fontWeight: FontWeight.bold,
            ),
            backgroundColor:
                MzanziInnovationHub.of(context)!.theme.successColor(),
            onTap: () {
              showDeleteWarning(index);
            },
          ),
        ],
        onWindowTapClose: () {
          Navigator.pop(context);
        },
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
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    controller: fnameController,
                    multiLineInput: false,
                    requiredText: true,
                    readOnly: true,
                    hintText: "First Name",
                  ),
                  const SizedBox(height: 10.0),
                  MihTextFormField(
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    controller: lnameController,
                    multiLineInput: false,
                    requiredText: true,
                    readOnly: true,
                    hintText: "Surname",
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
                  const SizedBox(height: 20.0),
                  Center(
                    child: MihButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (isRequiredFieldsCaptured()) {
                            updateEmployeeAPICall(index);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const MIHErrorMessage(
                                    errorType: "Input Error");
                              },
                            );
                          }
                        } else {
                          MihAlertServices().formNotFilledCompletely(context);
                        }
                      },
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      width: 300,
                      child: Text(
                        "Update",
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
      ),
    );
  }

  void showDeleteWarning(int index) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MIHDeleteMessage(
            deleteType: "Employee",
            onTap: () {
              deleteNoteApiCall(index);
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
    double screenWidth = MediaQuery.of(context).size.width;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemCount: widget.employees.length,
      itemBuilder: (context, index) {
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        //print(index);
        var isMe = "";
        if (widget.arguments.signedInUser.app_id ==
            widget.employees[index].app_id) {
          isMe = "(You)";
        }
        return ListTile(
          title: Text(
              "${widget.employees[index].fname} ${widget.employees[index].lname} - ${widget.employees[index].title} $isMe"),
          subtitle: Text(
            "${widget.employees[index].username}\n${widget.employees[index].email}\nAccess: ${widget.employees[index].access}",
            style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          onTap: () {
            updateEmployeePopUp(index, screenWidth);
          },
        );
      },
    );
  }
}
