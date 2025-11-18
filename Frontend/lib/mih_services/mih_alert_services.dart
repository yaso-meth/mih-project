import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MihAlertServices {
  void internetConnectionLost(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          backgroundColor: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          windowBody: Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              Center(
                child: Text(
                  "Internet Connection Lost!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "We seem to be having some trouble connecting you to the internet. This could be due to a temporary outage or an issue with your device's connection.",
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              MihButton(
                onPressed: () {
                  context.pop();
                },
                buttonColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                width: 300,
                elevation: 10,
                child: Text(
                  "Dismiss",
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void locationPermissionError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          backgroundColor: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          windowBody: Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              Center(
                child: Text(
                  "Location Services Not Enabled",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "To get the most out of MIH, we need your location. Please go to the site settings of the app and enable location services. Once you do that, we can start showing you relevant information based on your location.",
                style: TextStyle(
                  color: MihColors.getRedColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              MihButton(
                onPressed: () {
                  context.pop();
                },
                buttonColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                width: 300,
                elevation: 10,
                child: Text(
                  "Dismiss",
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void inputErrorMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          backgroundColor: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          windowBody: Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              Center(
                child: Text(
                  "Oops! Looks like some fields are missing.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "We noticed that some required fields are still empty. To ensure your request is processed smoothly, please fill out all the highlighted fields before submitting the form again.",
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Here's a quick tip: ",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: MihColors.getRedColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"))),
                    const TextSpan(text: "Look for fields with an asterisk ("),
                    TextSpan(
                        text: "*",
                        style: TextStyle(
                            color: MihColors.getRedColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"))),
                    const TextSpan(
                        text: ") next to them, as these are mandatory."),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              MihButton(
                onPressed: () {
                  context.pop();
                },
                buttonColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                width: 300,
                elevation: 10,
                child: Text(
                  "Dismiss",
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void passwordRequiredError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          backgroundColor: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          windowBody: Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              Center(
                child: Text(
                  "Password Doesn't Meet Requirements",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Oops! Your password doesn't quite meet our standards. To keep your account secure, please make sure your password meets the following requirements",
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Requirements:\n",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            color: MihColors.getRedColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"))),
                    const TextSpan(
                      text: "1) Contailes at least 8 characters\n",
                    ),
                    const TextSpan(
                      text: "2) Contains at least 1 uppercase letter (A-Z)\n",
                    ),
                    const TextSpan(
                      text: "3) Contains at least 1 lowercase letter (a-z)\n",
                    ),
                    const TextSpan(
                      text: "4) Contains at least 1 number (0-9)\n",
                    ),
                    const TextSpan(
                      text:
                          "5) Contains at least 1 special character (!@#\$%^&*)\n",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              MihButton(
                onPressed: () {
                  context.pop();
                },
                buttonColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                width: 300,
                elevation: 10,
                child: Text(
                  "Dismiss",
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void passwordMatchError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          backgroundColor: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          windowBody: Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              Center(
                child: Text(
                  "Passwords Don't Match",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "The password and confirm password fields do not match. Please make sure they are identical.",
                style: TextStyle(
                  color: MihColors.getRedColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Here are some things to keep in mind:",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              MihButton(
                onPressed: () {
                  context.pop();
                },
                buttonColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                width: 300,
                elevation: 10,
                child: Text(
                  "Dismiss",
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void loginErrorMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          backgroundColor: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          windowBody: Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              Center(
                child: Text(
                  "Uh oh! Login attempt unsuccessful.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "The email address or password you entered doesn't seem to match our records. Please double-check your information and try again.",
                style: TextStyle(
                  color: MihColors.getRedColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Here are some things to keep in mind:",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "1) Are you sure you're using the correct email address associated with your account?\n2) Is your caps lock key on? Passwords are case-sensitive.\n3) If you've forgotten your password, no worries! Click on \"Forgot Password?\" to reset it.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              MihButton(
                onPressed: () {
                  context.pop();
                },
                buttonColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                width: 300,
                elevation: 10,
                child: Text(
                  "Dismiss",
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void emailExistsError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          backgroundColor: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          windowBody: Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              Center(
                child: Text(
                  "Email Already Exists",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Here are some things to keep in mind:",
                style: TextStyle(
                  color: MihColors.getRedColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "1) Are you sure you're using the correct email address associated with your account?\n2) Is your caps lock key on? Passwords are case-sensitive.\n3) If you've forgotten your password, no worries! Click on \"Forgot Password?\" to reset it.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              MihButton(
                onPressed: () {
                  context.pop();
                },
                buttonColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                width: 300,
                elevation: 10,
                child: Text(
                  "Dismiss",
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void invalidEmailError(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          backgroundColor: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          windowBody: Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              Center(
                child: Text(
                  "Oops! Invalid Email",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Looks like there's a little hiccup with that email address. Please double-check that you've entered it correctly, including the \"@\" symbol and a domain (like example@email.com).",
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              MihButton(
                onPressed: () {
                  context.pop();
                },
                buttonColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                width: 300,
                elevation: 10,
                child: Text(
                  "Dismiss",
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void successAlert(String title, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.check_circle_outline_rounded,
            size: 150,
            color: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          alertTitle: title,
          alertBody: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
          alertColour: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      },
    );
  }

  void warningMessage(String title, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          backgroundColor: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          windowBody: Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                message,
                style: TextStyle(
                  color: MihColors.getRedColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              MihButton(
                onPressed: () {
                  context.pop();
                },
                buttonColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                width: 300,
                elevation: 10,
                child: Text(
                  "Dismiss",
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void deleteConfirmationMessage(
      String message, void Function()? onpressed, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          backgroundColor: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          windowBody: Column(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 100,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              Center(
                child: Text(
                  "Are You Sure?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                message,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              MihButton(
                onPressed: onpressed,
                buttonColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                width: 300,
                elevation: 10,
                child: Text(
                  "Delete",
                  style: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void errorAlert(String title, String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.warning_amber_rounded,
            size: 150,
            color: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          alertTitle: title,
          alertBody: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
          alertColour: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      },
    );
  }
}
