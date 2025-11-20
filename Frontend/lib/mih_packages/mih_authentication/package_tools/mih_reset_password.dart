import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_authentication_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';

class MihResetPassword extends StatefulWidget {
  final String token;
  const MihResetPassword({
    super.key,
    required this.token,
  });

  @override
  State<MihResetPassword> createState() => _MihResetPasswordState();
}

class _MihResetPasswordState extends State<MihResetPassword> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  void submitFormInput() async {
    if (passwordController.text != confirmPasswordController.text) {
      MihAlertServices().passwordMatchAlert(context);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const Mihloadingcircle();
        },
      );
      bool successfulResetPassword = await MihAuthenticationServices()
          .resetPassword(widget.token, passwordController.text);
      context.pop();
      if (successfulResetPassword) {
        resetSuccessfully();
      } else {
        MihAlertServices().internetConnectionAlert(context);
      }
    }
  }

  void resetSuccessfully() {
    MihAlertServices().successAdvancedAlert(
      "Successfully Reset Password",
      "Great news! Your password reset is complete. You can now log in to Mzansi Innovation Hub using your new password.",
      [
        MihButton(
          onPressed: () {
            context.goNamed(
              'mihHome',
              extra: true,
            );
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(screenWidth),
    );
  }

  Widget getBody(double width) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) async {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          if (_formKey.currentState!.validate()) {
            submitFormInput();
          } else {
            MihAlertServices().inputErrorAlert(context);
          }
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.2)
                    : EdgeInsets.symmetric(horizontal: width * 0.075),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Token: ${widget.token}"), // For testing purposes only
                //logo
                Icon(
                  Icons.lock,
                  size: 100,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                //spacer
                const SizedBox(height: 10),
                //Heading
                Text(
                  'Reset Password',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
                //spacer
                const SizedBox(height: 25),
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
                      controller: passwordController,
                      multiLineInput: false,
                      requiredText: true,
                      hintText: "Password",
                      passwordMode: true,
                      autofillHints: const [AutofillHints.password],
                      validator: (value) {
                        return MihValidationServices().validatePassword(value);
                      },
                    ),
                    //spacer
                    const SizedBox(height: 10),
                    MihTextFormField(
                      fillColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      inputColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      controller: confirmPasswordController,
                      multiLineInput: false,
                      requiredText: true,
                      hintText: "Confirm Password",
                      passwordMode: true,
                      autofillHints: const [AutofillHints.password],
                      validator: (value) {
                        return MihValidationServices().validatePassword(value);
                      },
                    ),
                    //spacer
                    const SizedBox(height: 25),
                    // sign in button
                    Center(
                      child: MihButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submitFormInput();
                          } else {
                            MihAlertServices().inputErrorAlert(context);
                          }
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "Reset Password",
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
      ),
    );
  }
}
