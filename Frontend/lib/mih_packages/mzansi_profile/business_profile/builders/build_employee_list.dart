import 'dart:convert';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_delete_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_employee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supertokens_flutter/http.dart' as http;

class BuildEmployeeList extends StatefulWidget {
  final List<BusinessEmployee> employees;

  const BuildEmployeeList({
    super.key,
    required this.employees,
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
      // Navigator.of(context).pop();
      // Navigator.of(context).pop();
      // Navigator.of(context).pop();
      // //setState(() {});
      // Navigator.of(context).pushNamed(
      //   '/business-profile/manage',
      //   arguments: BusinessArguments(
      //     widget.arguments.signedInUser,
      //     widget.arguments.businessUser,
      //     widget.arguments.business,
      //   ),
      // );
      String message = "Your employees details have been updated.";
      successPopUp(message, false);
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
      // Navigator.of(context).pop();
      // Navigator.of(context).pop();
      // Navigator.of(context).pop();
      // Navigator.of(context).pushNamed(
      //   '/business-profile/manage',
      //   arguments: BusinessArguments(
      //     widget.arguments.signedInUser,
      //     widget.arguments.businessUser,
      //     widget.arguments.business,
      //   ),
      // );
      String message =
          "The employee has been deleted successfully. This means they will no longer have access to your business profile";
      successPopUp(message, false);
    } else {
      internetConnectionPopUp();
    }
  }

  void successPopUp(String message, bool stayOnPersonalSide) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.check_circle_outline_rounded,
            size: 150,
            color: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          alertTitle: "Successfully Updated Profile",
          alertBody: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: MihButton(
                  onPressed: () {
                    context.goNamed(
                      'mihHome',
                      extra: stayOnPersonalSide,
                    );
                  },
                  buttonColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  elevation: 10,
                  width: 300,
                  child: Text(
                    "Dismiss",
                    style: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          alertColour: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
        // return MIHSuccessMessage(
        //   successType: "Success",
        //   successMessage: message,
        // );
      },
    );
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
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
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
            label: "Delete Employee",
            labelBackgroundColor: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            labelStyle: TextStyle(
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontWeight: FontWeight.bold,
            ),
            backgroundColor: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
              MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.05)
                  : const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              MihForm(
                formKey: _formKey,
                formFields: [
                  MihTextFormField(
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    controller: fnameController,
                    multiLineInput: false,
                    requiredText: true,
                    readOnly: true,
                    hintText: "First Name",
                  ),
                  const SizedBox(height: 10.0),
                  MihTextFormField(
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    controller: lnameController,
                    multiLineInput: false,
                    requiredText: true,
                    readOnly: true,
                    hintText: "Surname",
                  ),
                  const SizedBox(height: 10.0),
                  MihTextFormField(
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    controller: typeController,
                    multiLineInput: false,
                    requiredText: true,
                    readOnly: true,
                    hintText: "Title",
                  ),
                  // MihDropdownField(
                  //   controller: typeController,
                  //   hintText: "Title",
                  //   dropdownOptions: const ["Doctor", "Assistant", "Other"],
                  //   editable: true,
                  //   enableSearch: true,
                  //   validator: (value) {
                  //     return MihValidationServices().isEmpty(value);
                  //   },
                  //   requiredText: true,
                  // ),
                  const SizedBox(height: 10.0),
                  MihDropdownField(
                    controller: accessController,
                    hintText: "Access Type",
                    dropdownOptions: const ["Full", "Partial"],
                    editable: true,
                    enableSearch: true,
                    validator: (value) {
                      return MihValidationServices().isEmpty(value);
                    },
                    requiredText: true,
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
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
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
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, index) {
            return Divider(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            );
          },
          itemCount: widget.employees.length,
          itemBuilder: (context, index) {
            //final patient = widget.patients[index].id_no.contains(widget.searchString);
            //print(index);
            var isMe = "";
            if (mzansiProfileProvider.user!.app_id ==
                widget.employees[index].app_id) {
              isMe = "(You)";
            }
            return ListTile(
              title: Text(
                  "${widget.employees[index].fname} ${widget.employees[index].lname} - ${widget.employees[index].title} $isMe"),
              subtitle: Text(
                "${widget.employees[index].username}\n${widget.employees[index].email}\nAccess: ${widget.employees[index].access}",
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
              onTap: () {
                updateEmployeePopUp(index, screenWidth);
              },
            );
          },
        );
      },
    );
  }
}
