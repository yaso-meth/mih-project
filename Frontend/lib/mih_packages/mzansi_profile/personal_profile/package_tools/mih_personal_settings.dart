import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MihPersonalSettings extends StatefulWidget {
  const MihPersonalSettings({
    super.key,
  });

  @override
  State<MihPersonalSettings> createState() => _MihPersonalSettingsState();
}

class _MihPersonalSettingsState extends State<MihPersonalSettings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        return MihPackageToolBody(
          borderOn: false,
          innerHorizontalPadding: 10,
          bodyItem: getBody(mzansiProfileProvider),
        );
      },
    );
  }

  void deleteAccountPopUp(
      MzansiProfileProvider mzansiProfileProvider, BuildContext ctxtd) {
    MihAlertServices().errorAdvancedAlert(
      "Are you sure you want to permanently delete your MIH account?",
      "This action will remove all of your data, and it cannot be recovered. We understand this is a big decision, so please take a moment to double-check.\n\nIf you're certain, please confirm below. If you've changed your mind, you can simply close this window.",
      [
        MihButton(
          onPressed: () {
            MihUserServices.deleteAccount(mzansiProfileProvider, context);
          },
          buttonColor: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          width: 300,
          child: Text(
            "Delete",
            style: TextStyle(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        MihButton(
          onPressed: () {
            Navigator.pop(context);
          },
          buttonColor: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          width: 300,
          child: Text(
            "Cancel",
            style: TextStyle(
              color: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      ctxtd,
    );
  }

  Widget getBody(MzansiProfileProvider mzansiProfileProvider) {
    return MihSingleChildScroll(
      child: Column(
        children: [
          Center(
            child: FaIcon(
              FontAwesomeIcons.trashCan,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
          ),
          const SizedBox(height: 10.0),
          MihButton(
            onPressed: () {
              deleteAccountPopUp(mzansiProfileProvider, context);
            },
            buttonColor: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            width: 300,
            child: Text(
              "Delete Account",
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
  }
}
