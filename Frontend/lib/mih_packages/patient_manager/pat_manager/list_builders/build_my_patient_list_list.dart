import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_service_calls.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_calendar_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_date_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_time_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_warning_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patient_access.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patients.dart';
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

  Future<void> submitApointment(int index) async {
    //To-Do: Add the appointment to the database
    // print("To-Do: Add the appointment to the database");
    String description =
        "Date: ${dateController.text}\nTime: ${timeController.text}\n";
    description += "Medical Practice: ${widget.business!.Name}\n";
    description += "Contact Number: ${widget.business!.contact_no}";
    int statusCode;
    statusCode = await MihMzansiCalendarApis.addPatientAppointment(
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
    if (statusCode == 201) {
      context.pop();
      successPopUp("Successfully Added Appointment",
          "You appointment has been successfully added to your calendar.");
    } else {
      internetConnectionPopUp();
    }
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(
          errorType: "Internet Connection",
        );
      },
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
                    context.pop();
                    setState(() {
                      dateController.clear();
                      timeController.clear();
                      idController.clear();
                      fnameController.clear();
                      lnameController.clear();
                    });
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
              MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.056)
                  : const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              MihForm(
                formKey: _formKey,
                formFields: [
                  MihTextFormField(
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                  MihDateField(
                    controller: dateController,
                    labelText: "Date",
                    required: true,
                    validator: (value) {
                      return MihValidationServices().isEmpty(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  MihTimeField(
                    controller: timeController,
                    labelText: "Time",
                    required: true,
                    validator: (value) {
                      return MihValidationServices().isEmpty(value);
                    },
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
                        } else {
                          MihAlertServices().formNotFilledCompletely(context);
                        }
                      },
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        "Book Appointment",
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
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
              MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.05)
                  : const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              MihTextFormField(
                fillColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                inputColor: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                fillColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                inputColor: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                fillColor: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                inputColor: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        "Book Appointment",
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
                        context.pop();
                        context.pushNamed('patientManagerPatient',
                            extra: PatientViewArguments(
                              widget.signedInUser,
                              patientProfile,
                              widget.businessUser,
                              widget.business,
                              "business",
                            ));
                        // Navigator.of(context)
                        //     .pushNamed('/patient-manager/patient',
                        //         arguments: PatientViewArguments(
                        //           widget.signedInUser,
                        //           patientProfile,
                        //           widget.businessUser,
                        //           widget.business,
                        //           "business",
                        //         ));
                      },
                      buttonColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        "View Medical Records",
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
              color: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark")));
    } else if (access == "PENDING") {
      firstName = "${widget.patientAccesses[index].fname[0]}********";
      lastName = "${widget.patientAccesses[index].lname[0]}********";
      accessWithColour = TextSpan(
          text: "$access\n",
          style: TextStyle(
              color: MihColors.getGreyColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark")));
    } else {
      firstName = "${widget.patientAccesses[index].fname[0]}********";
      lastName = "${widget.patientAccesses[index].lname[0]}********";
      accessWithColour = TextSpan(
          text: "$access\n",
          style: TextStyle(
              color: MihColors.getRedColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark")));
    }

    return ListTile(
      title: Text(
        "$firstName $lastName",
        style: TextStyle(
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
        color: MihColors.getSecondaryColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      },
      itemCount: widget.patientAccesses.length,
      itemBuilder: (context, index) {
        return displayMyPatientTile(index, screenWidth);
      },
    );
  }
}
