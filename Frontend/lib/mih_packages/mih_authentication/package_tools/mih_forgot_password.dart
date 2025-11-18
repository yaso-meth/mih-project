import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_authentication_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';

class MihForgotPassword extends StatefulWidget {
  const MihForgotPassword({super.key});

  @override
  State<MihForgotPassword> createState() => _MihForgotPasswordState();
}

class _MihForgotPasswordState extends State<MihForgotPassword> {
  final emailController = TextEditingController();
  bool successfulForgotPassword = false;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  bool acceptWarning = false;

  Future<void> submitPasswodReset() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    try {
      var resetPassEmailSent = await MihAuthenticationServices()
          .forgotPassword(emailController.text);
      context.pop();
      if (resetPassEmailSent) {
        setState(() {
          successfulForgotPassword = true;
        });
      }
    } on Exception {
      //loginError();
    }
  }

  void prePassResteWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.warning_amber_rounded,
            size: 100,
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          alertTitle: "Password Reset Confirmation",
          alertBody: Column(
            //mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  "Before you reset your password, please be aware that you'll receive an email with a link to confirm your identity and set a new password. Make sure to check your inbox, including spam or junk folders. If you don't receive the email within a few minutes, please try resending the reset request.",
                  style: TextStyle(
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              MihButton(
                onPressed: () {
                  setState(() {
                    acceptWarning = true;
                  });
                  Navigator.of(context).pop();
                  validateInput();
                },
                buttonColor: MihColors.getGreenColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                width: 300,
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          alertColour: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      },
    );
  }

  void resetLinkSentSuccessfully() {
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
          alertTitle: "Successfully Sent Reset Link",
          alertBody: Column(
            children: [
              Text(
                "We've sent a password reset link to your email address. Please check your inbox, including spam or junk folders.\n\nOnce you find the email, click on the link to reset your password.\n\nIf you don't receive the email within a few minutes, please try resending the reset request.\n\nThe reset link will expire after 2 hours",
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
                      extra: true,
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
      },
    );
  }

  void validateInput() async {
    if (emailController.text.isEmpty) {
      MihAlertServices().inputErrorMessage(context);
    } else {
      await submitPasswodReset();
      if (successfulForgotPassword) {
        // Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        resetLinkSentSuccessfully();
      }
    }
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
          validateInput();
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: MzansiInnovationHub.of(context)!.theme.screenType ==
                    "desktop"
                ? EdgeInsets.symmetric(vertical: 25, horizontal: width * 0.2)
                : EdgeInsets.symmetric(vertical: 25, horizontal: width * 0.075),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
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
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
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
                      controller: emailController,
                      multiLineInput: false,
                      requiredText: true,
                      hintText: "Email",
                      validator: (value) {
                        return MihValidationServices().validateEmail(value);
                      },
                    ),
                    //spacer
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: MihButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            prePassResteWarning();
                          } else {
                            MihAlertServices().inputErrorMessage(context);
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
