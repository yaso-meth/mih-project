import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_tile.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_authentication_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_authentication_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_install_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MihSignIn extends StatefulWidget {
  const MihSignIn({
    super.key,
  });

  @override
  State<MihSignIn> createState() => _MihSignInState();
}

class _MihSignInState extends State<MihSignIn> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool successfulSignIn = false;
  bool showProfiles = false;
  final baseAPI = AppEnviroment.baseApiUrl;
  late List<MIHTile> sandboxProfileList = [];

  //sign user in
  Future<void> signUserIn() async {
    try {
      successfulSignIn = await MihAuthenticationServices().signUserIn(
        emailController.text,
        passwordController.text,
        context,
      );
      if (!successfulSignIn) {
        loginError();
        passwordController.clear();
      }
    } on Exception {
      Navigator.of(context).pop();
      loginError();
      passwordController.clear();
    }
  }

  void submitSignInForm() async {
    await signUserIn();
    if (successfulSignIn) {
      context.goNamed(
        'mihHome',
        extra: true,
      );
    }
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

  Color getPrim() {
    return MihColors.getSecondaryColor(
        MzansiInnovationHub.of(context)!.theme.mode == "Dark");
  }

  Color getSec() {
    return MihColors.getPrimaryColor(
        MzansiInnovationHub.of(context)!.theme.mode == "Dark");
  }

  void loginError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Invalid Credentials");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      setSandboxProfiles(sandboxProfileList);
    });
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
            submitSignInForm();
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
          child: AutofillGroup(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: MzansiInnovationHub.of(context)!
                              .theme
                              .getPlatform() ==
                          "Web",
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: MihButton(
                          onPressed: () {
                            MihInstallServices().installMihTrigger(context);
                          },
                          buttonColor: MihColors.getGreenColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          width: 150,
                          child: Text(
                            "Install MIH",
                            style: TextStyle(
                              color: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                  'Sign In',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
                //spacer
                const SizedBox(height: 10),
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
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      inputColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      controller: passwordController,
                      multiLineInput: false,
                      requiredText: true,
                      hintText: "Password",
                      passwordMode: true,
                      autofillHints: const [AutofillHints.password],
                      validator: (value) {
                        // return MihValidationServices().validatePassword(value);
                        return null;
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
                              // Navigator.of(context).pushNamed(
                              //   '/forgot-password',
                              // );
                              context.goNamed(
                                'forgotPassword',
                              );
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: 15,
                                color: MihColors.getSecondaryColor(
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
                                        "Dark"),
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
                            buttonColor: MihColors.getGreenColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            width: 300,
                            child: Text(
                              "Sign In",
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
                          MihButton(
                            onPressed: () {
                              context
                                  .read<MihAuthenticationProvider>()
                                  .setToolIndex(1);
                            },
                            buttonColor: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            width: 300,
                            child: Text(
                              "Create New Account",
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
                        ],
                      ),
                    ),

                    //spacer
                    const SizedBox(height: 35),
                    Visibility(
                      visible: AppEnviroment.getEnv() == "Dev",
                      child: Center(
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
                                        color: MihColors.getSecondaryColor(
                                            MzansiInnovationHub.of(context)!
                                                    .theme
                                                    .mode ==
                                                "Dark")),
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
                              // const SizedBox(height: 10),
                              Text(
                                "NB: These accounts are used for test purposes. Please do not store personal information on these profiles.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: MihColors.getRedColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
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
    );
  }
}
