import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_service_calls.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_warning_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patient_access.dart';

class BuildBusinessAccessList extends StatefulWidget {
  final List<PatientAccess> patientAccessList;
  final AppUser signedInUser;

  const BuildBusinessAccessList({
    super.key,
    required this.patientAccessList,
    required this.signedInUser,
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

  void successPopUp(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MIHSuccessMessage(
          successType: "Success",
          successMessage: message,
        );
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

  Widget displayQueue(int index) {
    String line1 =
        "Business Name: ${widget.patientAccessList[index].requested_by}";
    String line2 = "";

    line2 +=
        "Request Date: ${widget.patientAccessList[index].requested_on.substring(0, 16).replaceAll("T", " ")}\n";
    line2 +=
        "Profile Type: ${widget.patientAccessList[index].type.toUpperCase()}\n";
    //subtitle += "Business Type: ${widget.patientAccessList[index].type}\n";
    String line3 = "Status: ";
    String access = widget.patientAccessList[index].status.toUpperCase();

    TextSpan accessWithColour;
    if (access == "APPROVED") {
      accessWithColour = TextSpan(
          text: "$access\n",
          style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.successColor()));
    } else if (access == "PENDING") {
      accessWithColour = TextSpan(
          text: "$access\n",
          style: TextStyle(
              color:
                  MzanziInnovationHub.of(context)!.theme.messageTextColor()));
    } else {
      accessWithColour = TextSpan(
          text: "$access\n",
          style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.errorColor()));
    }

    return ListTile(
      title: Text(
        line1,
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
      //     color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      //   ),
      // ),
      onTap: () {
        viewApprovalPopUp(index);
      },
      // trailing: Icon(
      //   Icons.arrow_forward,
      //   color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      // ),
    );
  }

  void checkScreenSize() {
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
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

  void viewApprovalPopUp(int index) {
    String subtitle =
        "Business Name: ${widget.patientAccessList[index].requested_by}\n";
    subtitle +=
        "Requested Date: ${widget.patientAccessList[index].requested_on.substring(0, 16).replaceAll("T", " ")}\n";

    subtitle +=
        "Profile Type: ${widget.patientAccessList[index].type.toUpperCase()}\n";
    subtitle +=
        "Status: ${widget.patientAccessList[index].status.toUpperCase()}";
    if (widget.patientAccessList[index].status == 'pending') {
      //     "\nYou are about to approve an access request to your patient profile.\nPlease be aware that once approved, ${widget.patientAccessList[index].requested_by} will have access to your profile forever and will be able to contribute to it.\nIf you are unsure about an upcoming appointment with ${widget.patientAccessList[index].requested_by}, please contact *Add Number here* for clarification before approving this request.";
    } else {
      subtitle +=
          "\nActioned By: ${widget.patientAccessList[index].approved_by}\n";
      subtitle +=
          "Actioned On: ${widget.patientAccessList[index].approved_on.substring(0, 16).replaceAll("T", " ")}";
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
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    fontSize: popUpBodySize,
                    //fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Visibility(
                visible: widget.patientAccessList[index].status == 'pending',
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Important Notice: Approving Profile Access",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            MzanziInnovationHub.of(context)!.theme.errorColor(),
                      ),
                    ),
                    Text(
                      "You are about to accept access to your patient's profile. Please be aware of the following important points:",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color:
                            MzanziInnovationHub.of(context)!.theme.errorColor(),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "1. Permanent Access: Once you accepts this access request, it will become permanent.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .errorColor(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "2. Shared Information: Any updates make to youe patient profile will be visible to all who have access to the profile.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .errorColor(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "3. Irreversible Access: Once granted, you cannot revoke access to your patient's profile.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .errorColor(),
                        ),
                      ),
                    ),
                    Text(
                      "By pressing the \"Approve\" button you accept the above terms.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            MzanziInnovationHub.of(context)!.theme.errorColor(),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.patientAccessList[index].status == 'approved',
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Important Notice: Approved Profile Access",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            MzanziInnovationHub.of(context)!.theme.errorColor(),
                      ),
                    ),
                    Text(
                      "You have accepted access to your patient's profile. Please be aware of the following important points:",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color:
                            MzanziInnovationHub.of(context)!.theme.errorColor(),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "1. Permanent Access: This access is permanent.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .errorColor(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "2. Shared Information: Any updates make to youe patient profile will be visible to all who have access to the profile.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .errorColor(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 700,
                      child: Text(
                        "3. Irreversible Access: You cannot revoke this access to your patient's profile.",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .errorColor(),
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
                visible: widget.patientAccessList[index].status == 'pending',
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    MihButton(
                      onPressed: () {
                        print("request declined");
                        MIHApiCalls.updatePatientAccessAPICall(
                          widget.patientAccessList[index].business_id,
                          widget.patientAccessList[index].requested_by,
                          widget.patientAccessList[index].app_id,
                          "declined",
                          "${widget.signedInUser.fname} ${widget.signedInUser.lname}",
                          widget.signedInUser,
                          context,
                        );
                      },
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      width: 300,
                      child: Text(
                        "Decline",
                        style: TextStyle(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MihButton(
                      onPressed: () {
                        print("request approved");
                        MIHApiCalls.updatePatientAccessAPICall(
                          widget.patientAccessList[index].business_id,
                          widget.patientAccessList[index].requested_by,
                          widget.patientAccessList[index].app_id,
                          "approved",
                          "${widget.signedInUser.fname} ${widget.signedInUser.lname}",
                          widget.signedInUser,
                          context,
                        );
                      },
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      width: 300,
                      child: Text(
                        "Approve",
                        style: TextStyle(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
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
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemCount: widget.patientAccessList.length,
      itemBuilder: (context, index) {
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        //print(index);
        return displayQueue(index);
      },
    );
  }
}
