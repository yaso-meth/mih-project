import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_authentication_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:supertokens_flutter/supertokens.dart';

class MihRegister extends StatefulWidget {
  const MihRegister({
    super.key,
  });

  @override
  State<MihRegister> createState() => _MihRegisterState();
}

class _MihRegisterState extends State<MihRegister> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final baseAPI = AppEnviroment.baseApiUrl;

  Future<void> addUserAPICall(String email, String uid) async {
    //await getOfficeIdByUser(docOfficeIdApiUrl + widget.userEmail);
    //print(futureDocOfficeId.toString());
    await MihUserServices().createUser(
      email,
      uid,
      context,
    );
    // var response = await http.post(
    //   Uri.parse("$baseAPI/user/insert/"),
    //   headers: <String, String>{
    //     "Content-Type": "application/json; charset=UTF-8"
    //   },
    //   body: jsonEncode(<String, dynamic>{
    //     "email": email,
    //     "app_id": uid,
    //   }),
    // );
    // if (response.statusCode == 201) {
    //   Navigator.of(context).pushNamedAndRemoveUntil(
    //     '/',
    //     (route) => false,
    //     arguments: AuthArguments(
    //       true,
    //       true,
    //     ),
    //   );
    //   // signUpSuccess();
    //   // setState(() {
    //   //   successfulSignUp = true;
    //   // });
    // } else {
    //   internetConnectionPopUp();
    // }
  }

  Future<void> signUserUp() async {
    if (!validEmail()) {
      emailError();
    } else if (passwordController.text != confirmPasswordController.text) {
      passwordError();
    } else {
      //var _backgroundColor = Colors.transparent;
      showDialog(
        context: context,
        builder: (context) {
          return const Mihloadingcircle();
        },
      );
      try {
        Uri uri = Uri.parse(
            "$baseAPI/auth/emailpassword/email/exists?email=${emailController.text}");
        //print("Here");
        var response = await http.get(uri);
        //print(response.body);
        //print("response 1: ${response.statusCode}");
        if (response.statusCode == 200) {
          var userExists = jsonDecode(response.body);
          if (userExists["exists"]) {
            Navigator.of(context).pop();
            signUpError();
          } else {
            var response2 = await http.post(
              Uri.parse("$baseAPI/auth/signup"),
              body:
                  '{"formFields": [{"id": "email","value": "${emailController.text}"}, {"id": "password","value": "${passwordController.text}"}]}',
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
                "Authorization": "leatucczyixqwkqqdrhayiwzeofkltds"
              },
            );
            //print("response 2: ${response2.statusCode}");
            if (response2.statusCode == 200) {
              //print("response 2: ${response2.body}");
              var userCreated = jsonDecode(response2.body);
              //print("Created user $userCreated");
              if (userCreated["status"] == "OK") {
                //print("Here1");
                //Creat user in db
                String uid = await SuperTokens.getUserId();
                //print("uid: $uid");
                addUserAPICall(emailController.text, uid);
                Navigator.of(context).pop();
                //print("Here1");
              } else if (userCreated["status"] == "FIELD_ERROR") {
                Navigator.of(context).pop();
                passwordReqError();
              } else {
                Navigator.of(context).pop();
                internetConnectionPopUp();
              }
            }
          }
        }
      } on Exception catch (error) {
        Navigator.of(context).pop();
        loginError(error.toString());
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
      }
    }
  }

  void submitFormInput() async {
    await signUserUp();
  }

  bool validEmail() {
    String text = emailController.text;
    var regex = RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
    return regex.hasMatch(text);
  }

  void loginError(error) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.warning_amber_rounded,
            color: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            size: 100,
          ),
          alertTitle: "Error While Signing Up",
          alertBody: Text(
            "An error occurred while signing up. Please try again later.",
            style: TextStyle(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontSize: 18,
            ),
          ),
          alertColour: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      },
    );
  }

  void emailError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Invalid Email");
      },
    );
  }

  void signUpError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "User Exists");
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

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void passwordReqError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Password Requirements");
      },
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
            MihAlertServices().formNotFilledCompletely(context);
          }
        }
      },
      child: MihSingleChildScroll(
        child: Padding(
          padding:
              MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.2)
                  : EdgeInsets.symmetric(horizontal: width * 0.075),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                'Create an Account',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ),
              //spacer
              // const SizedBox(height: 20),
              MihForm(
                formKey: _formKey,
                formFields: [
                  //email input
                  MihTextFormField(
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    controller: emailController,
                    multiLineInput: false,
                    requiredText: true,
                    hintText: "Email",
                    autofillHints: const [AutofillHints.email],
                    validator: (value) {
                      return MihValidationServices().validateEmail(value);
                    },
                  ),
                  //spacer
                  const SizedBox(height: 10),
                  //password input
                  MihTextFormField(
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                  const SizedBox(height: 20),
                  // sign up button
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        MihButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              submitFormInput();
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
                            "Create New Account",
                            style: TextStyle(
                              color: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        MihButton(
                          onPressed: () {
                            context
                                .read<MihAuthenticationProvider>()
                                .setToolIndex(0);
                          },
                          buttonColor: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          width: 300,
                          child: Text(
                            "I have an account",
                            style: TextStyle(
                              color: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //here
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
