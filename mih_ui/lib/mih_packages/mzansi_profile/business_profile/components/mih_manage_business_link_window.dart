import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_profile_links.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_edit_business_link_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_profile_links_service.dart';
import 'package:provider/provider.dart';

class MihManageBusinessLinkWindow extends StatefulWidget {
  const MihManageBusinessLinkWindow({super.key});

  @override
  State<MihManageBusinessLinkWindow> createState() =>
      _MihManageBusinessLinkWindowState();
}

class _MihManageBusinessLinkWindowState
    extends State<MihManageBusinessLinkWindow> {
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
      "Are you sure you want to remove this link from your business?",
      [
        MihButton(
          onPressed: () async {
            try {
              MihProfileLinksServices.loadingPopUp(context);
              int statusCode = await MihProfileLinksServices.deleteProfileLink(
                profileProvider,
                idprofile_links,
              );
              if (statusCode == 200) {
                context.pop();
                context.pop();
                successPopUp("profile Link Deleted",
                    "you have successfully deleted a link to your business", 0);
              } else {
                context.pop();
                MihAlertServices().internetConnectionAlert(context);
              }
            } catch (error) {
              context.pop();
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
      builder: (context) => MihEditBusnessLinkWindow(link: link),
    );
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
    double screenWidth = MediaQuery.of(context).size.width;
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
              const SizedBox(height: 10.0),
              Padding(
                padding: MzansiInnovationHub.of(context)!.theme.screenType ==
                        "desktop"
                    ? EdgeInsets.symmetric(horizontal: screenWidth * 0.05)
                    : EdgeInsets.symmetric(horizontal: screenWidth * 0),
                child: Row(
                  children: [
                    Text(
                      "*NB: Internet connection required to manage profile links.",
                      style: TextStyle(
                        color: MihColors.red(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5.0),
              Expanded(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: IconThemeData(
                      color: MihColors.grey(),
                    ),
                  ),
                  child: ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      itemBuilder: (context, index) {
                        ProfileLink link = profileProvider.businessLinks[index];
                        String display = link.site_name;
                        if (link.custom_name.isNotEmpty) {
                          display += " (${link.custom_name})";
                        }
                        return ListTile(
                          key: ValueKey("$index"),
                          title: Row(
                            children: [
                              MihProfileLinks(
                                displayCustomName: false,
                                buttonSize: 50,
                                links: [link],
                              ),
                              SizedBox(width: 8),
                              Text(
                                display,
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          leading: linkActions(
                            profileProvider,
                            link,
                          ),
                          trailing: ReorderableDragStartListener(
                            index: index,
                            child: Icon(
                              Icons.drag_indicator,
                              color: MihColors.secondary(),
                            ),
                          ),
                        );
                      },
                      itemCount: profileProvider.businessLinks.length,
                      onReorderItem: (oldIndex, newIndex) {
                        profileProvider.reorderBusinessLinks(
                            oldIndex: oldIndex, newIndex: newIndex);
                      }),
                ),
              ),
              MihButton(
                onPressed: () async {
                  MihProfileLinksServices.loadingPopUp(context);
                  try {
                    int newIndex = 1;
                    bool hasError = false;
                    for (var link in profileProvider.businessLinks) {
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
                        hasError = true;
                        break;
                      }
                      newIndex++;
                    }
                    if (hasError) {
                      MihAlertServices().internetConnectionAlert(context);
                    } else {
                      context.pop();
                      context.pop();
                      profileProvider.syncWithMihServerData();
                      successPopUp(
                          "profile Link Reordered",
                          "you have successfully reordered your profile links",
                          0);
                    }
                  } catch (error) {
                    context.pop();
                    MihAlertServices().internetConnectionAlert(context);
                  }
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
