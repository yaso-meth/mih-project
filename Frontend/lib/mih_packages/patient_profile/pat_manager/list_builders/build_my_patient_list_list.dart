import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_api_calls.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_mzansi_calendar_apis.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_date_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_time_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
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
  final _formKey = GlobalKey<FormState>();

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
  }

  bool isAppointmentFieldsFilled() {
    if (dateController.text.isEmpty || timeController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void appointmentPopUp(int index, double width) {
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
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Patient Appointment",
        onWindowTapClose: () {
          Navigator.pop(context);
        },
        windowBody: Padding(
          padding:
              MzanziInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.056)
                  : const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              MihForm(
                formKey: _formKey,
                formFields: [
                  MihTextFormField(
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    controller: idController,
                    multiLineInput: false,
                    requiredText: true,
                    readOnly: true,
                    hintText: "ID No.",
                    validator: (value) {
                      return MihValidationServices().isEmpty(value);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  MihTextFormField(
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    controller: fnameController,
                    multiLineInput: false,
                    requiredText: true,
                    readOnly: true,
                    hintText: "First Name",
                    validator: (value) {
                      return MihValidationServices().isEmpty(value);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  MihTextFormField(
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    controller: lnameController,
                    multiLineInput: false,
                    requiredText: true,
                    readOnly: true,
                    hintText: "Surname",
                    validator: (value) {
                      return MihValidationServices().isEmpty(value);
                    },
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
                  Center(
                    child: MihButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          bool filled = isAppointmentFieldsFilled();
                          if (filled) {
                            submitApointment(index);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const MIHErrorMessage(
                                    errorType: "Input Error");
                              },
                            );
                          }
                        }
                      },
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      width: 300,
                      child: Text(
                        "Book Appointment",
                        style: TextStyle(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

  void patientProfileChoicePopUp(
      int index, Patient? patientProfile, double width) async {
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
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Patient Profile",
        onWindowTapClose: () {
          Navigator.pop(context);
        },
        windowBody: Padding(
          padding:
              MzanziInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.05)
                  : const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              MihTextFormField(
                fillColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                inputColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                controller: idController,
                multiLineInput: false,
                requiredText: true,
                readOnly: true,
                hintText: "ID No.",
                validator: (value) {
                  return MihValidationServices().isEmpty(value);
                },
              ),
              const SizedBox(height: 10.0),
              MihTextFormField(
                fillColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                inputColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                controller: fnameController,
                multiLineInput: false,
                requiredText: true,
                readOnly: true,
                hintText: "First Name",
                validator: (value) {
                  return MihValidationServices().isEmpty(value);
                },
              ),
              const SizedBox(height: 10.0),
              MihTextFormField(
                fillColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                inputColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                controller: lnameController,
                multiLineInput: false,
                requiredText: true,
                readOnly: true,
                hintText: "Surname",
                validator: (value) {
                  return MihValidationServices().isEmpty(value);
                },
              ),
              const SizedBox(height: 30.0),
              Center(
                child: Wrap(
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    MihButton(
                      onPressed: () {
                        appointmentPopUp(index, width);
                      },
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      width: 300,
                      child: Text(
                        "Book Appointment",
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
                        Navigator.of(context)
                            .pushNamed('/patient-manager/patient',
                                arguments: PatientViewArguments(
                                  widget.signedInUser,
                                  patientProfile,
                                  widget.businessUser,
                                  widget.business,
                                  "business",
                                ));
                      },
                      buttonColor:
                          MzanziInnovationHub.of(context)!.theme.successColor(),
                      width: 300,
                      child: Text(
                        "View Medical Records",
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget displayMyPatientTile(int index, double width) {
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
          patientProfileChoicePopUp(index, p, width);
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
    double screenWidth = MediaQuery.of(context).size.width;
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
        return displayMyPatientTile(index, screenWidth);
      },
    );
  }
}
