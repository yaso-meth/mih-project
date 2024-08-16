import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/inputsAndButtons/mihButton.dart';
import 'package:patient_manager/components/popUpMessages/mihErrorMessage.dart';
import 'package:patient_manager/components/popUpMessages/mihSuccessMessage.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/accessRequest.dart';
import 'package:patient_manager/objects/appUser.dart';
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
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

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

  Widget displayQueue(int index) {
    String title =
        "Appointment: ${widget.accessRequests[index].date_time.substring(0, 16).replaceAll("T", " ")}";
    String subtitle = "";
    subtitle += "Requestor: ${widget.accessRequests[index].Name}\n";
    //subtitle += "Business Type: ${widget.accessRequests[index].type}\n";
    subtitle +=
        "Access: ${widget.accessRequests[index].access.toUpperCase()}\n";
    if (widget.accessRequests[index].revoke_date.contains("9999")) {
      subtitle += "Access Expiration date: NOT SET";
    } else {
      subtitle +=
          "Access Expiration date: ${widget.accessRequests[index].revoke_date.substring(0, 10)}";
    }
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      onTap: () {
        viewApprovalPopUp(index);
      },
      trailing: Icon(
        Icons.arrow_forward,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      ),
    );
  }

  void viewApprovalPopUp(int index) {
    String subtitle =
        "Appointment: ${widget.accessRequests[index].date_time.substring(0, 16).replaceAll("T", " ")}\n";
    subtitle += "Requestor: ${widget.accessRequests[index].Name}\n";
    subtitle += "Business Type: ${widget.accessRequests[index].type}\n\n";
    // subtitle += "Access: ${widget.accessRequests[index].access.toUpperCase()}";
    // if (widget.accessRequests[index].revoke_date.contains("9999")) {
    //   subtitle += "Access Expiration date: NOT SET\n\n";
    // } else {
    //   subtitle +=
    //       "Access Expiration date: ${widget.accessRequests[index].revoke_date.substring(0, 10)}\n\n";
    // }
    subtitle +=
        "You are about to approve an access request to your patient profile.\nPlease be aware that once approved, ${widget.accessRequests[index].Name} will have access to your profile information until ${widget.accessRequests[index].revoke_date.substring(0, 16).replaceAll("T", " ")}.\nIf you are unsure about an upcoming appointment with ${widget.accessRequests[index].Name}, please contact ${widget.accessRequests[index].contact_no} for clarification before approving this request.\n";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              //padding: const EdgeInsets.all(15.0),
              width: 800.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    width: 5.0),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Update Appointment Access",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        fontSize: 35.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    SizedBox(
                      width: 600,
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          fontSize: 20.0,
                          //fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    Wrap(
                      runSpacing: 10,
                      spacing: 10,
                      children: [
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: MIHButton(
                            onTap: () {
                              updateAccessAPICall(index, "declined");
                            },
                            buttonText: "Decline",
                            buttonColor: MzanziInnovationHub.of(context)!
                                .theme
                                .errorColor(),
                            textColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          height: 50,
                          child: MIHButton(
                            onTap: () {
                              updateAccessAPICall(index, "approved");
                            },
                            buttonText: "Approve",
                            buttonColor: MzanziInnovationHub.of(context)!
                                .theme
                                .successColor(),
                            textColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
