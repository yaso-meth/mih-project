import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';

class MihAlertServices {
  void formNotFilledCompletely(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.warning_amber_rounded,
            size: 150,
            color: MzansiInnovationHub.of(context)!.theme.errorColor(),
          ),
          alertTitle: "Oops! Looks like some fields are missing.",
          alertBody: Column(
            children: [
              Text(
                "We noticed that some required fields are still empty. To ensure your request is processed smoothly, please fill out all the highlighted fields before submitting the form again.",
                style: TextStyle(
                  color:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: "Here's a quick tip: ",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: MzansiInnovationHub.of(context)!
                                .theme
                                .errorColor())),
                    const TextSpan(
                        text:
                            "Look for fields without the \"(Optional)\" indicator next to them, as these are mandatory."),
                  ],
                ),
              ),
            ],
          ),
          alertColour: MzansiInnovationHub.of(context)!.theme.errorColor(),
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
            color: MzansiInnovationHub.of(context)!.theme.successColor(),
          ),
          alertTitle: title,
          alertBody: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
          alertColour: MzansiInnovationHub.of(context)!.theme.successColor(),
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
            color: MzansiInnovationHub.of(context)!.theme.errorColor(),
          ),
          alertTitle: title,
          alertBody: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
          alertColour: MzansiInnovationHub.of(context)!.theme.errorColor(),
        );
      },
    );
  }
}
