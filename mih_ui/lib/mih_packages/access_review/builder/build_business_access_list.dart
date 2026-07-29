import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_access_controlls_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_access_controls_services.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:provider/provider.dart';

class BuildBusinessAccessList extends StatefulWidget {
  final String filterText;
  final void Function()? onSuccessUpate;

  const BuildBusinessAccessList({
    super.key,
    required this.filterText,
    required this.onSuccessUpate,
  });

  @override
  State<BuildBusinessAccessList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildBusinessAccessList> {
  String baseAPI = AppEnviroment.baseApiUrl;
  late double popUpWidth;
  late double? popUpheight;
  late double popUpButtonWidth;
  late double popUpTitleSize;
  late double popUpSubtitleSize;
  late double popUpBodySize;
  late double popUpIconSize;
  late double popUpPaddingSize;
  late double width;
  late double height;

  Widget displayQueue(
      MzansiProfileProvider mzansiProfileProvider,
      MihAccessControllsProvider accessProvider,
      int index,
      List<PatientAccess> filteredList) {
    String line1 = filteredList[index].requested_by;
    String line2 = "";
    line2 +=
        "Request Date: ${filteredList[index].requested_on.substring(0, 16).replaceAll("T", " ")}\n";
    line2 += "Profile Type: ${filteredList[index].type.toUpperCase()}\n";
    String line3 = "Status: ";
    String access = filteredList[index].status.toUpperCase();
    TextSpan accessWithColour;
    if (access == "APPROVED") {
      accessWithColour = TextSpan(
        text: "$access\n",
        style: TextStyle(
          color: MihColors.green(darkMode: false),
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (access == "PENDING") {
      accessWithColour = TextSpan(
        text: "$access\n",
        style: TextStyle(
          color: MihColors.grey(darkMode: false),
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      accessWithColour = TextSpan(
        text: "$access\n",
        style: TextStyle(
          color: MihColors.red(darkMode: false),
          fontWeight: FontWeight.bold,
        ),
      );
    }
    Future<Business?> business = MihBusinessDetailsServices()
        .getBusinessDetailsByBusinessId(filteredList[index].business_id);
    return Material(
      color: MihColors.secondary(),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        splashColor: Color.lerp(
          MihColors.bluishPurple(),
          Colors.black,
          0.01,
        ),
        hoverColor: MihColors.highlight(),
        leading: FutureBuilder<Business?>(
          future: business,
          builder: (context, snapshot) {
            ImageProvider? image;
            if (snapshot.connectionState == ConnectionState.waiting) {
              image = null;
            }

            if (snapshot.hasData) {
              String? userPicUrl =
                  MihFileApi.getMinioFileUrlV2(snapshot.data!.logo_path);
              image = CachedNetworkImageProvider(userPicUrl);
            }

            if (snapshot.hasError) {
              image = null;
            }

            return MihCircleAvatar(
              imageFile: image,
              width: 50,
              expandable: true,
              editable: false,
              fileNameController: null,
              userSelectedfile: null,
              frameColor: MihColors.primary(),
              backgroundColor: MihColors.secondary(),
              onChange: null,
            );
          },
        ),
        title: Text(
          line1,
          style: TextStyle(
            color: MihColors.primary(),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: RichText(
          text: TextSpan(
              text: line2,
              style: TextStyle(
                color: MihColors.primary(),
                // fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(text: line3),
                accessWithColour,
              ]),
        ),
        onTap: () {
          viewApprovalPopUp(mzansiProfileProvider, accessProvider, index);
        },
      ),
    );
  }

  void checkScreenSize() {
    if (MzansiInnovationHub.of(context)!.theme.screenType == "desktop") {
      setState(() {
        popUpWidth = (width / 4) * 2;
        popUpheight = null;
        popUpButtonWidth = 300;
        popUpTitleSize = 25.0;
        popUpSubtitleSize = 20.0;
        popUpBodySize = 15;
        popUpPaddingSize = 25.0;
        popUpIconSize = 100;
      });
    } else {
      setState(() {
        popUpWidth = width - (width * 0.1);
        popUpheight = null;
        popUpButtonWidth = 300;
        popUpTitleSize = 20.0;
        popUpSubtitleSize = 18.0;
        popUpBodySize = 15;
        popUpPaddingSize = 15.0;
        popUpIconSize = 100;
      });
    }
  }

  void viewApprovalPopUp(MzansiProfileProvider mzansiProfileProvider,
      MihAccessControllsProvider accessProvider, int index) {
    String subtitle =
        "Business Name: ${accessProvider.accessList![index].requested_by}\n";
    subtitle +=
        "Requested Date: ${accessProvider.accessList![index].requested_on.substring(0, 16).replaceAll("T", " ")}\n";

    subtitle +=
        "Profile Type: ${accessProvider.accessList![index].type.toUpperCase()}\n";
    subtitle +=
        "Status: ${accessProvider.accessList![index].status.toUpperCase()}";
    if (accessProvider.accessList![index].status == 'pending') {
    } else {
      subtitle +=
          "\nActioned By: ${accessProvider.accessList![index].approved_by}\n";
      subtitle +=
          "Actioned On: ${accessProvider.accessList![index].approved_on.substring(0, 16).replaceAll("T", " ")}";
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
          fullscreen: false,
          windowTitle: "Profile Access",
          windowBody: Column(
            children: [
              const SizedBox(height: 10.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "*NB: Internet connection required to approve or decline access.",
                  style: TextStyle(
                    color: MihColors.red(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 5.0),
              SizedBox(
                width: 1000,
                child: Text(
                  subtitle,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: MihColors.secondary(),
                    fontSize: popUpBodySize,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Visibility(
                visible: accessProvider.accessList![index].status == 'pending',
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Important Notice: Approving Profile Access",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MihColors.red(),
                      ),
                    ),
                    Text(
                      "You are about to accept access to your patient's profile. Please be aware of the following important points:",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: MihColors.red(),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "1. Permanent Access: Once you accepts this access request, it will become permanent.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MihColors.red(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "2. Shared Information: Any updates make to youe patient profile will be visible to all who have access to the profile.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MihColors.red(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "3. Irreversible Access: Once granted, you cannot revoke access to your patient's profile.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MihColors.red(),
                        ),
                      ),
                    ),
                    Text(
                      "By pressing the \"Approve\" button you accept the above terms.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MihColors.red(),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: accessProvider.accessList![index].status == 'approved',
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Important Notice: Approved Profile Access",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MihColors.red(),
                      ),
                    ),
                    Text(
                      "You have accepted access to your patient's profile. Please be aware of the following important points:",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: MihColors.red(),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "1. Permanent Access: This access is permanent.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MihColors.red(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "2. Shared Information: Any updates make to youe patient profile will be visible to all who have access to the profile.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MihColors.red(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "3. Irreversible Access: You cannot revoke this access to your patient's profile.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MihColors.red(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: accessProvider.accessList![index].status == 'pending',
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    MihButton(
                      onPressed: () async {
                        try {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const Mihloadingcircle();
                            },
                          );
                          int statusCode = await MihAccessControlsServices()
                              .updatePatientAccessAPICall(
                            accessProvider.accessList![index].business_id,
                            accessProvider.accessList![index].requested_by,
                            accessProvider.accessList![index].app_id,
                            "declined",
                            "${mzansiProfileProvider.user!.fname} ${mzansiProfileProvider.user!.lname}",
                            mzansiProfileProvider.user!,
                            context,
                          );
                          if (statusCode == 200) {
                            await MihAccessControlsServices()
                                .getBusinessAccessListOfPatient(
                              mzansiProfileProvider.user!.app_id,
                              accessProvider,
                            );
                            context.pop();
                            successPopUp("Successfully Actioned Request",
                                "You have successfully Declined access request");
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
                        "Decline",
                        style: TextStyle(
                          color: MihColors.primary(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MihButton(
                      onPressed: () async {
                        try {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const Mihloadingcircle();
                            },
                          );
                          int statusCode = await MihAccessControlsServices()
                              .updatePatientAccessAPICall(
                            accessProvider.accessList![index].business_id,
                            accessProvider.accessList![index].requested_by,
                            accessProvider.accessList![index].app_id,
                            "approved",
                            "${mzansiProfileProvider.user!.fname} ${mzansiProfileProvider.user!.lname}",
                            mzansiProfileProvider.user!,
                            context,
                          );
                          if (statusCode == 200) {
                            await accessProvider
                                .syncWithMihServerData(mzansiProfileProvider);
                            context.pop();
                            successPopUp("Successfully Actioned Request",
                                "You have successfully Accepted access request");
                          } else {
                            context.pop();
                            MihAlertServices().internetConnectionAlert(context);
                          }
                        } catch (error) {
                          context.pop();
                          MihAlertServices().internetConnectionAlert(context);
                        }
                      },
                      buttonColor: MihColors.green(),
                      width: 300,
                      child: Text(
                        "Approve",
                        style: TextStyle(
                          color: MihColors.primary(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
          onWindowTapClose: () {
            Navigator.pop(context);
          }),
    );
  }

  void successPopUp(String title, String message) {
    MihAlertServices().successAdvancedAlert(
      title,
      message,
      [
        MihButton(
          onPressed: () {
            context.pop();
            KenLogger.warning("dismissing pop up and refreshing list");
            if (widget.onSuccessUpate != null) {
              widget.onSuccessUpate!();
            }
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
        ),
      ],
      context,
    );
  }

  List<PatientAccess> filterAccessList(List<PatientAccess> accessList) {
    if (widget.filterText == "All") {
      return accessList;
    }
    return accessList
        .where((item) =>
            item.status.toLowerCase() == widget.filterText.toLowerCase())
        .toList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setState(() {
      width = size.width;
      height = size.height;
    });
    checkScreenSize();
    return Consumer2<MzansiProfileProvider, MihAccessControllsProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider,
          MihAccessControllsProvider accessProvider,
          Widget? child) {
        if (accessProvider.accessList!.isNotEmpty) {
          return ListView.separated(
            separatorBuilder: (BuildContext context, index) {
              return SizedBox(height: 3);
            },
            itemCount: filterAccessList(accessProvider.accessList!).length,
            itemBuilder: (context, index) {
              final filteredList = filterAccessList(accessProvider.accessList!);
              return displayQueue(
                  mzansiProfileProvider, accessProvider, index, filteredList);
            },
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Icon(
                  MihIcons.mihAccessControls,
                  size: 165,
                  color: MihColors.secondary(),
                ),
                const SizedBox(height: 10),
                Text(
                  "No business access available or pending",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: MihColors.secondary(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
