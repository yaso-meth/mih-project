import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import '../../main.dart';
import 'package:supertokens_flutter/http.dart' as http;
import '../../mih_components/mih_inputs_and_buttons/mih_pass_input.dart';
import '../../mih_components/mih_layout/mih_action.dart';
import '../../mih_components/mih_layout/mih_body.dart';
import '../../mih_components/mih_layout/mih_header.dart';
import '../../mih_components/mih_layout/mih_layout_builder.dart';
import '../../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../../mih_env/env.dart';

class ResetPassword extends StatefulWidget {
  final String? token;
  const ResetPassword({
    super.key,
    required this.token,
  });

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  //bool _obscureText = true;
  bool successfulResetPassword = false;
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
      var callBody =
          '{"method": "token","formFields": [{"id": "password","value": "${passwordController.text}"}],"token": "${widget.token}"}';
      //print(callBody);
      var response = await http.post(
        Uri.parse("$baseAPI/auth/user/password/reset"),
        body: callBody,
        headers: {
          'Content-type': 'application/json; charset=utf-8',
          // 'Accept': 'application/json',
          //"Authorization": "leatucczyixqwkqqdrhayiwzeofkltds"
        },
      );
      //print(response.body[])
      if (response.statusCode == 200) {
        //print(response.body);
        var userPassReset = jsonDecode(response.body);
        if (userPassReset["status"] == "OK") {
          //print("here");
          setState(() {
            successfulResetPassword = true;
          });
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed('/');
        } else if (userPassReset["status"] == "FIELD_ERROR") {
          Navigator.of(context).pop();
          passwordReqError();
        } else {
          Navigator.of(context).pop();
          loginError();
        }
      }
    } on Exception {
      Navigator.of(context).pop();
      //loginError();
    }
  }

  void passwordReqError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Password Requirements");
      },
    );
  }

  Color getPrim() {
    return MzanziInnovationHub.of(context)!.theme.secondaryColor();
  }

  Color getSec() {
    return MzanziInnovationHub.of(context)!.theme.primaryColor();
  }

  void loginError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Invalid Credentials");
      },
    );
  }

  void resetSuccessfully() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHSuccessMessage(
            successType: "Success",
            successMessage:
                "Great news! Your password reset is complete. You can now log in to Mzansi Innovation Hub using your new password.");
      },
    );
  }

  void passwordError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Password Match");
      },
    );
  }

  void validateInput() async {
    if (passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    } else if (passwordController.text != confirmPasswordController.text) {
      passwordError();
    } else {
      await submitPasswodReset();
      if (successfulResetPassword) {
        resetSuccessfully();
      }
    }
  }

  MIHAction getActionButton() {
    return MIHAction(
      icon: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 50,
          child: Image.asset(
              'lib/mih_components/mih_package_components/assets/images/logo_light.png'),
        ),
      ),
      iconSize: 35,
      onTap: () {
        // Navigator.of(context).pushNamed(
        //   '/about',
        //   //arguments: widget.signedInUser,
        // );
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
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                        ),
                      ),
                      //spacer
                      // const SizedBox(height: 15),
                      // Text(
                      //   'token: ${widget.token}',
                      //   style: TextStyle(
                      //     fontSize: 15,
                      //     fontWeight: FontWeight.bold,
                      //     color: MzanziInnovationHub.of(context)!
                      //         .theme
                      //         .secondaryColor(),
                      //   ),
                      // ),
                      //spacer
                      const SizedBox(height: 25),
                      //email input
                      SizedBox(
                        width: 500.0,
                        child: MIHPassField(
                          controller: passwordController,
                          hintText: 'New Password',
                          required: true,
                          signIn: false,
                        ),
                      ),
                      //spacer
                      const SizedBox(height: 10),
                      //password input
                      SizedBox(
                        width: 500.0,
                        child: MIHPassField(
                          controller: confirmPasswordController,
                          hintText: 'Confirm New Password',
                          required: true,
                          signIn: false,
                        ),
                      ),

                      //spacer
                      const SizedBox(height: 25),
                      // sign in button
                      MihButton(
                        onPressed: () {
                          validateInput();
                        },
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        width: 300,
                        child: Text(
                          "Reset Password",
                          style: TextStyle(
                            color: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
    passwordController.dispose();
    confirmPasswordController.dispose();
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
      secondaryActionButton: null,
      body: getBody(),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
  }
}
