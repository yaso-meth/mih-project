import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/appointment.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

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

  Future<void> submitApointment(
    MzansiProfileProvider profileProvider,
    PatientManagerProvider patientManagerProvider,
    MihCalendarProvider calendarProvider,
    int index,
  ) async {
    String description = '';
    // "Date: ${dateController.text}\nTime: ${timeController.text}\n";
    description += "Medical Practice: ${profileProvider.business!.Name}\n";
    description += "Contact Number: ${profileProvider.business!.contact_no}";
    String offlineId = Uuid().v4();
    calendarProvider.addNewAppointmentLocally(
      profileProvider,
      Appointment(
        idappointments: 0,
        app_id: patientManagerProvider.myPaitentList![index].app_id,
        business_id: profileProvider.business!.business_id,
        date_time: "${dateController.text} ${timeController.text}",
        title:
            "${patientManagerProvider.myPaitentList![index].fname} ${patientManagerProvider.myPaitentList![index].lname} - Doctors Visit",
        description: description,
        offline_id: offlineId,
      ),
    );
    context.pop();
    successPopUp("Successfully Added Appointment",
        "You appointment has been successfully added to your calendar.");
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
          buttonColor: MihColors.primary(),
          elevation: 10,
          width: 300,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: MihColors.secondary(),
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
    MihCalendarProvider calendarProvider,
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
                    fillColor: MihColors.secondary(),
                    inputColor: MihColors.primary(),
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
                    fillColor: MihColors.secondary(),
                    inputColor: MihColors.primary(),
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
                    fillColor: MihColors.secondary(),
                    inputColor: MihColors.primary(),
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
                                profileProvider,
                                patientManagerProvider,
                                calendarProvider,
                                index);
                          } else {
                            MihAlertServices().inputErrorAlert(context);
                          }
                        } else {
                          MihAlertServices().inputErrorAlert(context);
                        }
                      },
                      buttonColor: MihColors.green(),
                      width: 300,
                      child: Text(
                        "Book Appointment",
                        style: TextStyle(
                          color: MihColors.primary(),
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
    MihCalendarProvider calendarProvider,
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
                fillColor: MihColors.secondary(),
                inputColor: MihColors.primary(),
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
                fillColor: MihColors.secondary(),
                inputColor: MihColors.primary(),
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
                fillColor: MihColors.secondary(),
                inputColor: MihColors.primary(),
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
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  runSpacing: 10,
                  spacing: 10,
                  children: [
                    MihButton(
                      onPressed: () {
                        appointmentPopUp(
                            profileProvider,
                            patientManagerProvider,
                            calendarProvider,
                            index,
                            width);
                      },
                      buttonColor: MihColors.green(),
                      width: 300,
                      child: Text(
                        "Book Appointment",
                        style: TextStyle(
                          color: MihColors.primary(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MihButton(
                      onPressed: () async {
                        // await MihPatientServices().getPatientDetails(
                        //     patientManagerProvider.myPaitentList![index].app_id,
                        //     patientManagerProvider);
                        context.pop();
                        context.pushNamed(
                          'patientManagerPatient',
                        );
                      },
                      buttonColor: MihColors.secondary(),
                      width: 300,
                      child: Text(
                        "View Medical Records",
                        style: TextStyle(
                          color: MihColors.primary(),
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
    MihCalendarProvider calendarProvider,
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
          color: MihColors.green(darkMode: false),
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (access == "PENDING") {
      firstName =
          "${patientManagerProvider.myPaitentList![index].fname[0]}********";
      lastName =
          "${patientManagerProvider.myPaitentList![index].lname[0]}********";
      accessWithColour = TextSpan(
        text: "$access\n",
        style: TextStyle(
          color: MihColors.grey(darkMode: true),
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      firstName =
          "${patientManagerProvider.myPaitentList![index].fname[0]}********";
      lastName =
          "${patientManagerProvider.myPaitentList![index].lname[0]}********";
      accessWithColour = TextSpan(
        text: "$access\n",
        style: TextStyle(
          color: MihColors.red(darkMode: false),
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return Material(
      color: MihColors.highlight(),
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        splashColor: Color.lerp(
          MihColors.bluishPurple(),
          Colors.black,
          0.01,
        ),
        hoverColor: MihColors.secondary(),
        title: Text(
          "$firstName $lastName",
          style: TextStyle(
            color: MihColors.primary(),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: RichText(
          text: TextSpan(
              text:
                  "ID No.: ${patientManagerProvider.myPaitentList![index].id_no}\n",
              style: TextStyle(
                color: MihColors.primary(),
              ),
              children: <TextSpan>[
                const TextSpan(text: "Access: "),
                accessWithColour,
              ]),
        ),
        onTap: () async {
          if (hasAccess) {
            // await MihPatientServices()
            //     .getPatientDetails(
            //         patientManagerProvider.myPaitentList![index].app_id,
            //         patientManagerProvider)
            //     .then((result) {});
            // await MihUserServices()
            //     .getMIHUserDetails(
            //         patientManagerProvider.myPaitentList![index].app_id,
            //         context)
            //     .then((user) async {
            //   user;
            //   String url = MihFileApi.getMinioFileUrlV2(user!.pro_pic_path);
            //   patientManagerProvider.setSelectedPatientProfilePicUrl(url);
            // });
            String patientAppId =
                patientManagerProvider.myPaitentList![index].app_id;
            patientManagerProvider.loadCachedPatientManager(patientAppId);
            if (patientManagerProvider.selectedPatient == null) {
              patientManagerProvider.syncWithMihServerData(patientAppId, null);
            }
            patientProfileChoicePopUp(profileProvider, patientManagerProvider,
                calendarProvider, index, width);
          } else {
            noAccessWarning(patientManagerProvider, index);
          }
        },
        // trailing: Icon(
        //   Icons.arrow_forward,
        //   color: MihColors.secondary(),
        // ),
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
    return Consumer3<MzansiProfileProvider, PatientManagerProvider,
        MihCalendarProvider>(
      builder: (
        BuildContext context,
        MzansiProfileProvider profileProvider,
        PatientManagerProvider patientManagerProvider,
        MihCalendarProvider calendarProvider,
        Widget? child,
      ) {
        return ListView.separated(
          separatorBuilder: (BuildContext context, index) {
            return SizedBox(
              height: 3,
            );
          },
          itemCount: patientManagerProvider.myPaitentList!.length,
          itemBuilder: (context, index) {
            return displayMyPatientTile(profileProvider, patientManagerProvider,
                calendarProvider, index, screenWidth);
          },
        );
      },
    );
  }
}
