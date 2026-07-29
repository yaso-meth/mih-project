import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_authentication_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MihSoftLoginPopup extends StatefulWidget {
  const MihSoftLoginPopup({super.key});

  @override
  State<MihSoftLoginPopup> createState() => _MihSoftLoginPopupState();
}

class _MihSoftLoginPopupState extends State<MihSoftLoginPopup> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void autoFillTestUser() {
    setState(() {
      emailController.text = "test@mzansi-innovation-hub.co.za";
      passwordController.text = "Testprofile@1234";
    });
  }

  //sign user in
  Future<void> signUserIn() async {
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    try {
      bool successfulSignIn = await MihAuthenticationServices().signUserIn(
        emailController.text,
        passwordController.text,
        context,
      );
      if (!successfulSignIn) {
        MihAlertServices().loginErrorAlert(context);
        passwordController.clear();
      } else {
        await profileProvider.syncWithMihServerData();
        context.pop(true);
      }
    } on Exception {
      context.pop();
      MihAlertServices().internetConnectionAlert(context);
      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: null,
      onWindowTapClose: () {
        context.pop();
      },
      windowBody: MihSingleChildScroll(
        scrollbarOn: false,
        child: Padding(
          padding:
              MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.05)
                  : EdgeInsets.symmetric(horizontal: width * 0),
          child: Column(
            children: [
              Icon(
                Icons.lock,
                size: 100,
                color: MihColors.secondary(),
              ),
              const SizedBox(height: 10),
              Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: MihColors.secondary(),
                ),
              ),
              const SizedBox(height: 10),
              MihForm(
                formKey: _formKey,
                formFields: [
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
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 20),
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
                              signUserIn();
                            } else {
                              MihAlertServices().inputErrorAlert(context);
                            }
                          },
                          buttonColor: MihColors.green(),
                          width: 300,
                          child: Text(
                            "Sign In",
                            style: TextStyle(
                              color: MihColors.primary(),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (AppEnviroment.getEnv() == "Dev")
                          MihButton(
                            onPressed: () {
                              autoFillTestUser();
                            },
                            buttonColor: MihColors.yellow(),
                            width: 300,
                            child: Text(
                              "Autofill",
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
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
