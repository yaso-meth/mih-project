import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_calendar_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_date_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_time_field.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildMyPatientListList extends StatefulWidget {
  const BuildMyPatientListList({
    super.key,
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

  Future<void> submitApointment(MzansiProfileProvider profileProvider,
      PatientManagerProvider patientManagerProvider, int index) async {
    //To-Do: Add the appointment to the database
    // print("To-Do: Add the appointment to the database");
    String description =
        "Date: ${dateController.text}\nTime: ${timeController.text}\n";
    description += "Medical Practice: ${profileProvider.business!.Name}\n";
    description += "Contact Number: ${profileProvider.business!.contact_no}";
    int statusCode;
    statusCode = await MihMzansiCalendarApis.addPatientAppointment(
      profileProvider.user!,
      false,
      patientManagerProvider.myPaitentList![index].app_id,
      profileProvider.business!.business_id,
      "${patientManagerProvider.myPaitentList![index].fname} ${patientManagerProvider.myPaitentList![index].lname} - Doctors Visit",
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
      MihAlertServices().internetConnectionAlert(context);
    }
  }

  void successPopUp(String title, String message) {
    MihAlertServices().successAdvancedAlert(
      title,
      message,
      [
        MihButton(
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
          buttonColor: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          elevation: 10,
          width: 300,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
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

  void appointmentPopUp(
    MzansiProfileProvider profileProvider,
    PatientManagerProvider patientManagerProvider,
    int index,
    double width,
  ) {
    var firstLetterFName = patientManagerProvider.myPaitentList![index].fname;
    var firstLetterLName = patientManagerProvider.myPaitentList![index].lname;
    setState(() {
      idController.text = patientManagerProvider.myPaitentList![index].id_no;
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
                            submitApointment(
                                profileProvider, patientManagerProvider, index);
                          } else {
                            MihAlertServices().inputErrorAlert(context);
                          }
                        } else {
                          MihAlertServices().inputErrorAlert(context);
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

  void noAccessWarning(
      PatientManagerProvider patientManagerProvider, int index) {
    if (patientManagerProvider.myPaitentList![index].status == "pending") {
      MihAlertServices().warningAlert(
        "Access Pending",
        "Your access request is currently being reviewed.\nOnce approved, you'll be able to view patient data.\nPlease follow up with the patient to approve your access request.",
        context,
      );
    } else {
      MihAlertServices().errorBasicAlert(
        "Access Declined",
        "Your request to access the patient's profile has been denied. Please contact the patient directly to inquire about the reason for this restriction.",
        context,
      );
    }
  }

  bool hasAccessToProfile(
      PatientManagerProvider patientManagerProvider, int index) {
    var hasAccess = false;

    if (patientManagerProvider.myPaitentList![index].status == "approved") {
      hasAccess = true;
    } else {
      hasAccess = false;
    }
    return hasAccess;
  }

  void patientProfileChoicePopUp(
    MzansiProfileProvider profileProvider,
    PatientManagerProvider patientManagerProvider,
    int index,
    double width,
  ) async {
    var firstLetterFName = patientManagerProvider.myPaitentList![index].fname;
    var firstLetterLName = patientManagerProvider.myPaitentList![index].lname;
    setState(() {
      idController.text = patientManagerProvider.myPaitentList![index].id_no;
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
                        appointmentPopUp(profileProvider,
                            patientManagerProvider, index, width);
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
                      onPressed: () async {
                        await MihPatientServices().getPatientDetails(
                            patientManagerProvider.myPaitentList![index].app_id,
                            patientManagerProvider);
                        context.pop();
                        context.pushNamed(
                          'patientManagerPatient',
                        );
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

  Widget displayMyPatientTile(
    MzansiProfileProvider profileProvider,
    PatientManagerProvider patientManagerProvider,
    int index,
    double width,
  ) {
    var firstName = "";
    var lastName = "";
    String access =
        patientManagerProvider.myPaitentList![index].status.toUpperCase();
    TextSpan accessWithColour;
    var hasAccess = false;
    hasAccess = hasAccessToProfile(patientManagerProvider, index);
    //print(hasAccess);
    if (access == "APPROVED") {
      firstName = patientManagerProvider.myPaitentList![index].fname;
      lastName = patientManagerProvider.myPaitentList![index].lname;
      accessWithColour = TextSpan(
          text: "$access\n",
          style: TextStyle(
              color: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark")));
    } else if (access == "PENDING") {
      firstName =
          "${patientManagerProvider.myPaitentList![index].fname[0]}********";
      lastName =
          "${patientManagerProvider.myPaitentList![index].lname[0]}********";
      accessWithColour = TextSpan(
          text: "$access\n",
          style: TextStyle(
              color: MihColors.getGreyColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark")));
    } else {
      firstName =
          "${patientManagerProvider.myPaitentList![index].fname[0]}********";
      lastName =
          "${patientManagerProvider.myPaitentList![index].lname[0]}********";
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
            text:
                "ID No.: ${patientManagerProvider.myPaitentList![index].id_no}\n",
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              const TextSpan(text: "Access: "),
              accessWithColour,
            ]),
      ),
      onTap: () async {
        if (hasAccess) {
          await MihPatientServices()
              .getPatientDetails(
                  patientManagerProvider.myPaitentList![index].app_id,
                  patientManagerProvider)
              .then((result) {});
          await MihUserServices()
              .getMIHUserDetails(
                  patientManagerProvider.myPaitentList![index].app_id, context)
              .then((user) async {
            user;
            String url = await MihFileApi.getMinioFileUrl(user!.pro_pic_path);
            patientManagerProvider.setSelectedPatientProfilePicUrl(url);
          });
          patientProfileChoicePopUp(
              profileProvider, patientManagerProvider, index, width);
        } else {
          noAccessWarning(patientManagerProvider, index);
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
  void initState() {
    super.initState();
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
    return Consumer2<MzansiProfileProvider, PatientManagerProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          PatientManagerProvider patientManagerProvider, Widget? child) {
        return ListView.separated(
          separatorBuilder: (BuildContext context, index) {
            return Divider(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            );
          },
          itemCount: patientManagerProvider.myPaitentList!.length,
          itemBuilder: (context, index) {
            return displayMyPatientTile(
                profileProvider, patientManagerProvider, index, screenWidth);
          },
        );
      },
    );
  }
}
