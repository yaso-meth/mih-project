import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_date_input.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_time_input.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:patient_manager/mih_env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/mih_objects/app_user.dart';
import 'package:patient_manager/mih_objects/arguments.dart';
import 'package:patient_manager/mih_objects/business.dart';
import 'package:patient_manager/mih_objects/patients.dart';
import 'package:supertokens_flutter/http.dart' as http;

class BuildPatientsList extends StatefulWidget {
  final List<Patient> patients;
  final AppUser signedInUser;
  final Business? business;
  final BusinessArguments arguments;

  const BuildPatientsList({
    super.key,
    required this.patients,
    required this.signedInUser,
    required this.business,
    required this.arguments,
  });

  @override
  State<BuildPatientsList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildPatientsList> {
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
        "app_id": widget.patients[index].app_id,
        "date": dateController.text,
        "time": timeController.text,
        "access": "pending",
      }),
    );
    if (response.statusCode == 201) {
      // Navigator.pushNamed(context, '/patient-manager/patient',
      //     arguments: widget.signedInUser);
      String message =
          "The appointment has been successfully booked!\n\nAn approval request as been sent to the patient.Once the access request has been approved, you will be able to access the patients profile. ou can check the status of your request in patient queue under the appointment.";
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
    addPatientAppointmentAPICall(index);
  }

  bool isAppointmentFieldsFilled() {
    if (dateController.text.isEmpty || timeController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void appointmentPopUp(int index) {
    var firstLetterFName = widget.patients[index].first_name[0];
    var firstLetterLName = widget.patients[index].last_name[0];
    var fnameStar = '*' * 8;
    var lnameStar = '*' * 8;

    setState(() {
      idController.text = widget.patients[index].id_no;
      fnameController.text = firstLetterFName + fnameStar;
      lnameController.text = firstLetterLName + lnameStar;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 700.0,
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Patient Appointment",
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
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
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
                                return const MIHErrorMessage(
                                    errorType: "Input Error");
                              },
                            );
                          }
                        },
                      ),
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

  Widget isMainMember(int index) {
    //var matchRE = RegExp(r'^[a-z]+$');
    var firstLetterFName = widget.patients[index].first_name[0];
    var firstLetterLName = widget.patients[index].last_name[0];
    var fnameStar = '*' * 8;
    var lnameStar = '*' * 8;

    if (widget.patients[index].medical_aid_main_member == "Yes") {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "$firstLetterFName$fnameStar $firstLetterLName$lnameStar",
            style: TextStyle(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.star_border_rounded,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ],
      );
    } else {
      return Text(
        "$firstLetterFName$fnameStar $firstLetterLName$lnameStar",
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      );
    }
  }

  Widget hasMedicalAid(int index) {
    var medAidNoStar = '*' * 8;
    if (widget.patients[index].medical_aid == "Yes") {
      return ListTile(
        title: isMainMember(index),
        subtitle: Text(
          "ID No.: ${widget.patients[index].id_no}\nMedical Aid No.: $medAidNoStar",
          style: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
        onTap: () {
          setState(() {
            appointmentPopUp(index);
            // Add popup to add patienmt to queue
            // Navigator.of(context).pushNamed('/patient-manager/patient',
            //     arguments: PatientViewArguments(
            //         widget.signedInUser, widget.patients[index], "business"));
          });
        },
        trailing: Icon(
          Icons.arrow_forward,
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      );
    } else {
      return ListTile(
        title: isMainMember(index),
        subtitle: Text(
          "ID No.: ${widget.patients[index].id_no}\nMedical Aid No.: $medAidNoStar",
          style: TextStyle(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
        ),
        onTap: () {
          setState(() {
            appointmentPopUp(index);
            // Navigator.of(context).pushNamed('/patient-manager/patient',
            //     arguments: PatientViewArguments(
            //         widget.signedInUser, widget.patients[index], "business"));
          });
        },
        trailing: Icon(
          Icons.add,
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      );
    }
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
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemCount: widget.patients.length,
      itemBuilder: (context, index) {
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        //print(index);
        return hasMedicalAid(index);
      },
    );
  }
}
