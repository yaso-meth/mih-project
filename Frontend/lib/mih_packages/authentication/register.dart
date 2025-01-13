import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
//import '../objects/sessionST.dart';
//import 'package:supertokens_flutter/supertokens.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:supertokens_flutter/supertokens.dart';

import '../../mih_components/mih_inputs_and_buttons/mih_button.dart';
import '../../mih_components/mih_inputs_and_buttons/mih_pass_input.dart';
import '../../mih_components/mih_inputs_and_buttons/mih_text_input.dart';
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
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      signUpSuccess();
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

  void validateInput() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    } else {
      await signUserUp();
    }
  }

  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  MIHAction getActionButton() {
    return MIHAction(
      icon: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 50,
          child: Image.asset('images/logo_light.png'),
        ),
      ),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pushNamed(
          '/about',
          //arguments: widget.signedInUser,
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
                      'Create a New Account',
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
                    const SizedBox(height: 10),
                    //password input
                    SizedBox(
                      width: 500.0,
                      child: MIHPassField(
                        controller: passwordController,
                        hintText: 'Password',
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
                        hintText: 'Confirm Password',
                        required: true,
                        signIn: false,
                      ),
                    ),
                    //spacer
                    const SizedBox(height: 30),
                    // sign up button
                    SizedBox(
                      width: 500.0,
                      height: 50.0,
                      child: MIHButton(
                        buttonText: "Create New Account",
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .successColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        onTap: () async {
                          validateInput();
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // SizedBox(
                    //   width: 500.0,
                    //   height: 50.0,
                    //   child: MIHButton(
                    //     buttonText: "Sign In",
                    //     buttonColor: MzanziInnovationHub.of(context)!
                    //         .theme
                    //         .secondaryColor(),
                    //     textColor: MzanziInnovationHub.of(context)!
                    //         .theme
                    //         .primaryColor(),
                    //     onTap: widget.onTap,
                    //   ),
                    // ),
                    // const SizedBox(height: 10),
                    //register text
                    SizedBox(
                      width: 500.0,
                      //height: 100.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Already a User?',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 18,
                                color: MzanziInnovationHub.of(context)!
                                    .theme
                                    .secondaryColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
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
