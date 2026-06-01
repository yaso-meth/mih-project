import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_profile_links_service.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MihAddUserProfileLinksWindow extends StatefulWidget {
  const MihAddUserProfileLinksWindow({super.key});

  @override
  State<MihAddUserProfileLinksWindow> createState() =>
      _MihAddUserProfileLinksWindowState();
}

class _MihAddUserProfileLinksWindowState
    extends State<MihAddUserProfileLinksWindow> {
  final _formKey = GlobalKey<FormState>();
  List<String> _dropdowOptions = [
    "YouTube",
    "TikTok",
    "Twitch",
    "Threads",
    "WhatsApp",
    "Instagram",
    "X",
    "LinkedIn",
    "Facebook",
    "Reddit",
    "Discord",
    "Git",
    "Telegram",
    "Pinterest",
    "Snapchat",
    "Messenger",
    "Medium",
    "Substack",
    "Spotify",
    "YT Music",
    "Apple Music",
    "Patreon",
    "Loolio",
    "WeChat",
    "Other"
  ];
  TextEditingController _dropdownLinkNameController = TextEditingController();
  TextEditingController _linkNameController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

  void successPopUp(String title, String message, int packageIndex) {
    MihAlertServices().successBasicAlert(
      title,
      message,
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    _dropdowOptions.sort();
    bool isOtherSelected = _dropdownLinkNameController.text == "Other";
    return Consumer<MzansiProfileProvider>(
      builder: (
        BuildContext context,
        MzansiProfileProvider profileProvider,
        Widget? child,
      ) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Add Link",
          onWindowTapClose: () {
            _dropdownLinkNameController.clear();
            _destinationController.clear();
            _linkNameController.clear();
            Navigator.pop(context);
          },
          windowBody: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: screenWidth * 0.05)
                    : EdgeInsets.symmetric(horizontal: screenWidth * 0),
            child: Column(
              children: [
                MihForm(
                  formKey: _formKey,
                  formFields: [
                    MihDropdownField(
                      controller: _dropdownLinkNameController,
                      hintText: 'Site Name',
                      dropdownOptions: _dropdowOptions,
                      requiredText: true,
                      editable: true,
                      enableSearch: true,
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                      onSelected: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    MihTextFormField(
                      fillColor: MihColors.secondary(),
                      inputColor: MihColors.primary(),
                      controller: _linkNameController,
                      hintText: "Custom Name",
                      requiredText: isOtherSelected,
                      validator: (value) {
                        if (isOtherSelected) {
                          return MihValidationServices().isEmpty(value);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    MihTextFormField(
                      fillColor: MihColors.secondary(),
                      inputColor: MihColors.primary(),
                      controller: _destinationController,
                      hintText: "Link",
                      requiredText: true,
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    MihButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          MihProfileLinksServices.loadingPopUp(context);
                          int statusCode =
                              await MihProfileLinksServices.addProfileLink(
                            profileProvider,
                            profileProvider.user!.app_id,
                            "",
                            _dropdownLinkNameController.text,
                            _linkNameController.text,
                            _destinationController.text,
                            profileProvider.personalLinks.length + 1,
                          );
                          KenLogger.success("Status COde: $statusCode");
                          context.pop();
                          if (statusCode == 201) {
                            await MihProfileLinksServices.getUserProfileLinks(
                              profileProvider,
                              profileProvider.user!.app_id,
                            );
                            context.pop();
                            successPopUp(
                                "Profile Link Added",
                                "You have successfully added a new link to your profile",
                                0);
                          } else {
                            MihAlertServices().internetConnectionAlert(context);
                          }
                        } else {
                          MihAlertServices().inputErrorAlert(context);
                        }
                      },
                      buttonColor: MihColors.green(),
                      width: 300,
                      child: Text(
                        "Add",
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
          ),
        );
      },
    );
  }
}
