import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/access_request.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:supertokens_flutter/http.dart' as http;

class BuildAccessRequestList extends StatefulWidget {
  final List<AccessRequest> accessRequests;
  final AppUser signedInUser;

  const BuildAccessRequestList({
    super.key,
    required this.accessRequests,
    required this.signedInUser,
  });

  @override
  State<BuildAccessRequestList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildAccessRequestList> {
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

  Future<void> updateAccessAPICall(int index, String accessType) async {
    var response = await http.put(
      Uri.parse("$baseAPI/access-requests/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": widget.accessRequests[index].business_id,
        "app_id": widget.accessRequests[index].app_id,
        "date_time": widget.accessRequests[index].date_time,
        "access": accessType,
      }),
    );
    if (response.statusCode == 200) {
      //Navigator.of(context).pushNamed('/home');
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        '/patient-access-review',
        arguments: widget.signedInUser,
      );
      String message = "";
      if (accessType == "approved") {
        message =
            "You've successfully approved the access request! ${widget.accessRequests[index].Name} now has access to your profile until ${widget.accessRequests[index].revoke_date.substring(0, 16).replaceAll("T", " ")}.";
      } else {
        message =
            "You've declined the access request. ${widget.accessRequests[index].Name} will not have access to your profile.";
      }
      MihAlertServices().successBasicAlert(
        "Success!",
        message,
        context,
      );
    } else {
      MihAlertServices().internetConnectionAlert(context);
    }
  }

  Widget displayQueue(int index) {
    String line1 =
        "Appointment: ${widget.accessRequests[index].date_time.substring(0, 16).replaceAll("T", " ")}";
    String line2 = "";
    line2 += "Requestor: ${widget.accessRequests[index].Name}\n";
    //subtitle += "Business Type: ${widget.accessRequests[index].type}\n";
    String line3 = "Access: ";
    String access = "";
    var nowDate = DateTime.now();
    var expireyDate = DateTime.parse(widget.accessRequests[index].revoke_date);

    if (expireyDate.isBefore(nowDate)) {
      access += "EXPIRED";
    } else {
      access += "${widget.accessRequests[index].access.toUpperCase()}";
    }
    String line4 = "";
    if (widget.accessRequests[index].revoke_date.contains("9999")) {
      line4 += "Access Expiration date: NOT SET";
    } else {
      line4 +=
          "Access Expiration date: ${widget.accessRequests[index].revoke_date.substring(0, 10)}";
    }
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
              TextSpan(text: line4),
            ]),
      ),
      // Text(
      //   subtitle,
      //   style: TextStyle(
      //     color: MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
      //   ),
      // ),
      onTap: () {
        if (access == "CANCELLED") {
          MihAlertServices().warningAlert(
            "Access Cancelled",
            "This appointment has been canceled. As a result, access has been cancelled and the doctor no longer have access to the patient's profile. If you would like them to view the patient's profile again, please book a new appointment through them.",
            context,
          );
        } else {
          viewApprovalPopUp(index);
        }
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

  void viewApprovalPopUp(int index) {
    String subtitle =
        "Appointment: ${widget.accessRequests[index].date_time.substring(0, 16).replaceAll("T", " ")}\n";
    subtitle += "Requestor: ${widget.accessRequests[index].Name}\n";
    subtitle += "Business Type: ${widget.accessRequests[index].type}\n\n";
    subtitle +=
        "You are about to approve an access request to your patient profile.\nPlease be aware that once approved, ${widget.accessRequests[index].Name} will have access to your profile information until ${widget.accessRequests[index].revoke_date.substring(0, 16).replaceAll("T", " ")}.\nIf you are unsure about an upcoming appointment with ${widget.accessRequests[index].Name}, please contact ${widget.accessRequests[index].contact_no} for clarification before approving this request.\n";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
          fullscreen: false,
          windowTitle: "Update Appointment Access",
          windowBody: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
              Wrap(
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                runSpacing: 10,
                spacing: 10,
                children: [
                  MihButton(
                    onPressed: () {
                      updateAccessAPICall(index, "declined");
                    },
                    buttonColor: MihColors.getRedColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                    onPressed: () {
                      updateAccessAPICall(index, "approved");
                    },
                    buttonColor: MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      },
      itemCount: widget.accessRequests.length,
      itemBuilder: (context, index) {
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        //print(index);
        return displayQueue(index);
      },
    );
  }
}
