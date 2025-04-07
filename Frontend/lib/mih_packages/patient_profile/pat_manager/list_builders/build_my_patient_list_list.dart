import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_api_calls.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_mzansi_calendar_apis.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_date_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_time_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_warning_message.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_objects/patients.dart';
import 'package:flutter/material.dart';

class BuildMyPatientListList extends StatefulWidget {
  final List<PatientAccess> patientAccesses;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;

  const BuildMyPatientListList({
    super.key,
    required this.patientAccesses,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
  });

  @override
  State<BuildMyPatientListList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildMyPatientListList> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();

  final baseAPI = AppEnviroment.baseApiUrl;

  void submitApointment(int index) {
    //To-Do: Add the appointment to the database
    // print("To-Do: Add the appointment to the database");
    String description =
        "Date: ${dateController.text}\nTime: ${timeController.text}\n";
    description += "Medical Practice: ${widget.business!.Name}\n";
    description += "Contact Number: ${widget.business!.contact_no}";
    MihMzansiCalendarApis.addPatientAppointment(
      widget.signedInUser,
      false,
      widget.patientAccesses[index].app_id,
      BusinessArguments(
        widget.signedInUser,
        widget.businessUser,
        widget.business,
      ),
      "${widget.patientAccesses[index].fname} ${widget.patientAccesses[index].lname} - Doctors Visit",
      description,
      dateController.text,
      timeController.text,
      context,
    );
    // MIHApiCalls.addAppointmentAPICall(
    //   widget.business!.business_id,
    //   widget.patientAccesses[index].app_id,
    //   dateController.text,
    //   timeController.text,
    //   BusinessArguments(
    //     widget.signedInUser,
    //     widget.businessUser,
    //     widget.business,
    //   ),
    //   context,
    // );
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
                  appointmentPopUp(index);
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
                  // Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/patient-manager/patient',
                      arguments: PatientViewArguments(
                        widget.signedInUser,
                        patientProfile,
                        widget.businessUser,
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

  Widget displayMyPatientTile(int index) {
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
        return displayMyPatientTile(index);
      },
    );
  }
}
