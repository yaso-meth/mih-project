import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/components/homeTile.dart';
import 'package:patient_manager/components/popUpMessages/mihLoadingCircle.dart';
import 'package:patient_manager/components/popUpMessages/mihErrorMessage.dart';
import 'package:patient_manager/components/inputsAndButtons/mihPassInput.dart';
import 'package:patient_manager/components/inputsAndButtons/mihTextInput.dart';
import 'package:patient_manager/components/inputsAndButtons/mihButton.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supertokens_flutter/http.dart' as http;

class SignIn extends StatefulWidget {
  final Function()? onTap;
  const SignIn({super.key, required this.onTap});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  //bool _obscureText = true;
  bool successfulSignIn = false;
  // focus node to capture keyboard events
  final FocusNode _focusNode = FocusNode();

  final baseAPI = AppEnviroment.baseApiUrl;

  late List<HomeTile> sandboxProfileList = [];

  //sign user in
  Future<void> signUserIn() async {
    //var _backgroundColor = Colors.transparent;

    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );

    try {
      var response = await http.post(
        Uri.parse("$baseAPI/auth/signin"),
        body:
            '{"formFields": [{"id": "email","value": "${emailController.text}"}, {"id": "password","value": "${passwordController.text}"}]}',
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "leatucczyixqwkqqdrhayiwzeofkltds"
        },
      );
      //print(response.body[])
      if (response.statusCode == 200) {
        //print(response.body);
        var userSignedin = jsonDecode(response.body);
        if (userSignedin["status"] == "OK") {
          //print("here");
          setState(() {
            successfulSignIn = true;
          });
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
          loginError();
          passwordController.clear();
        }
      }
    } on AuthException {
      Navigator.of(context).pop();
      loginError();
      passwordController.clear();
    }
  }

  Color getPrim() {
    return MzanziInnovationHub.of(context)!.theme.secondaryColor();
  }

  Color getSec() {
    return MzanziInnovationHub.of(context)!.theme.primaryColor();
  }

  void setSandboxProfiles(List<HomeTile> tileList) {
    tileList.add(HomeTile(
      onTap: () {
        setState(() {
          emailController.text = "testpatient@mzansi-innovation-hub.co.za";
          passwordController.text = "Testprofile@1234";
        });
        validateInput();
      },
      tileName: "Patient",
      tileIcon: Icon(
        Icons.perm_identity_rounded,
        color: getSec(),
        size: 200,
      ),
      p: getPrim(),
      s: getSec(),
    ));
    tileList.add(HomeTile(
      onTap: () {
        setState(() {
          emailController.text = "testdoctor@mzansi-innovation-hub.co.za";
          passwordController.text = "Testprofile@1234";
        });
        validateInput();
      },
      tileName: "Doctor",
      tileIcon: Icon(
        Icons.medical_services,
        color: getSec(),
        size: 200,
      ),
      p: getPrim(),
      s: getSec(),
    ));
    //if (AppEnviroment.getEnv() == "Dev") {
    tileList.add(HomeTile(
      onTap: () {
        setState(() {
          emailController.text = "test@mzansi-innovation-hub.co.za";
          passwordController.text = "Testprofile@1234";
        });
        validateInput();
      },
      tileName: "Test",
      tileIcon: Icon(
        Icons.warning_amber_rounded,
        color: getSec(),
        size: 200,
      ),
      p: getPrim(),
      s: getSec(),
    ));
    //}
  }

  void loginError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Invalid Credentials");
      },
    );
  }

  void validateInput() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    } else {
      await signUserIn();
      if (successfulSignIn) {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }

  void showSandboxProfiles() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          //backgroundColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                width: 500.0,
                height: 500,
                decoration: BoxDecoration(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      width: 5.0),
                ),
                child: Column(
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Sandbox Profiles",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "NB: These accounts are used for test purposes. Please do not store personal information on these profiles.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Expanded(
                      child: GridView.builder(
                        // physics: ,
                        // shrinkWrap: true,
                        itemCount: sandboxProfileList.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisSpacing: 10, maxCrossAxisExtent: 100),
                        itemBuilder: (context, index) {
                          return sandboxProfileList[index];
                        },
                      ),
                    ),
                  ],
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

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      setSandboxProfiles(sandboxProfileList);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) async {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          validateInput();
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
                      'Sign In Now',
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

                    SizedBox(
                      width: 500.0,
                      //height: 100.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showSandboxProfiles();
                            },
                            child: Text(
                              'Sandbox Profile',
                              style: TextStyle(
                                fontSize: 18,
                                color: MzanziInnovationHub.of(context)!
                                    .theme
                                    .secondaryColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
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
                        signIn: true,
                      ),
                    ),
                    SizedBox(
                      width: 500.0,
                      //height: 100.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                '/forgot-password',
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 15,
                                color: MzanziInnovationHub.of(context)!
                                    .theme
                                    .secondaryColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    //spacer
                    const SizedBox(height: 30),
                    // sign in button
                    SizedBox(
                      width: 500.0,
                      height: 50.0,
                      child: MIHButton(
                        buttonText: "Sign In",
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        onTap: () async {
                          validateInput();
                        },
                      ),
                    ),
                    //spacer
                    const SizedBox(height: 10),
                    //register text
                    SizedBox(
                      width: 500.0,
                      //height: 100.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'New User?',
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 201, 200, 200)),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: Text(
                              'Register Now',
                              style: TextStyle(
                                fontSize: 18,
                                color: MzanziInnovationHub.of(context)!
                                    .theme
                                    .secondaryColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
