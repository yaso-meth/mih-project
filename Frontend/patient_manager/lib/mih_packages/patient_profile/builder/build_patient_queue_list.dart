import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_window.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_warning_message.dart';
import 'package:patient_manager/mih_env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/mih_objects/app_user.dart';
import 'package:patient_manager/mih_objects/arguments.dart';
import 'package:patient_manager/mih_objects/business.dart';
import 'package:patient_manager/mih_objects/business_user.dart';
import 'package:patient_manager/mih_objects/patient_queue.dart';
import 'package:patient_manager/mih_objects/patients.dart';
import 'package:supertokens_flutter/http.dart' as http;

class BuildPatientQueueList extends StatefulWidget {
  final List<PatientQueue> patientQueue;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;

  const BuildPatientQueueList({
    super.key,
    required this.patientQueue,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
  });

  @override
  State<BuildPatientQueueList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildPatientQueueList> {
  String baseAPI = AppEnviroment.baseApiUrl;

  Future<void> updateAccessAPICall(int index, String accessType) async {
    var response = await http.put(
      Uri.parse("$baseAPI/access-requests/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": widget.business!.business_id,
        "app_id": widget.patientQueue[index].app_id,
        "date_time": widget.patientQueue[index].date_time,
        "access": accessType,
      }),
    );
    if (response.statusCode == 200) {
      //Navigator.of(context).pushNamed('/home');
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        '/patient-manager',
        arguments: BusinessArguments(
          widget.signedInUser,
          widget.businessUser,
          widget.business,
        ),
      );
      // Navigator.of(context).pushNamed(
      //   '/patient-access-review',
      //   arguments: widget.signedInUser,
      // );
      String message =
          "The appointment for ${widget.patientQueue[index].first_name} ${widget.patientQueue[index].last_name} at ${widget.patientQueue[index].date_time} has been successfully canceled.";

      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<Patient> fetchPatients(String app_id) async {
    //print("pat man drawer: " + endpointUserData + widget.userEmail);

    var response = await http.get(Uri.parse("$baseAPI/patients/$app_id"));

    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      // print("here");
      String body = response.body;
      var decodedData = jsonDecode(body);
      Patient u = Patient.fromJson(decodedData);
      // print(u.email);
      //setState(() {
      //_widgetOptions = setLayout(u);
      //});
      return u;
    } else {
      throw Exception("Error: GetUserData status code ${response.statusCode}");
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

  void viewConfirmationPopUp(int index) {
    String subtitle =
        "Appointment: ${widget.patientQueue[index].date_time.substring(0, 16).replaceAll("T", " ")}\n";
    subtitle +=
        "Patient: ${widget.patientQueue[index].first_name} ${widget.patientQueue[index].last_name}\n\n";
    //subtitle += "Business Type: ${widget.patientQueue[index].last_name}\n\n";
    subtitle +=
        "Would you like to view the patient's profile before the appointment or cancel the appointment now?\n";
    //"You are about to approve an access request to your patient profile.\nPlease be aware that once approved, ${widget.accessRequests[index].Name} will have access to your profile information until ${widget.accessRequests[index].revoke_date.substring(0, 16).replaceAll("T", " ")}.\nIf you are unsure about an upcoming appointment with ${widget.accessRequests[index].Name}, please contact ${widget.accessRequests[index].contact_no} for clarification before approving this request.\n";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MIHWindow(
          fullscreen: false,
          windowTitle: "Appointment Confirmation",
          windowBody: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                subtitle,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  fontSize: 15,
                  //fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                SizedBox(
                  width: 300,
                  height: 50,
                  child: MIHButton(
                    onTap: () {
                      updateAccessAPICall(index, "cancelled");
                    },
                    buttonText: "Cancel Appointment",
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.errorColor(),
                    textColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: MIHButton(
                    onTap: () {
                      //updateAccessAPICall(index, "approved");
                      if (widget.patientQueue[index].access == "approved") {
                        Patient selectedPatient;
                        fetchPatients(widget.patientQueue[index].app_id).then(
                          (result) {
                            setState(() {
                              selectedPatient = result;
                              Navigator.of(context)
                                  .pushNamed('/patient-manager/patient',
                                      arguments: PatientViewArguments(
                                        widget.signedInUser,
                                        selectedPatient,
                                        widget.businessUser,
                                        widget.business,
                                        "business",
                                      ));
                            });
                          },
                        );
                      } else {
                        noAccessWarning();
                      }
                    },
                    buttonText: "View Patient Profile",
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.successColor(),
                    textColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
          windowTools: const [],
          onWindowTapClose: () {
            Navigator.pop(context);
          }),
    );
  }

  Widget displayQueue(int index) {
    String fname = widget.patientQueue[index].first_name[0] + "********";
    String lname = widget.patientQueue[index].last_name[0] + "********";
    String title =
        widget.patientQueue[index].date_time.split('T')[1].substring(0, 5);
    String line234 = "";
    var nowDate = DateTime.now();
    var expireyDate = DateTime.parse(widget.patientQueue[index].revoke_date);

    if (widget.patientQueue[index].access != "approved" ||
        expireyDate.isBefore(nowDate)) {
      line234 += "Name: $fname $lname\n";
      line234 += "ID No.: ${widget.patientQueue[index].id_no}\n";
      line234 += "Medical Aid No: ********";
      //subtitle += "********";
    } else {
      line234 +=
          "Name: ${widget.patientQueue[index].first_name} ${widget.patientQueue[index].last_name}\nID No.: ${widget.patientQueue[index].id_no}\nMedical Aid No: ";
      if (widget.patientQueue[index].medical_aid_no == "") {
        line234 += "No Medical Aid";
      } else {
        // subtitle +=
        //     "\nMedical Aid No: ";
        line234 += widget.patientQueue[index].medical_aid_no;
      }
    }
    String line5 = "\nAccess Request: ";
    String access = "";
    if (expireyDate.isBefore(nowDate) &&
        widget.patientQueue[index].access != "cacelled") {
      access += "EXPIRED";
    } else {
      access += widget.patientQueue[index].access.toUpperCase();
    }
    TextSpan accessWithColour;
    if (access == "APPROVED") {
      accessWithColour = TextSpan(
          text: access,
          style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.successColor()));
    } else if (access == "PENDING") {
      accessWithColour = TextSpan(
          text: access,
          style: TextStyle(
              color:
                  MzanziInnovationHub.of(context)!.theme.messageTextColor()));
    } else {
      accessWithColour = TextSpan(
          text: access,
          style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.errorColor()));
    }
    String line6 = "";
    line6 +=
        "\nAccess Expiration date: ${widget.patientQueue[index].revoke_date.substring(0, 16).replaceAll("T", " ")}";
    return ListTile(
      title: Text(
        "Appointment: $title",
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
            text: line234,
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(text: line5),
              accessWithColour,
              TextSpan(text: line6),
            ]),
      ),
      // Text(
      //   subtitle,
      //   style: TextStyle(
      //     color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      //   ),
      // ),
      onTap: () {
        var todayDate = DateTime.now();
        var revokeDate = DateTime.parse(widget.patientQueue[index].revoke_date);
        // print(
        //     "Todays: $todayDate\nRevoke Date: $revokeDate\nHas revoke date passed: ${revokeDate.isBefore(todayDate)}");
        if (revokeDate.isBefore(todayDate)) {
          expiredAccessWarning();
        } else if (widget.patientQueue[index].access == "approved") {
          viewConfirmationPopUp(index);
          // Patient selectedPatient;
          // fetchPatients(widget.patientQueue[index].app_id).then(
          //   (result) {
          //     setState(() {
          //       selectedPatient = result;
          //       Navigator.of(context).pushNamed('/patient-manager/patient',
          //           arguments: PatientViewArguments(
          //             widget.signedInUser,
          //             selectedPatient,
          //             widget.businessUser,
          //             widget.business,
          //             "business",
          //           ));
          //     });
          //   },
          // );
        } else if (widget.patientQueue[index].access == "declined") {
          accessDeclinedWarning();
        } else if (widget.patientQueue[index].access == "cancelled") {
          appointmentCancelledWarning();
        } else {
          viewConfirmationPopUp(index);
          //noAccessWarning();
        }
      },
      trailing: Icon(
        Icons.arrow_forward,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      ),
    );
  }

  void noAccessWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "No Access");
      },
    );
  }

  void accessDeclinedWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "Access Declined");
      },
    );
  }

  void appointmentCancelledWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "Appointment Canelled");
      },
    );
  }

  void expiredAccessWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "Expired Access");
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemCount: widget.patientQueue.length,
      itemBuilder: (context, index) {
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        //print(index);
        return displayQueue(index);
      },
    );
  }
}
