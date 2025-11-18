import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_employee_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MihAddEmployeeWindow extends StatefulWidget {
  final AppUser user;
  const MihAddEmployeeWindow({
    super.key,
    required this.user,
  });

  @override
  State<MihAddEmployeeWindow> createState() => _MihAddEmployeeWindowState();
}

class _MihAddEmployeeWindowState extends State<MihAddEmployeeWindow> {
  TextEditingController accessController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> createBusinessUserAPICall(
      MzansiProfileProvider mzansiProfileProvider) async {
    int statusCode = await MihBusinessEmployeeServices().addEmployee(
      mzansiProfileProvider,
      widget.user,
      accessController.text,
      context,
    );
    if (statusCode == 201) {
      String message =
          "${widget.user.username} is now apart of your team with ${accessController.text} access to ${mzansiProfileProvider.business!.Name}";
      successPopUp(message, false);
    } else {
      MihAlertServices().internetConnectionLost(context);
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
                    context.pop();
                    context.pop();
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
      },
    );
  }

  bool isRequiredFieldsCaptured() {
    if (accessController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    accessController.dispose();
    usernameController.dispose();
    emailController.dispose();
  }

  @override
  void initState() {
    super.initState();
    usernameController.text = widget.user.username;
    emailController.text = widget.user.email;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Add Employee",
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
                      controller: usernameController,
                      multiLineInput: false,
                      requiredText: true,
                      readOnly: true,
                      hintText: "Username",
                    ),
                    const SizedBox(height: 10.0),
                    MihTextFormField(
                      fillColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      inputColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      controller: emailController,
                      multiLineInput: false,
                      requiredText: true,
                      readOnly: true,
                      hintText: "Email",
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
                    const SizedBox(height: 15.0),
                    Center(
                      child: MihButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (isRequiredFieldsCaptured()) {
                              createBusinessUserAPICall(mzansiProfileProvider);
                            } else {
                              MihAlertServices().inputErrorMessage(context);
                            }
                          } else {
                            MihAlertServices().inputErrorMessage(context);
                          }
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "Add",
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
          onWindowTapClose: () {
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
