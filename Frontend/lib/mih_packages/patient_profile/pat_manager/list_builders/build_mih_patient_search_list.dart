import 'dart:convert';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_service_calls.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_warning_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patients.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

class BuildMihPatientSearchList extends StatefulWidget {
  final List<Patient> patients;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final bool personalSelected;

  const BuildMihPatientSearchList({
    super.key,
    required this.patients,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
    required this.personalSelected,
  });

  @override
  State<BuildMihPatientSearchList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildMihPatientSearchList> {
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController accessStatusController = TextEditingController();
  final baseAPI = AppEnviroment.baseApiUrl;

  Future<void> addPatientAccessAPICall(int index) async {
    var response = await http.post(
      Uri.parse("$baseAPI/access-requests/insert/"),
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
          widget.signedInUser,
          widget.businessUser,
          widget.business,
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
        "app_id": widget.patients[index].app_id,
        "notification_type": "New Appointment Booked",
        "notification_message":
            "A new Appointment has been booked by ${widget.business!.Name} for the ${dateController.text} ${timeController.text}. Please approve the Access Review request.",
        "action_path": "/mih-access",
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

  void noAccessWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "No Access");
      },
    );
  }

  Future<bool> hasAccessToProfile(int index) async {
    var hasAccess = false;
    await MIHApiCalls.checkBusinessAccessToPatient(
            widget.business!.business_id, widget.patients[index].app_id)
        .then((results) {
      if (results.isEmpty) {
        setState(() {
          hasAccess = false;
        });
      } else if (results[0].status == "approved") {
        setState(() {
          hasAccess = true;
        });
      } else {
        setState(() {
          hasAccess = false;
        });
      }
    });
    return hasAccess;
  }

  Future<String> getAccessStatusOfProfile(int index) async {
    var accessStatus = "";
    await MIHApiCalls.checkBusinessAccessToPatient(
            widget.business!.business_id, widget.patients[index].app_id)
        .then((results) {
      if (results.isEmpty) {
        setState(() {
          accessStatus = "";
        });
      } else {
        setState(() {
          accessStatus = results[0].status;
        });
      }
    });
    return accessStatus;
  }

  void patientProfileChoicePopUp(int index) async {
    var hasAccess = false;
    String accessStatus = "";
    await hasAccessToProfile(index).then((result) {
      setState(() {
        hasAccess = result;
      });
    });
    await getAccessStatusOfProfile(index).then((result) {
      setState(() {
        accessStatus = result;
      });
    });
    if (accessStatus == "") {
      accessStatus = "No Access";
    }
    var idStars = '*' * (13 - 6);
    String startedOutPatientIdNo =
        "${widget.patients[index].id_no.substring(0, 6)}$idStars";
    setState(() {
      idController.text = startedOutPatientIdNo;
      fnameController.text = widget.patients[index].first_name;
      lnameController.text = widget.patients[index].last_name;
      accessStatusController.text = accessStatus.toUpperCase();
    });
    //print(accessStatus);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Patient Profile",
        onWindowTapClose: () {
          Navigator.pop(context);
        },
        windowBody: Column(
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
            const SizedBox(height: 10.0),
            MihTextFormField(
              fillColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              inputColor: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              controller: accessStatusController,
              multiLineInput: false,
              requiredText: true,
              readOnly: true,
              hintText: "Access Status",
              validator: (value) {
                return MihValidationServices().isEmpty(value);
              },
            ),
            const SizedBox(height: 20.0),
            Visibility(
              visible: !hasAccess,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Important Notice: Requesting Patient Profile Access",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MihColors.getRedColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                  Text(
                    "You are about to request access to a patient's profile. Please be aware of the following important points:",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: MihColors.getRedColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                  SizedBox(
                    width: 600,
                    child: Text(
                      "1. Permanent Access: Once the patient accepts your access request, it will become permanent.",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 600,
                    child: Text(
                      "2. Shared Information: Any updates you make to the patient's profile will be visible to others who have access to the profile.",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 600,
                    child: Text(
                      "3. Irreversible Access: Once granted, you cannot revoke your access to the patient's profile.",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: MihColors.getRedColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                  Text(
                    "By pressing the \"Request Access\" button you accept the above terms.\n",
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
            // const SizedBox(height: 15.0),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 10,
                spacing: 10,
                children: [
                  Visibility(
                    visible: hasAccess,
                    child: Center(
                      child: MihButton(
                        onPressed: () {
                          if (hasAccess) {
                            context.pop();
                            context.pushNamed('patientManagerPatient',
                                extra: PatientViewArguments(
                                  widget.signedInUser,
                                  widget.patients[index],
                                  widget.businessUser,
                                  widget.business,
                                  "business",
                                ));
                            // Navigator.of(context)
                            //     .pushNamed('/patient-manager/patient',
                            //         arguments: PatientViewArguments(
                            //           widget.signedInUser,
                            //           widget.patients[index],
                            //           widget.businessUser,
                            //           widget.business,
                            //           "business",
                            //         ));
                          } else {
                            noAccessWarning();
                          }
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "View Profile",
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
                  ),
                  Visibility(
                    visible: !hasAccess && accessStatus == "No Access",
                    child: Center(
                      child: MihButton(
                        onPressed: () {
                          MIHApiCalls.addPatientAccessAPICall(
                            widget.business!.business_id,
                            widget.patients[index].app_id,
                            "patient",
                            widget.business!.Name,
                            widget.personalSelected,
                            BusinessArguments(
                              widget.signedInUser,
                              widget.businessUser,
                              widget.business,
                            ),
                            context,
                          );
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "Request Access",
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
                  ),
                  Visibility(
                    visible: !hasAccess && accessStatus == "declined",
                    child: Center(
                      child: MihButton(
                        onPressed: () {
                          MIHApiCalls.reapplyPatientAccessAPICall(
                            widget.business!.business_id,
                            widget.patients[index].app_id,
                            widget.personalSelected,
                            BusinessArguments(
                              widget.signedInUser,
                              widget.businessUser,
                              widget.business,
                            ),
                            context,
                          );
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "Re-apply",
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
                  ),
                  Visibility(
                    visible: !hasAccess && accessStatus == "pending",
                    child: const SizedBox(
                      width: 500,
                      //height: 50,
                      child: Text(
                          "Patient has not approved access to their profile. Once access has been approved you can book and appointment or view their profile."),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget isMainMember(int index) {
    //var matchRE = RegExp(r'^[a-z]+$');
    // var firstLetterFName = widget.patients[index].first_name[0];
    // var firstLetterLName = widget.patients[index].last_name[0];
    // var fnameStar = '*' * 8;
    // var lnameStar = '*' * 8;

    if (widget.patients[index].medical_aid_main_member == "Yes") {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            // "$firstLetterFName$fnameStar $firstLetterLName$lnameStar",
            "${widget.patients[index].first_name} ${widget.patients[index].last_name}",
            style: TextStyle(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.star_border_rounded,
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
        ],
      );
    } else {
      return Text(
        // "$firstLetterFName$fnameStar $firstLetterLName$lnameStar",
        "${widget.patients[index].first_name} ${widget.patients[index].last_name}",
        style: TextStyle(
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      );
    }
  }

  Widget hasMedicalAid(int index) {
    var medAidNoStar = '*' * 8;
    var idStars = '*' * (13 - 6);
    String startedOutPatientIdNo =
        "${widget.patients[index].id_no.substring(0, 6)}$idStars";
    if (widget.patients[index].medical_aid == "Yes") {
      return ListTile(
        title: isMainMember(index),
        subtitle: Text(
          "ID No.: $startedOutPatientIdNo\nMedical Aid No.: $medAidNoStar",
          style: TextStyle(
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
        ),
        onTap: () {
          patientProfileChoicePopUp(index);
          // setState(() {
          //   appointmentPopUp(index);
          //   // Add popup to add patienmt to queue
          //   // Navigator.of(context).pushNamed('/patient-manager/patient',
          //   //     arguments: PatientViewArguments(
          //   //         widget.signedInUser, widget.patients[index], "business"));
          // });
        },
        trailing: Icon(
          Icons.arrow_forward,
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        ),
      );
    } else {
      return ListTile(
        title: isMainMember(index),
        subtitle: Text(
          "ID No.: $startedOutPatientIdNo\nMedical Aid No.: $medAidNoStar",
          style: TextStyle(
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
        ),
        onTap: () {
          patientProfileChoicePopUp(index);
          // setState(() {
          //   appointmentPopUp(index);
          //   // Navigator.of(context).pushNamed('/patient-manager/patient',
          //   //     arguments: PatientViewArguments(
          //   //         widget.signedInUser, widget.patients[index], "business"));
          // });
        },
        trailing: Icon(
          Icons.add,
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
    accessStatusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
