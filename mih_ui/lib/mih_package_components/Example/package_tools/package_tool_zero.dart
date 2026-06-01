import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
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
      backgroundColor: MihColors.primary(),
      borderOn: false,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return MihSingleChildScroll(
      scrollbarOn: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "This is Package Tool Zero to test MIH Alerts",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: MihColors.secondary(),
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
            buttonColor: MihColors.green(),
            child: Text(
              "Basic Success Alert",
              style: TextStyle(
                color: MihColors.primary(),
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
                    buttonColor: MihColors.primary(),
                    width: 300,
                    elevation: 10,
                    child: Text(
                      "Okay",
                      style: TextStyle(
                        color: MihColors.secondary(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  MihButton(
                    onPressed: () {
                      context.pop();
                    },
                    buttonColor: MihColors.secondary(),
                    width: 300,
                    elevation: 10,
                    child: Text(
                      "Dismiss",
                      style: TextStyle(
                        color: MihColors.primary(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                context,
              );
            },
            buttonColor: MihColors.green(),
            child: Text(
              "Advanced Success Alert",
              style: TextStyle(
                color: MihColors.primary(),
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
            buttonColor: MihColors.secondary(),
            child: Text(
              "Warning Alert",
              style: TextStyle(
                color: MihColors.primary(),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          MihButton(
            width: 300,
            onPressed: () {
              MihAlertServices().warningAdvancedAlert(
                "warning!",
                "This is the advanced alert message",
                [
                  MihButton(
                    onPressed: () {
                      context.pop();
                    },
                    buttonColor: MihColors.primary(),
                    width: 300,
                    elevation: 10,
                    child: Text(
                      "Okay",
                      style: TextStyle(
                        color: MihColors.secondary(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  MihButton(
                    onPressed: () {
                      context.pop();
                    },
                    buttonColor: MihColors.red(),
                    width: 300,
                    elevation: 10,
                    child: Text(
                      "Dismiss",
                      style: TextStyle(
                        color: MihColors.primary(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                context,
              );
            },
            buttonColor: MihColors.secondary(),
            child: Text(
              "Advanced Warning Alert",
              style: TextStyle(
                color: MihColors.primary(),
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
            buttonColor: MihColors.red(),
            child: Text(
              "Basic Error Alert",
              style: TextStyle(
                color: MihColors.secondary(),
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
                    buttonColor: MihColors.primary(),
                    width: 300,
                    elevation: 10,
                    child: Text(
                      "Okay",
                      style: TextStyle(
                        color: MihColors.secondary(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  MihButton(
                    onPressed: () {
                      context.pop();
                    },
                    buttonColor: MihColors.secondary(),
                    width: 300,
                    elevation: 10,
                    child: Text(
                      "Dismiss",
                      style: TextStyle(
                        color: MihColors.primary(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                context,
              );
            },
            buttonColor: MihColors.red(),
            child: Text(
              "Advanced Error Alert",
              style: TextStyle(
                color: MihColors.secondary(),
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
            buttonColor: MihColors.red(),
            child: Text(
              "Delete Confirmation Alert",
              style: TextStyle(
                color: MihColors.secondary(),
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
            buttonColor: MihColors.red(),
            child: Text(
              "Internet Connection Alert",
              style: TextStyle(
                color: MihColors.secondary(),
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
            buttonColor: MihColors.red(),
            child: Text(
              "Location Permission Alert",
              style: TextStyle(
                color: MihColors.secondary(),
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
            buttonColor: MihColors.red(),
            child: Text(
              "Input Error Alert",
              style: TextStyle(
                color: MihColors.secondary(),
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
            buttonColor: MihColors.red(),
            child: FittedBox(
              child: Text(
                "Password Requirement Alert",
                style: TextStyle(
                  color: MihColors.secondary(),
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
            buttonColor: MihColors.red(),
            child: Text(
              "Password Match Alert",
              style: TextStyle(
                color: MihColors.secondary(),
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
            buttonColor: MihColors.red(),
            child: Text(
              "Login Error Alert",
              style: TextStyle(
                color: MihColors.secondary(),
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
            buttonColor: MihColors.red(),
            child: Text(
              "Email Exists Alert",
              style: TextStyle(
                color: MihColors.secondary(),
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
            buttonColor: MihColors.red(),
            child: Text(
              "Invalid Email Alert",
              style: TextStyle(
                color: MihColors.secondary(),
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
