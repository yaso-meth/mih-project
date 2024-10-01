import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_action.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_body.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_header.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:patient_manager/mih_env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supertokens_flutter/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

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
    } on AuthException {
      Navigator.of(context).pop();
      //loginError();
    }
  }

  Color getPrim() {
    return MzanziInnovationHub.of(context)!.theme.secondaryColor();
  }

  Color getSec() {
    return MzanziInnovationHub.of(context)!.theme.primaryColor();
  }

  void prePassResteWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                width: 500.0,
                height: 450,
                decoration: BoxDecoration(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      width: 5.0),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    //mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 100,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        " Password Reset Confirmation",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "Before you reset your password, please be aware that you'll receive an email with a link to confirm your identity and set a new password. Make sure to check your inbox, including spam or junk folders. If you don't receive the email within a few minutes, please try resending the reset request.",
                          style: TextStyle(
                            color: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        width: 500.0,
                        height: 50.0,
                        child: MIHButton(
                          buttonText: "Continue",
                          buttonColor: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          textColor: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                          onTap: () {
                            setState(() {
                              acceptWarning = true;
                            });
                            Navigator.of(context).pop();
                            validateInput();
                          },
                        ),
                      ),
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
            ],
          ),
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

  MIHBody getBody() {
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
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //logo
                      Icon(
                        Icons.lock,
                        size: 100,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                      //spacer
                      const SizedBox(height: 10),
                      //Heading
                      Text(
                        'Forgot Password',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                        ),
                      ),
                      //spacer
                      const SizedBox(height: 25),

                      //email input
                      SizedBox(
                        width: 500.0,
                        child: MIHTextField(
                          controller: emailController,
                          hintText: 'Email',
                          editable: true,
                          required: true,
                        ),
                      ),

                      //spacer
                      const SizedBox(height: 30),
                      // sign in button
                      SizedBox(
                        width: 500.0,
                        height: 50.0,
                        child: MIHButton(
                          buttonText: "Reset Password",
                          buttonColor: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          textColor: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                          onTap: () {
                            prePassResteWarning();
                          },
                        ),
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
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(),
      body: getBody(),
      rightDrawer: null,
      bottomNavBar: null,
    );
  }
}
