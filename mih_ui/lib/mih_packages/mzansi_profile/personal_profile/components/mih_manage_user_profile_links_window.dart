import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/personal_profile/components/mih_edit_user_profile_links_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_profile_links_service.dart';
import 'package:provider/provider.dart';

class MihManageUserProfileLinksWindow extends StatefulWidget {
  const MihManageUserProfileLinksWindow({super.key});

  @override
  State<MihManageUserProfileLinksWindow> createState() =>
      _MihManageUserProfileLinksWindowState();
}

class _MihManageUserProfileLinksWindowState
    extends State<MihManageUserProfileLinksWindow> {
  void successPopUp(String title, String message, int packageIndex) {
    MihAlertServices().successBasicAlert(
      title,
      message,
      context,
    );
  }

  void removeLinkWarning(
      MzansiProfileProvider profileProvider, int idprofile_links) {
    MihAlertServices().warningAdvancedAlert(
      "Remove Link?",
      "Are you sure you want to remove this link from your profile?",
      [
        MihButton(
          onPressed: () async {
            MihProfileLinksServices.loadingPopUp(context);
            int statusCode = await MihProfileLinksServices.deleteProfileLink(
              profileProvider,
              idprofile_links,
            );
            context.pop();
            context.pop();
            if (statusCode == 200) {
              successPopUp("profile Link Deleted",
                  "you have successfully deleted a link to your profile", 0);
            } else {
              MihAlertServices().internetConnectionAlert(context);
            }
          },
          buttonColor: MihColors.red(),
          width: 300,
          child: Text(
            "Remove",
            style: TextStyle(
              color: MihColors.primary(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        MihButton(
          onPressed: () async {
            context.pop();
          },
          buttonColor: MihColors.green(),
          width: 300,
          child: Text(
            "Cancel",
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
  }

  void editLinkWindow(ProfileLink link) {
    showDialog(
        context: context,
        builder: (context) => MihEditUserProfileLinksWindow(link: link));
  }

  Widget linkActions(MzansiProfileProvider profileProvider, ProfileLink link) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          color: MihColors.green(),
          onPressed: () {
            editLinkWindow(link);
          },
          icon: Icon(
            Icons.edit,
          ),
        ),
        const SizedBox(width: 2),
        IconButton(
          color: MihColors.red(),
          onPressed: () {
            removeLinkWarning(profileProvider, link.idprofile_links);
          },
          icon: Icon(
            Icons.delete,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<MzansiProfileProvider>(
      builder: (
        BuildContext context,
        MzansiProfileProvider profileProvider,
        Widget? child,
      ) {
        // return Placeholder();
        return MihPackageWindow(
          fullscreen: true,
          windowTitle: "Manage Links",
          onWindowTapClose: () {
            Navigator.pop(context);
          },
          windowBody: Column(
            children: [
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: IconThemeData(
                      color: MihColors.grey(),
                    ),
                  ),
                  child: ReorderableListView.builder(
                      itemBuilder: (context, index) {
                        ProfileLink link = profileProvider.personalLinks[index];
                        String display = link.site_name;
                        if (link.custom_name.isNotEmpty) {
                          display += " (${link.custom_name})";
                        }
                        return ListTile(
                          key: ValueKey("$index"),
                          title: Text(
                            "$display",
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          leading: linkActions(
                            profileProvider,
                            link,
                          ),
                        );
                      },
                      itemCount: profileProvider.personalLinks.length,
                      onReorder: (oldIndex, newIndex) {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final ProfileLink link =
                            profileProvider.personalLinks.removeAt(oldIndex);
                        profileProvider.personalLinks.insert(newIndex, link);
                      }),
                ),
              ),
              MihButton(
                onPressed: () async {
                  MihProfileLinksServices.loadingPopUp(context);
                  int newIndex = 1;
                  for (var link in profileProvider.personalLinks) {
                    int statusCode =
                        await MihProfileLinksServices.updateProfileLink(
                            profileProvider,
                            link.idprofile_links,
                            link.app_id,
                            link.business_id,
                            link.site_name,
                            link.custom_name,
                            link.destination,
                            newIndex,
                            context);
                    if (statusCode != 200) {
                      await MihProfileLinksServices.updateProfileLink(
                          profileProvider,
                          link.idprofile_links,
                          link.app_id,
                          link.business_id,
                          link.site_name,
                          link.custom_name,
                          link.destination,
                          newIndex,
                          context);
                    }
                    newIndex++;
                  }
                  context.pop();
                  context.pop();
                  successPopUp("profile Link Reordered",
                      "you have successfully reordered your profile links", 0);
                },
                buttonColor: MihColors.green(),
                width: 300,
                child: Text(
                  "Update Order",
                  style: TextStyle(
                    color: MihColors.primary(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
