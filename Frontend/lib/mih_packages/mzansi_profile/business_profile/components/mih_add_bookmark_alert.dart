import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_directory_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_directory_services.dart';
import 'package:provider/provider.dart';

class MihAddBookmarkAlert extends StatefulWidget {
  final Business business;
  final void Function()? onSuccessDismissPressed;
  const MihAddBookmarkAlert({
    super.key,
    required this.business,
    required this.onSuccessDismissPressed,
  });

  @override
  State<MihAddBookmarkAlert> createState() => _MihAddBookmarkAlertState();
}

class _MihAddBookmarkAlertState extends State<MihAddBookmarkAlert> {
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
          .then((business) {
        favBus.add(business!);
      });
    }
    directoryProvider.setFavouriteBusinesses(businesses: favBus);
  }

  Future<void> addBookmark(
      MzansiProfileProvider profileProvider, String business_id) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    await MihMzansiDirectoryServices()
        .addBookmarkedBusiness(profileProvider.user!.app_id, business_id)
        .then((statusCode) {
      context.pop();
      if (statusCode == 201) {
        successPopUp(
          "Successfully Bookmarked Business!",
          "${widget.business.Name} has successfully been added to favourite businessess in the Mzansi Directory.",
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
          buttonColor: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          elevation: 10,
          width: 300,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          Widget? child) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          windowBody: Column(
            children: [
              Icon(
                Icons.warning_rounded,
                size: 150,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              Text(
                "Bookmark Business",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Are you sure you want to save ${widget.business.Name} to your Mzansi Directory?",
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 18,
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
                    buttonColor: MihColors.getRedColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  MihButton(
                    width: 300,
                    onPressed: () {
                      addBookmark(profileProvider, widget.business.business_id);
                    },
                    buttonColor: MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    child: Text(
                      "Bookmark Business",
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
              ),
            ],
          ),
        );
      },
    );
  }
}
