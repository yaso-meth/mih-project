import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/bookmarked_business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';
import 'package:provider/provider.dart';

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
  Future<void> getFavouriteBusinesses() async {
    MzansiDirectoryProvider directoryProvider =
        context.read<MzansiDirectoryProvider>();
    MzansiProfileProvider profileProvider =
        context.read<MzansiProfileProvider>();
    await MihMzansiDirectoryServices().getAllUserBookmarkedBusiness(
      profileProvider.user!.app_id,
      directoryProvider,
    );
    List<Business> favBus = [];
    for (var bus in directoryProvider.bookmarkedBusinesses) {
      await MihBusinessDetailsServices()
          .getBusinessDetailsByBusinessId(bus.business_id)
          .then((business) async {
        favBus.add(business!);
      });
    }
    directoryProvider.setFavouriteBusinesses(
      businesses: favBus,
    );
  }

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
        MihAlertServices().errorBasicAlert(
          "Error Adding Bookmark",
          "An error occured while add ${widget.business.Name} to you Mzansi Directory, Please try again later.",
          context,
        );
      }
    });
  }

  void successPopUp(String title, String message) {
    MihAlertServices().successAdvancedAlert(
      title,
      message,
      [
        MihButton(
          onPressed: () async {
            await getFavouriteBusinesses();
            widget.onSuccessDismissPressed!.call();
            context.pop();
            context.pop();
          },
          buttonColor: MihColors.primary(),
          elevation: 10,
          width: 300,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: MihColors.secondary(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: null,
      onWindowTapClose: null,
      backgroundColor: MihColors.secondary(),
      windowBody: Column(
        children: [
          Icon(
            Icons.warning_rounded,
            size: 150,
            color: MihColors.primary(),
          ),
          Text(
            "Remove Bookmark",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MihColors.primary(),
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "Are you sure you want to remove ${widget.business.Name} from your Mzansi Directory?",
            style: TextStyle(
              color: MihColors.primary(),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 25),
          Wrap(
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              MihButton(
                width: 300,
                onPressed: () async {
                  Navigator.of(context).pop();
                },
                buttonColor: MihColors.green(),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: MihColors.primary(),
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
                buttonColor: MihColors.red(),
                child: Text(
                  "Remove Business",
                  style: TextStyle(
                    color: MihColors.primary(),
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
