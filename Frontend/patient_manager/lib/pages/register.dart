import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/components/myPassInput.dart';
import 'package:patient_manager/components/mySuccessMessage.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
//import 'package:patient_manager/objects/sessionST.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
//import 'package:supertokens_flutter/supertokens.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:supertokens_flutter/supertokens.dart';

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
      Navigator.of(context).popAndPushNamed('/home');
      signUpSuccess();
      // setState(() {
      //   successfulSignUp = true;
      // });
    } else {
      internetConnectionPopUp();
    }
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MyErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  //sign user in
  Future<void> signUserUp() async {
    if (passwordController.text != confirmPasswordController.text) {
      passwordError();
    } else {
      var _backgroundColor = Colors.transparent;

      showDialog(
        context: context,
        barrierColor: _backgroundColor,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
              backgroundColor: _backgroundColor,
              content: const Center(
                child: CircularProgressIndicator(),
              ));
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
                passwordError();
              } else {
                Navigator.of(context).pop();
                internetConnectionPopUp();
              }
            }
          }
        }
      } on AuthException catch (error) {
        Navigator.of(context).pop();
        loginError(error.message);
        emailController.clear();
        passwordController.clear();
        confirmPasswordController.clear();
      }
    }
  }

  void signUpSuccess() {
    showDialog(
      context: context,
      builder: (context) {
        return const MySuccessMessage(
            successType: "Success",
            successMessage:
                "Congratulations! Your account has been created successfully. You are log in and can start exploring.\n\nPlease note: more apps will appear once you update your profile.");
      },
    );
  }

  void signUpError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MyErrorMessage(errorType: "User Exists");
      },
    );
  }

  void passwordError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MyErrorMessage(errorType: "Password Requirements");
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

  void toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) async {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          if (emailController.text.isEmpty || passwordController.text.isEmpty) {
            showDialog(
              context: context,
              builder: (context) {
                return const MyErrorMessage(errorType: "Input Error");
              },
            );
          } else {
            await signUserUp();
          }
        }
      },
      child: Scaffold(
        //backgroundColor: Colors.white,
        body: SafeArea(
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
                      'Register',
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
                      child: MyTextField(
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
                      child: MyPassField(
                        controller: passwordController,
                        hintText: 'Password',
                        required: true,
                      ),
                    ),
                    //spacer
                    const SizedBox(height: 10),
                    //password input
                    SizedBox(
                      width: 500.0,
                      child: MyPassField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm Password',
                        required: true,
                      ),
                    ),
                    //spacer
                    const SizedBox(height: 10),
                    // sign up button
                    SizedBox(
                      width: 500.0,
                      height: 100.0,
                      child: MyButton(
                        buttonText: "Sign Up",
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        onTap: () async {
                          if (emailController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const MyErrorMessage(
                                    errorType: "Input Error");
                              },
                            );
                          } else {
                            await signUserUp();
                          }
                        },
                      ),
                    ),
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
          ),
        ),
      ),
    );
  }
}
