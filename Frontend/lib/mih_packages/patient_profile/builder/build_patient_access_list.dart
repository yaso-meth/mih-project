import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

import '../../../main.dart';
import '../../../mih_apis/mih_api_calls.dart';
import '../../../mih_components/mih_inputs_and_buttons/mih_button.dart';
import '../../../mih_components/mih_inputs_and_buttons/mih_date_input.dart';
import '../../../mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import '../../../mih_components/mih_inputs_and_buttons/mih_time_input.dart';
import '../../../mih_components/mih_layout/mih_window.dart';
import '../../../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../../../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../../../mih_components/mih_pop_up_messages/mih_warning_message.dart';
import '../../../mih_env/env.dart';
import '../../../mih_objects/app_user.dart';
import '../../../mih_objects/arguments.dart';
import '../../../mih_objects/business.dart';
import '../../../mih_objects/patient_access.dart';
import '../../../mih_objects/patients.dart';

class BuildPatientAccessList extends StatefulWidget {
  final List<PatientAccess> patientAccesses;
  final AppUser signedInUser;
  final Business? business;
  final BusinessArguments arguments;

  const BuildPatientAccessList({
    super.key,
    required this.patientAccesses,
    required this.signedInUser,
    required this.business,
    required this.arguments,
  });

  @override
  State<BuildPatientAccessList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildPatientAccessList> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();

  final baseAPI = AppEnviroment.baseApiUrl;

  Future<void> addPatientAppointmentAPICall(int index) async {
    var response = await http.post(
      Uri.parse("$baseAPI/queue/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": widget.business!.business_id,
        "app_id": widget.patientAccesses[index].app_id,
        "date": dateController.text,
        "time": timeController.text,
        "access": "pending",
      }),
    );
    if (response.statusCode == 201) {
      // Navigator.pushNamed(context, '/patient-manager/patient',
      //     arguments: widget.signedInUser);
      String message =
          "The appointment has been successfully booked!\n\nAn approval request as been sent to the patient.Once the access request has been approved, you will be able to access the patientAccesses profile. ou can check the status of your request in patient queue under the appointment.";
      //     "${fnameController.text} ${lnameController.text} patient profiole has been successfully added!\n";
      Navigator.pop(context);
      Navigator.pop(context);
      setState(() {
        dateController.text = "";
        timeController.text = "";
      });
      Navigator.of(context).pushNamed(
        '/patient-manager',
        arguments: BusinessArguments(
          widget.arguments.signedInUser,
          widget.arguments.businessUser,
          widget.arguments.business,
        ),
      );
      successPopUp(message);
      addAccessReviewNotificationAPICall(index);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> addAccessReviewNotificationAPICall(int index) async {
    var response = await http.post(
      Uri.parse("$baseAPI/notifications/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": widget.patientAccesses[index].app_id,
        "notification_type": "New Appointment Booked",
        "notification_message":
            "A new Appointment has been booked by ${widget.arguments.business!.Name} for the ${dateController.text} ${timeController.text}. Please approve the Access Review request.",
        "action_path": "/access-review",
      }),
    );
    if (response.statusCode == 201) {
      // Navigator.pushNamed(context, '/patient-manager/patient',
      //     arguments: widget.signedInUser);
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

  void submitApointment(int index) {
    MIHApiCalls.addAppointmentAPICall(
      widget.arguments.business!.business_id,
      widget.patientAccesses[index].app_id,
      dateController.text,
      timeController.text,
      widget.arguments,
      context,
    );
    //addPatientAppointmentAPICall(index);
  }

  bool isAppointmentFieldsFilled() {
    if (dateController.text.isEmpty || timeController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void appointmentPopUp(int index) {
    var firstLetterFName = widget.patientAccesses[index].fname;
    var firstLetterLName = widget.patientAccesses[index].lname;

    setState(() {
      idController.text = widget.patientAccesses[index].id_no;
      fnameController.text = firstLetterFName;
      lnameController.text = firstLetterLName;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MIHWindow(
        fullscreen: false,
        windowTitle: "Patient Appointment",
        windowTools: const [],
        onWindowTapClose: () {
          Navigator.pop(context);
        },
        windowBody: [
          MIHTextField(
            controller: idController,
            hintText: "ID No.",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: fnameController,
            hintText: "First Name",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: lnameController,
            hintText: "Surname",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHDateField(
            controller: dateController,
            lableText: "Date",
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTimeField(
            controller: timeController,
            lableText: "Time",
            required: true,
          ),
          const SizedBox(height: 30.0),
          SizedBox(
            width: 300,
            height: 50,
            child: MIHButton(
              buttonText: "Book",
              buttonColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              onTap: () {
                //print("here1");
                bool filled = isAppointmentFieldsFilled();
                //print("fields filled: $filled");
                if (filled) {
                  //print("here2");
                  submitApointment(index);
                  //print("here3");
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const MIHErrorMessage(errorType: "Input Error");
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void noAccessWarning(int index) {
    if (widget.patientAccesses[index].status == "pending") {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHWarningMessage(warningType: "No Access");
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHWarningMessage(warningType: "Access Declined");
        },
      );
    }
  }

  bool hasAccessToProfile(int index) {
    var hasAccess = false;

    if (widget.patientAccesses[index].status == "approved") {
      hasAccess = true;
    } else {
      hasAccess = false;
    }
    return hasAccess;
  }

  void patientProfileChoicePopUp(int index, Patient? patientProfile) async {
    var firstLetterFName = widget.patientAccesses[index].fname;
    var firstLetterLName = widget.patientAccesses[index].lname;

    setState(() {
      idController.text = widget.patientAccesses[index].id_no;
      fnameController.text = firstLetterFName;
      lnameController.text = firstLetterLName;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MIHWindow(
        fullscreen: false,
        windowTitle: "Patient Profile",
        windowTools: const [],
        onWindowTapClose: () {
          Navigator.pop(context);
        },
        windowBody: [
          MIHTextField(
            controller: idController,
            hintText: "ID No.",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: fnameController,
            hintText: "First Name",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: lnameController,
            hintText: "Surname",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 30.0),
          Wrap(runSpacing: 10, spacing: 10, children: [
            SizedBox(
              width: 300,
              height: 50,
              child: MIHButton(
                buttonText: "Book Appointment",
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                textColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                onTap: () {
                  print("Book an Appointment!!!");
                  appointmentPopUp(index);

                  // //print("here1");
                  // bool filled = isAppointmentFieldsFilled();
                  // //print("fields filled: $filled");
                  // if (filled) {
                  //   //print("here2");
                  //   submitApointment(index);
                  //   //print("here3");
                  // } else {
                  //   showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return const MIHErrorMessage(errorType: "Input Error");
                  //     },
                  //   );
                  // }
                },
              ),
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: MIHButton(
                buttonText: "View Patient Profile",
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                textColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/patient-manager/patient',
                      arguments: PatientViewArguments(
                        widget.signedInUser,
                        patientProfile,
                        widget.arguments.businessUser,
                        widget.business,
                        "business",
                      ));
                },
              ),
            ),
          ])
        ],
      ),
    );
  }

  Widget displayAccessTile(int index) {
    var firstName = "";
    var lastName = "";
    String access = widget.patientAccesses[index].status.toUpperCase();
    TextSpan accessWithColour;
    var hasAccess = false;
    hasAccess = hasAccessToProfile(index);
    //print(hasAccess);
    if (access == "APPROVED") {
      firstName = widget.patientAccesses[index].fname;
      lastName = widget.patientAccesses[index].lname;
      accessWithColour = TextSpan(
          text: "$access\n",
          style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.successColor()));
    } else if (access == "PENDING") {
      firstName = "${widget.patientAccesses[index].fname[0]}********";
      lastName = "${widget.patientAccesses[index].lname[0]}********";
      accessWithColour = TextSpan(
          text: "$access\n",
          style: TextStyle(
              color:
                  MzanziInnovationHub.of(context)!.theme.messageTextColor()));
    } else {
      firstName = "${widget.patientAccesses[index].fname[0]}********";
      lastName = "${widget.patientAccesses[index].lname[0]}********";
      accessWithColour = TextSpan(
          text: "$access\n",
          style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.errorColor()));
    }

    return ListTile(
      title: Text(
        "$firstName $lastName",
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      subtitle: RichText(
        text: TextSpan(
            text: "ID No.: ${widget.patientAccesses[index].id_no}\n",
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              const TextSpan(text: "Access: "),
              accessWithColour,
            ]),
      ),
      onTap: () async {
        Patient? p;
        if (hasAccess) {
          await MIHApiCalls.fetchPatientByAppId(
                  widget.patientAccesses[index].app_id)
              .then((result) {
            setState(() {
              p = result;
            });
          });
          patientProfileChoicePopUp(index, p);
        } else {
          noAccessWarning(index);
        }
      },
      trailing: Icon(
        Icons.arrow_forward,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      ),
    );
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    idController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemCount: widget.patientAccesses.length,
      itemBuilder: (context, index) {
        //final patient = widget.patientAccesses[index].id_no.contains(widget.searchString);
        //print(index);
        return displayAccessTile(index);
      },
    );
  }
}
