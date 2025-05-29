import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_user_apis.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
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
            color: MzanziInnovationHub.of(context)!.theme.errorColor(),
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
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
                      MihUserApis.deleteAccount(
                          widget.signedInUser.app_id, context);
                    },
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.errorColor(),
                    width: 300,
                    child: Text(
                      "Delete",
                      style: TextStyle(
                        color: MzanziInnovationHub.of(context)!
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
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.errorColor(),
                    width: 300,
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: MzanziInnovationHub.of(context)!
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
          alertColour: MzanziInnovationHub.of(context)!.theme.errorColor(),
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
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              size: 150,
            ),
          ),
          const SizedBox(height: 10.0),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "Would you like to delete your MIH account?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
              MihButton(
                onPressed: () {
                  deleteAccountPopUp(context);
                },
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.errorColor(),
                width: 300,
                child: Text(
                  "Delete Account",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
