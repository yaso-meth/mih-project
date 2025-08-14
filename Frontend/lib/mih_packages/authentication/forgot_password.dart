import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import '../../main.dart';
import 'package:supertokens_flutter/http.dart' as http;
import '../../mih_components/mih_layout/mih_action.dart';
import '../../mih_components/mih_layout/mih_body.dart';
import '../../mih_components/mih_layout/mih_header.dart';
import '../../mih_components/mih_layout/mih_layout_builder.dart';
import '../../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../../mih_config/mih_env.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //bool _obscureText = true;
  bool successfulForgotPassword = false;
  bool acceptWarning = false;
  // focus node to capture keyboard events
  final FocusNode _focusNode = FocusNode();

  final baseAPI = AppEnviroment.baseApiUrl;

  Future<void> submitPasswodReset() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );

    try {
      var response = await http.post(
        Uri.parse("$baseAPI/auth/user/password/reset/token"),
        body:
            '{"formFields": [{"id": "email","value": "${emailController.text}"}]}',
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          //"Authorization": "leatucczyixqwkqqdrhayiwzeofkltds"
        },
      );
      //print(response.body[])
      if (response.statusCode == 200) {
        //print(response.body);
        var userSignedin = jsonDecode(response.body);
        if (userSignedin["status"] == "OK") {
          //print("here");
          setState(() {
            successfulForgotPassword = true;
          });
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
          //loginError();
        }
      }
    } on Exception {
      Navigator.of(context).pop();
      //loginError();
    }
  }

  Color getPrim() {
    return MihColors.getSecondaryColor(
        MzansiInnovationHub.of(context)!.theme.mode == "Dark");
  }

  Color getSec() {
    return MihColors.getPrimaryColor(
        MzansiInnovationHub.of(context)!.theme.mode == "Dark");
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

  void loginError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Invalid Credentials");
      },
    );
  }

  void resetLinkSentSuccessfully() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHSuccessMessage(
            successType: "Success",
            successMessage:
                "We've sent a password reset link to your email address. Please check your inbox, including spam or junk folders.\n\nOnce you find the email, click on the link to reset your password.\n\nIf you don't receive the email within a few minutes, please try resending the reset request.\n\nThe reset link will expire after 2 hours");
      },
    );
  }

  void validateInput() async {
    if (emailController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    } else {
      await submitPasswodReset();
      if (successfulForgotPassword) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        resetLinkSentSuccessfully();
      }
    }
  }

  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  MIHBody getBody(double width) {
    return MIHBody(
      borderOn: false,
      bodyItems: [
        KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (event) async {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              validateInput();
            }
          },
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: MzansiInnovationHub.of(context)!.theme.screenType ==
                          "desktop"
                      ? EdgeInsets.symmetric(
                          vertical: 25, horizontal: width * 0.2)
                      : EdgeInsets.symmetric(
                          vertical: 25, horizontal: width * 0.075),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //logo
                      Icon(
                        Icons.lock,
                        size: 100,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
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
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
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
                              return MihValidationServices()
                                  .validateEmail(value);
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
                                  MihAlertServices()
                                      .formNotFilledCompletely(context);
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
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
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
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(),
      secondaryActionButton: null,
      body: getBody(screenWidth),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
  }
}
