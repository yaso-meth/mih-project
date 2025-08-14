import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';
import 'package:supertokens_flutter/supertokens.dart';

class MihAddBookmarkAlert extends StatefulWidget {
  final Business business;
  const MihAddBookmarkAlert({
    super.key,
    required this.business,
  });

  @override
  State<MihAddBookmarkAlert> createState() => _MihAddBookmarkAlertState();
}

class _MihAddBookmarkAlertState extends State<MihAddBookmarkAlert> {
  Future<void> addBookmark(String business_id) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    String user_id = await SuperTokens.getUserId();
    await MihMzansiDirectoryServices()
        .addBookmarkedBusiness(user_id, business_id)
        .then((statusCode) {
      if (statusCode == 201) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/mzansi-directory',
          ModalRoute.withName('/'),
          arguments: MzansiDirectoryArguments(
            personalSearch: false, // personalSearch
            packageIndex: 1,
            startSearchText: widget.business.Name,
          ),
        );
        MihAlertServices().successAlert(
          "Successfully Bookmarked Business!",
          "${widget.business.Name} has successfully been added to favourite businessess in the Mzansi Directory.",
          context,
        );
      } else {
        Navigator.of(context).pop();
        MihAlertServices().errorAlert(
          "Error Adding Bookmark",
          "An error occured while add ${widget.business.Name} to you Mzansi Directory, Please try again later.",
          context,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageAlert(
      alertColour: MihColors.getSecondaryColor(context),
      alertIcon: Icon(
        Icons.warning_rounded,
        size: 100,
        color: MihColors.getSecondaryColor(context),
      ),
      alertTitle: "Bookmark Business",
      alertBody: Column(
        children: [
          Text(
            "Are you sure you want to save ${widget.business.Name} to your Mzansi Directory?",
            style: TextStyle(
              color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 25),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              MihButton(
                width: 300,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                buttonColor: MihColors.getRedColor(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              MihButton(
                width: 300,
                onPressed: () {
                  addBookmark(widget.business.business_id);
                },
                buttonColor: MihColors.getGreenColor(context),
                child: Text(
                  "Bookmark Business",
                  style: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
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
