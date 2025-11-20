import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';

class PackageToolZero extends StatefulWidget {
  const PackageToolZero({super.key});

  @override
  State<PackageToolZero> createState() => _PackageToolZeroState();
}

class _PackageToolZeroState extends State<PackageToolZero> {
  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return MihSingleChildScroll(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "This is Package Tool Zero to test MIH Alerts",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
          ),
          const SizedBox(height: 20),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().successBasicAlert(
                "Success!",
                "This is the message for the success message",
                context,
              );
            },
            buttonColor: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            child: Text(
              "Basic Success Alert",
              style: TextStyle(
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().successAdvancedAlert(
                "Success!",
                "This is the advanced alert message",
                [
                  MihButton(
                    onPressed: () {
                      context.pop();
                    },
                    buttonColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    width: 300,
                    elevation: 10,
                    child: Text(
                      "Okay",
                      style: TextStyle(
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                context,
              );
            },
            buttonColor: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            child: Text(
              "Advanced Success Alert",
              style: TextStyle(
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().warningAlert(
                  "Warning Alert!", "This is a friendly warning mee", context);
            },
            buttonColor: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            child: Text(
              "Warning Alert",
              style: TextStyle(
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().errorBasicAlert(
                "Error!",
                "Thisis the basic error alert message",
                context,
              );
            },
            buttonColor: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
            child: Text(
              "Basic Error Alert",
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().errorAdvancedAlert(
                "Error!",
                "This is the advanced alert message",
                [
                  MihButton(
                    onPressed: () {
                      context.pop();
                    },
                    buttonColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    width: 300,
                    elevation: 10,
                    child: Text(
                      "Okay",
                      style: TextStyle(
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                context,
              );
            },
            buttonColor: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
            child: Text(
              "Advanced Error Alert",
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().deleteConfirmationAlert(
                "THis is a delete confirmation",
                () {
                  context.pop();
                },
                context,
              );
            },
            buttonColor: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
            child: Text(
              "Delete Confirmation Alert",
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().internetConnectionAlert(context);
            },
            buttonColor: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
            child: Text(
              "Internet Connection Alert",
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().locationPermissionAlert(context);
            },
            buttonColor: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
            child: Text(
              "Location Permission Alert",
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().inputErrorAlert(context);
            },
            buttonColor: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
            child: Text(
              "Input Error Alert",
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().passwordRequirementAlert(context);
            },
            buttonColor: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
            child: FittedBox(
              child: Text(
                "Password Requirement Alert",
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().passwordMatchAlert(context);
            },
            buttonColor: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
            child: Text(
              "Password Match Alert",
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().loginErrorAlert(context);
            },
            buttonColor: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
            child: Text(
              "Login Error Alert",
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().emailExistsAlert(context);
            },
            buttonColor: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
            child: Text(
              "Email Exists Alert",
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().invalidEmailAlert(context);
            },
            buttonColor: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode != "Dark"),
            child: Text(
              "Invalid Email Alert",
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
