import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_employee.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_employee_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MihEditEmployeeDetailsWindow extends StatefulWidget {
  final BusinessEmployee employee;
  const MihEditEmployeeDetailsWindow({
    super.key,
    required this.employee,
  });

  @override
  State<MihEditEmployeeDetailsWindow> createState() =>
      _MihEditEmployeeDetailsWindowState();
}

class _MihEditEmployeeDetailsWindowState
    extends State<MihEditEmployeeDetailsWindow> {
  TextEditingController accessController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void updateEmployeeAPICall(
      MzansiProfileProvider mzansiProfileProvider) async {
    int statusCode = await MihBusinessEmployeeServices().updateEmployeeDetails(
        mzansiProfileProvider,
        widget.employee,
        titleController.text,
        accessController.text,
        context);
    if (statusCode == 200) {
      String message = "Your employees details have been updated.";
      successPopUp(message, false);
    } else {
      MihAlertServices().internetConnectionAlert(context);
    }
  }

  Future<void> deleteEmployeeApiCall() async {
    int statusCode = await MihBusinessEmployeeServices().deleteEmployee(
      context.read<MzansiProfileProvider>(),
      widget.employee,
      context,
    );
    if (statusCode == 200) {
      String message =
          "The employee has been deleted successfully. This means they will no longer have access to your business profile";
      context.pop();
      successPopUp(message, false);
    } else {
      MihAlertServices().internetConnectionAlert(context);
    }
  }

  void showDeleteWarning() {
    MihAlertServices().deleteConfirmationAlert(
      "This team member will be deleted permanently from the business profile. Are you certain you want to delete it?",
      () {
        deleteEmployeeApiCall();
      },
      context,
    );
  }

  void successPopUp(String message, bool stayOnPersonalSide) {
    MihAlertServices().successAdvancedAlert(
      "Successfully Updated Employee Details",
      message,
      [
        MihButton(
          onPressed: () {
            context.pop();
            context.pop();
          },
          buttonColor: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          elevation: 10,
          width: 300,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      context,
    );
  }

  bool isRequiredFieldsCaptured() {
    if (accessController.text.isEmpty || titleController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    accessController.dispose();
    titleController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fnameController.text = widget.employee.fname;
    lnameController.text = widget.employee.lname;
    titleController.text = widget.employee.title;
    accessController.text = widget.employee.access;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        return MihPackageWindow(
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
                showDeleteWarning();
              },
            ),
          ],
          onWindowTapClose: () {
            Navigator.pop(context);
          },
          windowBody: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: screenWidth * 0.05)
                    : const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                MihForm(
                  formKey: _formKey,
                  formFields: [
                    MihTextFormField(
                      fillColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      inputColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      controller: fnameController,
                      multiLineInput: false,
                      requiredText: true,
                      readOnly: true,
                      hintText: "First Name",
                    ),
                    const SizedBox(height: 10.0),
                    MihTextFormField(
                      fillColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      inputColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      controller: lnameController,
                      multiLineInput: false,
                      requiredText: true,
                      readOnly: true,
                      hintText: "Surname",
                    ),
                    const SizedBox(height: 10.0),
                    MihTextFormField(
                      fillColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      inputColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      controller: titleController,
                      multiLineInput: false,
                      requiredText: true,
                      readOnly: true,
                      hintText: "Title",
                    ),
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
                              updateEmployeeAPICall(mzansiProfileProvider);
                            } else {
                              MihAlertServices().inputErrorAlert(context);
                            }
                          } else {
                            MihAlertServices().inputErrorAlert(context);
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
        );
      },
    );
  }
}
