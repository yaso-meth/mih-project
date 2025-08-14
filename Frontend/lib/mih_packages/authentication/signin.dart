import 'dart:convert';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_install_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import 'package:supertokens_flutter/http.dart' as http;
import '../../mih_components/mih_layout/mih_action.dart';
import '../../mih_components/mih_layout/mih_body.dart';
import '../../mih_components/mih_layout/mih_header.dart';
import '../../mih_components/mih_layout/mih_layout_builder.dart';
import '../../mih_components/mih_layout/mih_tile.dart';
import '../../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_config/mih_env.dart';

class SignIn extends StatefulWidget {
  final Function() onTap;
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
  final _formKey = GlobalKey<FormState>();

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
    return MzansiInnovationHub.of(context)!.theme.secondaryColor();
  }

  Color getSec() {
    return MzansiInnovationHub.of(context)!.theme.primaryColor();
  }

  void setSandboxProfiles(List<MIHTile> tileList) {
    tileList.add(MIHTile(
      onTap: () {
        setState(() {
          emailController.text = "testpatient@mzansi-innovation-hub.co.za";
          passwordController.text = "Testprofile@1234";
        });
        if (_formKey.currentState!.validate()) {
          submitSignInForm();
        } else {
          MihAlertServices().formNotFilledCompletely(context);
        }
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
        if (_formKey.currentState!.validate()) {
          submitSignInForm();
        } else {
          MihAlertServices().formNotFilledCompletely(context);
        }
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
        if (_formKey.currentState!.validate()) {
          submitSignInForm();
        } else {
          MihAlertServices().formNotFilledCompletely(context);
        }
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
        if (_formKey.currentState!.validate()) {
          submitSignInForm();
        } else {
          MihAlertServices().formNotFilledCompletely(context);
        }
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

  void submitSignInForm() async {
    await signUserIn();
    if (successfulSignIn) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/',
        (route) => false,
        arguments: AuthArguments(
          true,
          true,
        ),
      );
    }
  }

  void showSandboxProfiles() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          //backgroundColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                width: 500.0,
                height: 500,
                decoration: BoxDecoration(
                  color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                      color: MzansiInnovationHub.of(context)!
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
                        color: MzansiInnovationHub.of(context)!
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
                        color: MzansiInnovationHub.of(context)!
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
                    color: MihColors.getRedColor(context),
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

  Widget getSecondaryActionButton() {
    return Visibility(
      visible: MzansiInnovationHub.of(context)!.theme.getPlatform() == "Web",
      child: MIHAction(
        icon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: MihButton(
            onPressed: () {
              MihInstallServices().installMihTrigger(context);
            },
            buttonColor: MihColors.getGreenColor(context),
            width: 150,
            child: Text(
              "Install MIH",
              style: TextStyle(
                color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
                fontSize: 20,
                fontWeight: FontWeight.bold,
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
              color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
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
                submitSignInForm();
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
                  padding: MzansiInnovationHub.of(context)!.theme.screenType ==
                          "desktop"
                      ? EdgeInsets.symmetric(horizontal: width * 0.2)
                      : EdgeInsets.symmetric(horizontal: width * 0.075),
                  child: AutofillGroup(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //logo
                        Icon(
                          Icons.lock,
                          size: 100,
                          color: MzansiInnovationHub.of(context)!
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
                            color: MzansiInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                          ),
                        ),
                        //spacer
                        const SizedBox(height: 10),
                        MihForm(
                          formKey: _formKey,
                          formFields: [
                            MihTextFormField(
                              fillColor: MzansiInnovationHub.of(context)!
                                  .theme
                                  .secondaryColor(),
                              inputColor: MzansiInnovationHub.of(context)!
                                  .theme
                                  .primaryColor(),
                              controller: emailController,
                              multiLineInput: false,
                              requiredText: true,
                              hintText: "Email",
                              autofillHints: const [AutofillHints.email],
                              validator: (value) {
                                return MihValidationServices()
                                    .validateEmail(value);
                              },
                            ),
                            //spacer
                            const SizedBox(height: 10),
                            //password input
                            MihTextFormField(
                              fillColor: MzansiInnovationHub.of(context)!
                                  .theme
                                  .secondaryColor(),
                              inputColor: MzansiInnovationHub.of(context)!
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
                            const SizedBox(height: 10),
                            SizedBox(
                              // width: 500.0,
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
                                        color: MzansiInnovationHub.of(context)!
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
                            const SizedBox(height: 20),
                            // sign in button
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
                                        submitSignInForm();
                                      } else {
                                        MihAlertServices()
                                            .formNotFilledCompletely(context);
                                      }
                                    },
                                    buttonColor:
                                        MzansiInnovationHub.of(context)!
                                            .theme
                                            .successColor(),
                                    width: 300,
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: MzansiInnovationHub.of(context)!
                                            .theme
                                            .primaryColor(),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  MihButton(
                                    onPressed: widget.onTap,
                                    buttonColor:
                                        MzansiInnovationHub.of(context)!
                                            .theme
                                            .secondaryColor(),
                                    width: 300,
                                    child: Text(
                                      "Create New Account",
                                      style: TextStyle(
                                        color: MzansiInnovationHub.of(context)!
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

                            //spacer
                            const SizedBox(height: 35),
                            Center(
                              child: SizedBox(
                                width: width,
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
                                              color: MzansiInnovationHub.of(
                                                      context)!
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
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Visibility(
                                visible: showProfiles,
                                child: SizedBox(
                                  width: 500,
                                  child: Column(
                                    //mainAxisSize: MainAxisSize.max,
                                    children: [
                                      GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
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
                                          color:
                                              MzansiInnovationHub.of(context)!
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
        ),
      ],
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _focusNode.dispose();
    TextInput.finishAutofillContext();
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
