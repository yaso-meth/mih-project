import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MihPersonalSettings extends StatefulWidget {
  final AppUser signedInUser;
  const MihPersonalSettings({
    super.key,
    required this.signedInUser,
  });

  @override
  State<MihPersonalSettings> createState() => _MihPersonalSettingsState();
}

class _MihPersonalSettingsState extends State<MihPersonalSettings> {
  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(),
    );
  }

  void deleteAccountPopUp(BuildContext ctxtd) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.warning_amber_rounded,
            size: 100,
            color: MihColors.getRedColor(context),
          ),
          alertTitle:
              "Are you sure you want to permanently delete your MIH account?",
          alertBody: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "This action will remove all of your data, and it cannot be recovered. We understand this is a big decision, so please take a moment to double-check.\n\nIf you're certain, please confirm below. If you've changed your mind, you can simply close this window.",
                style: TextStyle(
                  color:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  MihButton(
                    onPressed: () {
                      MihUserServices.deleteAccount(
                          widget.signedInUser.app_id, context);
                    },
                    buttonColor: MihColors.getRedColor(context),
                    width: 300,
                    child: Text(
                      "Delete",
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
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    buttonColor: MihColors.getGreenColor(context),
                    width: 300,
                    child: Text(
                      "Cancel",
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
              )
            ],
          ),
          alertColour: MihColors.getRedColor(context),
        );
      },
    );
  }

  Widget getBody() {
    return MihSingleChildScroll(
      child: Column(
        children: [
          Center(
            child: FaIcon(
              FontAwesomeIcons.trashCan,
              color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
              size: 150,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            "Would you like to delete your MIH account?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          const SizedBox(height: 10.0),
          MihButton(
            onPressed: () {
              deleteAccountPopUp(context);
            },
            buttonColor: MihColors.getRedColor(context),
            width: 300,
            child: Text(
              "Delete Account",
              style: TextStyle(
                color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
