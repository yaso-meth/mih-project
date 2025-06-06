import 'dart:convert';

import 'package:mzansi_innovation_hub/mih_apis/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_install_services.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:supertokens_flutter/supertokens.dart';
import '../../mih_components/mih_layout/mih_action.dart';
import '../../mih_components/mih_layout/mih_body.dart';
import '../../mih_components/mih_layout/mih_header.dart';
import '../../mih_components/mih_layout/mih_layout_builder.dart';
import '../../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../../mih_env/env.dart';

class Register extends StatefulWidget {
  final Function()? onTap;
  const Register({super.key, required this.onTap});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final officeID = TextEditingController();
  final baseAPI = AppEnviroment.baseApiUrl;
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  bool successfulSignUp = false;

  Future<void> addUserAPICall(String email, String uid) async {
    //await getOfficeIdByUser(docOfficeIdApiUrl + widget.userEmail);
    //print(futureDocOfficeId.toString());
    var response = await http.post(
      Uri.parse("$baseAPI/user/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "email": email,
        "app_id": uid,
      }),
    );
    if (response.statusCode == 201) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/',
        (route) => false,
        arguments: AuthArguments(
          true,
          true,
        ),
      );
      // signUpSuccess();
      // setState(() {
      //   successfulSignUp = true;
      // });
    } else {
      internetConnectionPopUp();
    }
  }

  //sign user in
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

  bool validEmail() {
    String text = emailController.text;
    var regex = RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
    return regex.hasMatch(text);
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void signUpSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHSuccessMessage(
            successType: "Success",
            successMessage:
                "Congratulations! Your account has been created successfully. You are logged in and can start exploring.\n\nPlease note: more apps will appear once you update your profile.");
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

  void emailError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Invalid Email");
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

  void loginError(error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(error),
        );
      },
    );
  }

  void submitFormInput() async {
    await signUserUp();
  }

  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget getSecondaryActionButton() {
    return Visibility(
      visible: MzanziInnovationHub.of(context)!.theme.getPlatform() == "Web",
      child: MIHAction(
        icon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: MihButton(
            onPressed: () {
              MihInstallServices().installMihTrigger(context);
            },
            buttonColor:
                MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 150,
            child: Text(
              "Install MIH",
              style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        iconSize: 35,
        onTap: () {
          MihInstallServices().installMihTrigger(context);
        },
      ),
    );
  }

  MIHAction getActionButton() {
    return MIHAction(
      icon: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 50,
          child: FittedBox(
            child: Icon(
              MihIcons.mihLogo,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
        ),
      ),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pushNamed(
          '/about',
          arguments: 0,
        );
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
              if (_formKey.currentState!.validate()) {
                submitFormInput();
              } else {
                MihAlertServices().formNotFilledCompletely(context);
              }
            }
          },
          child: SafeArea(
              child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: MzanziInnovationHub.of(context)!.theme.screenType ==
                        "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.2)
                    : EdgeInsets.symmetric(horizontal: width * 0.075),
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
                      'Create an Account',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                    ),
                    //spacer
                    // const SizedBox(height: 20),
                    MihForm(
                      formKey: _formKey,
                      formFields: [
                        //email input
                        MihTextFormField(
                          fillColor: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          inputColor: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
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
                          fillColor: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          inputColor: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                          controller: passwordController,
                          multiLineInput: false,
                          requiredText: true,
                          hintText: "Password",
                          passwordMode: true,
                          autofillHints: const [AutofillHints.password],
                          validator: (value) {
                            return MihValidationServices()
                                .validatePassword(value);
                          },
                        ),
                        //spacer
                        const SizedBox(height: 10),
                        MihTextFormField(
                          fillColor: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          inputColor: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                          controller: confirmPasswordController,
                          multiLineInput: false,
                          requiredText: true,
                          hintText: "Confirm Password",
                          passwordMode: true,
                          autofillHints: const [AutofillHints.password],
                          validator: (value) {
                            return MihValidationServices()
                                .validatePassword(value);
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
                                buttonColor: MzanziInnovationHub.of(context)!
                                    .theme
                                    .successColor(),
                                width: 300,
                                child: Text(
                                  "Create New Account",
                                  style: TextStyle(
                                    color: MzanziInnovationHub.of(context)!
                                        .theme
                                        .primaryColor(),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              MihButton(
                                onPressed: widget.onTap,
                                buttonColor: MzanziInnovationHub.of(context)!
                                    .theme
                                    .secondaryColor(),
                                width: 300,
                                child: Text(
                                  "I have an account",
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

                        //here
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    officeID.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(),
      secondaryActionButton: getSecondaryActionButton(),
      body: getBody(screenWidth),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
  }
}
