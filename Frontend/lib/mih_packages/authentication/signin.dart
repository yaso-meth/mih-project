import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import 'package:supertokens_flutter/http.dart' as http;

import '../../mih_components/mih_inputs_and_buttons/mih_button.dart';
import '../../mih_components/mih_inputs_and_buttons/mih_pass_input.dart';
import '../../mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import '../../mih_components/mih_layout/mih_action.dart';
import '../../mih_components/mih_layout/mih_body.dart';
import '../../mih_components/mih_layout/mih_header.dart';
import '../../mih_components/mih_layout/mih_layout_builder.dart';
import '../../mih_components/mih_layout/mih_tile.dart';
import '../../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_env/env.dart';

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
  bool showProfiles = false;

  // focus node to capture keyboard events
  final FocusNode _focusNode = FocusNode();

  final baseAPI = AppEnviroment.baseApiUrl;

  late List<MIHTile> sandboxProfileList = [];

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
    } on Exception {
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

  void setSandboxProfiles(List<MIHTile> tileList) {
    tileList.add(MIHTile(
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
    tileList.add(MIHTile(
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
    tileList.add(MIHTile(
      onTap: () {
        setState(() {
          emailController.text = "test-business@mzansi-innovation-hub.co.za";
          passwordController.text = "Testprofile@1234";
        });
        validateInput();
      },
      tileName: "Business",
      tileIcon: Icon(
        Icons.business,
        color: getSec(),
        size: 200,
      ),
      p: getPrim(),
      s: getSec(),
    ));
    tileList.add(MIHTile(
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
        TextInput.finishAutofillContext();
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
                  child: AutofillGroup(
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
                          'Sign In',
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

                        // SizedBox(
                        //   width: 500.0,
                        //   //height: 100.0,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       GestureDetector(
                        //         onTap: () {
                        //           showSandboxProfiles();
                        //         },
                        //         child: Text(
                        //           'Sandbox Profile',
                        //           style: TextStyle(
                        //             fontSize: 18,
                        //             color: MzanziInnovationHub.of(context)!
                        //                 .theme
                        //                 .secondaryColor(),
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // const SizedBox(height: 10),
                        //email input
                        SizedBox(
                          width: 500.0,
                          child: MIHTextField(
                            controller: emailController,
                            hintText: 'Email',
                            editable: true,
                            required: true,
                            autoFillHintGroup: const [AutofillHints.email],
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
                            autoFillHintGroup: const [AutofillHints.password],
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
                            onTap: widget.onTap,
                          ),
                        ),
                        //spacer
                        const SizedBox(height: 10),
                        //register text
                        // SizedBox(
                        //   width: 500.0,
                        //   //height: 100.0,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Text(
                        //         'New User?',
                        //         style: TextStyle(
                        //             fontSize: 18,
                        //             color: MzanziInnovationHub.of(context)!
                        //                 .theme
                        //                 .messageTextColor()),
                        //       ),
                        //       const SizedBox(
                        //         width: 6,
                        //       ),
                        //       GestureDetector(
                        //         onTap: widget.onTap,
                        //         child: Text(
                        //           'Register Now',
                        //           style: TextStyle(
                        //             fontSize: 18,
                        //             color: MzanziInnovationHub.of(context)!
                        //                 .theme
                        //                 .secondaryColor(),
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        //spacer
                        const SizedBox(height: 15),
                        SizedBox(
                          width: 500.0,
                          //height: 100.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: Divider(),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: GestureDetector(
                                  child: Text(
                                    'Use Sandox Profile',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: MzanziInnovationHub.of(context)!
                                            .theme
                                            .secondaryColor()),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      showProfiles = !showProfiles;
                                    });
                                  },
                                ),
                              ),
                              const Flexible(
                                flex: 1,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Divider(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: showProfiles,
                          child: SizedBox(
                            width: 500,
                            child: Column(
                              //mainAxisSize: MainAxisSize.max,
                              children: [
                                GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: sandboxProfileList.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          mainAxisSpacing: 10,
                                          maxCrossAxisExtent: 100),
                                  itemBuilder: (context, index) {
                                    return sandboxProfileList[index];
                                  },
                                ),
                                const SizedBox(height: 20),
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
                              ],
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
        ),
      ],
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
