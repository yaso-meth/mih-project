import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
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
  final void Function()? onSuccessDismissPressed;
  // final String? startUpSearch;
  const MihDeleteBookmarkAlert({
    super.key,
    required this.business,
    required this.bookmarkBusiness,
    required this.onSuccessDismissPressed,
    // required this.startUpSearch,
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
      context.pop();
      if (statusCode == 200) {
        successPopUp(
          "Successfully Removed Bookmark!",
          "${widget.business.Name} has successfully been removed your favourite businessess in the Mzansi Directory.",
        );
      } else {
        MihAlertServices().errorAlert(
          "Error Adding Bookmark",
          "An error occured while add ${widget.business.Name} to you Mzansi Directory, Please try again later.",
          context,
        );
      }
    });
  }

  void successPopUp(String title, String message) {
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
              Center(
                child: MihButton(
                  onPressed: () {
                    // context.goNamed(
                    //   "mzansiDirectory",
                    //   extra: MzansiDirectoryArguments(
                    //     personalSearch: false,
                    //     startSearchText: widget.business.Name,
                    //     packageIndex: 1,
                    //   ),
                    // );
                    widget.onSuccessDismissPressed!.call();
                    context.pop();
                    context.pop();
                  },
                  buttonColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  elevation: 10,
                  width: 300,
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
              )
            ],
          ),
          alertColour: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
        // return MIHSuccessMessage(
        //   successType: "Success",
        //   successMessage: message,
        // );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageAlert(
      alertColour: MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      alertIcon: Icon(
        Icons.warning_rounded,
        size: 100,
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      ),
      alertTitle: "Remove Bookmark",
      alertBody: Column(
        children: [
          Text(
            "Are you sure you want to remove ${widget.business.Name} from your Mzansi Directory?",
            style: TextStyle(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                buttonColor: MihColors.getGreenColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
              MihButton(
                width: 300,
                onPressed: () {
                  // todo: remove bookmark
                  deleteBookmark(
                      widget.bookmarkBusiness!.idbookmarked_businesses);
                },
                buttonColor: MihColors.getRedColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                child: Text(
                  "Remove Business",
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
        ],
      ),
    );
  }
}
