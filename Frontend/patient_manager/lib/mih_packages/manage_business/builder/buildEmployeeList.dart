import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_delete_message.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/objects/businessEmployee.dart';
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
          "The employee has been deleted successfully. This means it will no longer have access to your business profile";
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

  void updateEmployeePopUp(int index) {
    setState(() {
      accessController.text = widget.employees[index].access;
      typeController.text = widget.employees[index].title;
      fnameController.text = widget.employees[index].fname;
      lnameController.text = widget.employees[index].lname;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 700.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    width: 5.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Employee Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    MIHTextField(
                      controller: fnameController,
                      hintText: "First Name",
                      editable: false,
                      required: true,
                    ),
                    const SizedBox(height: 10.0),
                    MIHTextField(
                      controller: lnameController,
                      hintText: "Surname",
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
                    ),
                    const SizedBox(height: 10.0),
                    MIHDropdownField(
                      controller: accessController,
                      hintText: "Access",
                      dropdownOptions: const ["Full", "Partial"],
                      required: true,
                      editable: true,
                    ),
                    const SizedBox(height: 30.0),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: MIHButton(
                        buttonText: "Update",
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        onTap: () {
                          updateEmployeeAPICall(index);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                  size: 35,
                ),
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  showDeleteWarning(index);
                },
                icon: Icon(
                  Icons.delete,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  size: 35,
                ),
              ),
            ),
          ],
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
    return ListView.separated(
      shrinkWrap: true,
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
            updateEmployeePopUp(index);
          },
        );
      },
    );
  }
}
