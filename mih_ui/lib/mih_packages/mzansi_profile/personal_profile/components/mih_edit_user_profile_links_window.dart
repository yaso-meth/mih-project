import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/profile_link.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_profile_links.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_profile_links_service.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MihEditUserProfileLinksWindow extends StatefulWidget {
  final ProfileLink link;
  const MihEditUserProfileLinksWindow({
    super.key,
    required this.link,
  });

  @override
  State<MihEditUserProfileLinksWindow> createState() =>
      _MihEditUserProfileLinksWindowState();
}

class _MihEditUserProfileLinksWindowState
    extends State<MihEditUserProfileLinksWindow> {
  final _formKey = GlobalKey<FormState>();
  List<String> _dropdowOptions = MihProfileLinksServices().linkOptions;
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
  void initState() {
    super.initState();
    _dropdownLinkNameController.text = widget.link.site_name;
    _linkNameController.text = widget.link.custom_name;
    _destinationController.text = widget.link.destination;
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
          windowTitle: "Update Link",
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                Text(
                  "*NB: Internet connection required to edit profile links.",
                  style: TextStyle(
                    color: MihColors.red(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                MihForm(
                  formKey: _formKey,
                  formFields: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_dropdownLinkNameController.text != "")
                          MihProfileLinks(
                            displayCustomName: false,
                            links: [
                              ProfileLink(
                                idprofile_links: 0,
                                app_id: "",
                                business_id: "",
                                site_name: _dropdownLinkNameController.text,
                                custom_name: "",
                                destination: "",
                                order: 0,
                              ),
                            ],
                          ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: MihDropdownField(
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
                        ),
                      ],
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
                          try {
                            MihProfileLinksServices.loadingPopUp(context);
                            int statusCode =
                                await MihProfileLinksServices.updateProfileLink(
                              profileProvider,
                              widget.link.idprofile_links,
                              profileProvider.user!.app_id,
                              "",
                              _dropdownLinkNameController.text,
                              _linkNameController.text,
                              _destinationController.text,
                              widget.link.order,
                              context,
                            );
                            if (statusCode == 200) {
                              context.pop();
                              context.pop();
                              profileProvider.syncWithMihServerData();
                              successPopUp(
                                  "Profile Link Updated",
                                  "You have successfully update a link in your profile",
                                  0);
                            } else {
                              context.pop();
                              MihAlertServices()
                                  .internetConnectionAlert(context);
                            }
                          } catch (error) {
                            context.pop();
                            MihAlertServices().internetConnectionAlert(context);
                          }
                        } else {
                          MihAlertServices().inputErrorAlert(context);
                        }
                      },
                      buttonColor: MihColors.green(),
                      width: 300,
                      child: Text(
                        "Update",
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
