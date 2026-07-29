import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_authentication_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_authentication_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

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

  void submitFormInput() async {
    await MihAuthenticationServices().signUserUp(
      emailController.text,
      passwordController.text,
      confirmPasswordController.text,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
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
            MihAlertServices().inputErrorAlert(context);
          }
        }
      },
      child: MihSingleChildScroll(
        scrollbarOn: true,
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
                color: MihColors.secondary(),
              ),
              //spacer
              const SizedBox(height: 10),
              //Heading
              Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: MihColors.secondary(),
                ),
              ),
              //spacer
              // const SizedBox(height: 20),
              MihForm(
                formKey: _formKey,
                formFields: [
                  //email input
                  MihTextFormField(
                    fillColor: MihColors.secondary(),
                    inputColor: MihColors.primary(),
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
                    fillColor: MihColors.secondary(),
                    inputColor: MihColors.primary(),
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
                    fillColor: MihColors.secondary(),
                    inputColor: MihColors.primary(),
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
                              MihAlertServices().inputErrorAlert(context);
                            }
                          },
                          buttonColor: MihColors.green(),
                          width: 300,
                          child: Text(
                            "Create New Account",
                            style: TextStyle(
                              color: MihColors.primary(),
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
                          buttonColor: MihColors.secondary(),
                          width: 300,
                          child: Text(
                            "I have an account",
                            style: TextStyle(
                              color: MihColors.primary(),
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
