import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/bookmarked_business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';

class MihDeleteBookmarkAlert extends StatefulWidget {
  final Business business;
  final BookmarkedBusiness? bookmarkBusiness;
  final String? startUpSearch;
  const MihDeleteBookmarkAlert({
    super.key,
    required this.business,
    required this.bookmarkBusiness,
    required this.startUpSearch,
  });

  @override
  State<MihDeleteBookmarkAlert> createState() => _MihDeleteBookmarkAlertState();
}

class _MihDeleteBookmarkAlertState extends State<MihDeleteBookmarkAlert> {
  Future<void> deleteBookmark(int idbookmarked_businesses) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    await MihMzansiDirectoryServices()
        .deleteBookmarkedBusiness(idbookmarked_businesses)
        .then((statusCode) {
      if (statusCode == 200) {
        // Navigator.of(context).pop(); //Remove loading circle
        // Navigator.of(context).pop(); //Remove window
        // Navigator.of(context).pop(); //Remove profile
        // Navigator.of(context).pop(); //Remove directory
        // Navigator.of(context).pushNamed(
        //   '/mzansi-directory',
        //   arguments: MzansiDirectoryArguments(
        //     startUpSearch: widget.startUpSearch, // startUpSearch
        //     personalSearch: false, // personalSearch
        //   ),
        // );
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/mzansi-directory',
          ModalRoute.withName('/'),
          arguments: MzansiDirectoryArguments(
            personalSearch: false, // personalSearch
            packageIndex: 1,
          ),
        );
        MihAlertServices().successAlert(
          "Successfully Removed Bookmark!",
          "${widget.business.Name} has successfully been removed your favourite businessess in the Mzansi Directory.",
          context,
        );
      } else {
        //error messagek
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
      alertTitle: "Remove Bookmark",
      alertBody: Column(
        children: [
          Text(
            "Are you sure you want to remove ${widget.business.Name} from your Mzansi Directory?",
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
                buttonColor:
                    MzansiInnovationHub.of(context)!.theme.successColor(),
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
                  // todo: remove bookmark
                  deleteBookmark(
                      widget.bookmarkBusiness!.idbookmarked_businesses);
                },
                buttonColor:
                    MzansiInnovationHub.of(context)!.theme.errorColor(),
                child: Text(
                  "Remove Business",
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
