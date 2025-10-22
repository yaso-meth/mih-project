import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mih_access_controlls_provider.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_access_controls_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_warning_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
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

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void accessCancelledWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "Access Cancelled");
      },
    );
  }

  Widget displayQueue(
      MzansiProfileProvider mzansiProfileProvider,
      MihAccessControllsProvider accessProvider,
      int index,
      List<PatientAccess> filteredList) {
    String line1 = "Business Name: ${filteredList[index].requested_by}";
    String line2 = "";

    line2 +=
        "Request Date: ${filteredList[index].requested_on.substring(0, 16).replaceAll("T", " ")}\n";
    line2 += "Profile Type: ${filteredList[index].type.toUpperCase()}\n";
    //subtitle += "Business Type: ${widget.patientAccessList[index].type}\n";
    String line3 = "Status: ";
    String access = filteredList[index].status.toUpperCase();

    TextSpan accessWithColour;
    if (access == "APPROVED") {
      accessWithColour = TextSpan(
          text: "$access\n",
          style: TextStyle(
              color: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark")));
    } else if (access == "PENDING") {
      accessWithColour = TextSpan(
          text: "$access\n",
          style: TextStyle(
              color: MihColors.getGreyColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark")));
    } else {
      accessWithColour = TextSpan(
          text: "$access\n",
          style: TextStyle(
              color: MihColors.getRedColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark")));
    }

    return ListTile(
      title: Text(
        line1,
        style: TextStyle(
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
            text: line2,
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: line3),
              accessWithColour,
            ]),
      ),
      // Text(
      //   subtitle,
      //   style: TextStyle(
      //     color: MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      //   ),
      // ),
      onTap: () {
        viewApprovalPopUp(mzansiProfileProvider, accessProvider, index);
      },
      // trailing: Icon(
      //   Icons.arrow_forward,
      //   color: MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      // ),
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
      //     "\nYou are about to approve an access request to your patient profile.\nPlease be aware that once approved, ${widget.patientAccessList[index].requested_by} will have access to your profile forever and will be able to contribute to it.\nIf you are unsure about an upcoming appointment with ${widget.patientAccessList[index].requested_by}, please contact *Add Number here* for clarification before approving this request.";
    } else {
      subtitle +=
          "\nActioned By: ${accessProvider.accessList![index].approved_by}\n";
      subtitle +=
          "Actioned On: ${accessProvider.accessList![index].approved_on.substring(0, 16).replaceAll("T", " ")}";
      // subtitle +=
      //     "You have approved this access request to your patient profile.\nPlease be aware that once approved, ${widget.patientAccessList[index].requested_by} will have access to your profile forever and will be able to contribute to it.";
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
          fullscreen: false,
          windowTitle: "Profile Access",
          windowBody: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 1000,
                child: Text(
                  subtitle,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                        color: MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                    Text(
                      "You are about to accept access to your patient's profile. Please be aware of the following important points:",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "1. Permanent Access: Once you accepts this access request, it will become permanent.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MihColors.getRedColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "2. Shared Information: Any updates make to youe patient profile will be visible to all who have access to the profile.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MihColors.getRedColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "3. Irreversible Access: Once granted, you cannot revoke access to your patient's profile.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MihColors.getRedColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                    ),
                    Text(
                      "By pressing the \"Approve\" button you accept the above terms.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
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
                        color: MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                    Text(
                      "You have accepted access to your patient's profile. Please be aware of the following important points:",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "1. Permanent Access: This access is permanent.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MihColors.getRedColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "2. Shared Information: Any updates make to youe patient profile will be visible to all who have access to the profile.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MihColors.getRedColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "3. Irreversible Access: You cannot revoke this access to your patient's profile.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MihColors.getRedColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
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
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    MihButton(
                      onPressed: () async {
                        print("request declined");
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
                          internetConnectionPopUp();
                        }
                      },
                      buttonColor: MihColors.getRedColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        "Decline",
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
                      onPressed: () async {
                        print("request approved");
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
                          await MihAccessControlsServices()
                              .getBusinessAccessListOfPatient(
                            mzansiProfileProvider.user!.app_id,
                            accessProvider,
                          );
                          context.pop();
                          successPopUp("Successfully Actioned Request",
                              "You have successfully Accepted access request");
                        } else {
                          internetConnectionPopUp();
                        }
                      },
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        "Approve",
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
                    context.pop();
                    KenLogger.warning("dismissing pop up and refreshing list");
                    if (widget.onSuccessUpate != null) {
                      widget.onSuccessUpate!();
                    }
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
      },
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
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (BuildContext context, index) {
            return Divider(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            );
          },
          itemCount: filterAccessList(accessProvider.accessList!).length,
          itemBuilder: (context, index) {
            //final patient = widget.patients[index].id_no.contains(widget.searchString);
            //print(index);
            final filteredList = filterAccessList(accessProvider.accessList!);
            return displayQueue(
                mzansiProfileProvider, accessProvider, index, filteredList);
          },
        );
      },
    );
  }
}
