import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/appointment.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_calendar_services.dart';
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

class BuildAppointmentList extends StatefulWidget {
  final bool inWaitingRoom;
  final TextEditingController titleController;
  final TextEditingController descriptionIDController;
  final TextEditingController? patientIdController;
  final TextEditingController dateController;
  final TextEditingController timeController;

  const BuildAppointmentList({
    super.key,
    required this.inWaitingRoom,
    required this.titleController,
    required this.descriptionIDController,
    required this.patientIdController,
    required this.dateController,
    required this.timeController,
  });

  @override
  State<BuildAppointmentList> createState() => _BuildAppointmentListState();
}

class _BuildAppointmentListState extends State<BuildAppointmentList> {
  String baseAPI = AppEnviroment.baseApiUrl;
  TextEditingController patientIdController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController daysExtensionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int counter = 0;
  late double width;
  late double height;

  void clearControllers() {
    widget.titleController.clear();
    widget.descriptionIDController.clear();
    widget.dateController.clear();
    widget.timeController.clear();
  }

  double getPaddingSize() {
    if (MzansiInnovationHub.of(context)!.theme.screenType == "desktop") {
      return (width / 10);
    } else {
      return 0.0;
    }
  }

  Widget displayAppointment(MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider, int index, double bodyWidth) {
    List<Appointment> appointmentList = mzansiProfileProvider.personalHome
        ? mihCalendarProvider.personalAppointments!
        : mihCalendarProvider.businessAppointments!;

    // SAFELY EXTRACT DATE AND TIME
    String dateTimeString = appointmentList[index].date_time;
    String timePart = "";
    String datePart = "";

    if (dateTimeString.contains("T")) {
      List<String> parts = dateTimeString.split('T');
      datePart = parts[0];
      timePart = parts[1].substring(0, 5);
    } else if (dateTimeString.contains(" ")) {
      List<String> parts = dateTimeString.split(' ');
      datePart = parts[0];
      timePart = parts[1].substring(0, 5);
    } else {
      // Fallback if format is unexpected
      datePart = dateTimeString;
      timePart = "00:00";
    }

    String heading =
        "$timePart - ${appointmentList[index].title.toUpperCase()}";
    String description = appointmentList[index].description;

    DateTime now = DateTime.now();
    int hourNow = int.parse(now.toString().split(' ')[1].substring(0, 2));
    String currentDate =
        DateTime(now.year, now.month, now.day).toString().split(' ')[0];

    int appointHour = int.parse(timePart.split(':')[0]);

    Color appointmentColor = MihColors.getSecondaryColor(
        MzansiInnovationHub.of(context)!.theme.mode == "Dark");

    if (currentDate == datePart) {
      if (appointHour < hourNow) {
        appointmentColor = MihColors.getGreyColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark");
      } else if (appointHour == hourNow) {
        appointmentColor = MihColors.getGreenColor(
            MzansiInnovationHub.of(context)!.theme.mode == "Dark");
      }
    } else if (DateTime.parse(datePart).isBefore(DateTime.parse(currentDate))) {
      appointmentColor = MihColors.getGreyColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark");
    }

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            width: 3.0,
            color: appointmentColor,
          ),
          borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        title: Text(
          heading,
          style: TextStyle(
            color: appointmentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: appointmentColor,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        onTap: () {
          // SAFELY SET CONTROLLER VALUES
          setState(() {
            widget.titleController.text = appointmentList[index].title;
            widget.descriptionIDController.text =
                appointmentList[index].description;
            widget.dateController.text = datePart;
            widget.timeController.text = timePart;
          });

          if (widget.inWaitingRoom == false) {
            appointmentDetailsWindow(
                mzansiProfileProvider, mihCalendarProvider, index, bodyWidth);
          } else {
            waitingRoomAppointmentDetailsWindow(
                mzansiProfileProvider, mihCalendarProvider, index, bodyWidth);
          }
        },
      ),
    );
  }

  void appointmentDetailsWindow(MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider, int index, double bodyWidth) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Appointment Details",
          menuOptions: [
            SpeedDialChild(
              child: Icon(
                Icons.edit,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              label: "Edit Appointment",
              labelBackgroundColor: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              labelStyle: TextStyle(
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              onTap: () {
                appointmentUpdateWindow(mzansiProfileProvider,
                    mihCalendarProvider, index, bodyWidth);
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.delete,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              label: "Delete Appointment",
              labelBackgroundColor: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              labelStyle: TextStyle(
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              onTap: () {
                deleteAppointmentConfirmationWindow(
                    mzansiProfileProvider, mihCalendarProvider, index);
              },
            ),
          ],
          onWindowTapClose: () {
            context.pop();
            clearControllers();
          },
          windowBody: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.05)
                    : const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  controller: widget.titleController,
                  multiLineInput: false,
                  requiredText: true,
                  readOnly: true,
                  hintText: "Appointment Title",
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  controller: widget.dateController,
                  multiLineInput: false,
                  requiredText: true,
                  readOnly: true,
                  hintText: "Date",
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  controller: widget.timeController,
                  multiLineInput: false,
                  requiredText: true,
                  readOnly: true,
                  hintText: "Time",
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  controller: widget.descriptionIDController,
                  multiLineInput: true,
                  height: 250,
                  requiredText: true,
                  readOnly: true,
                  hintText: "Appointment Description",
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void waitingRoomAppointmentDetailsWindow(
      MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider,
      int index,
      double bodyWidth) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Appointment Details",
          menuOptions: [
            SpeedDialChild(
              child: Icon(
                Icons.edit,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              label: "Edit Appointment",
              labelBackgroundColor: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              labelStyle: TextStyle(
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              onTap: () {
                appointmentUpdateWindow(mzansiProfileProvider,
                    mihCalendarProvider, index, bodyWidth);
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.delete,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              label: "Delete Appointment",
              labelBackgroundColor: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              labelStyle: TextStyle(
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: MihColors.getGreenColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              onTap: () {
                deleteAppointmentConfirmationWindow(
                    mzansiProfileProvider, mihCalendarProvider, index);
              },
            ),
          ],
          onWindowTapClose: () {
            context.pop();
            clearControllers();
          },
          windowBody: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.05)
                    : const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  controller: widget.titleController,
                  multiLineInput: false,
                  requiredText: true,
                  readOnly: true,
                  hintText: "Appointment Title",
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  controller: widget.dateController,
                  multiLineInput: false,
                  requiredText: true,
                  readOnly: true,
                  hintText: "Date",
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  controller: widget.timeController,
                  multiLineInput: false,
                  requiredText: true,
                  readOnly: true,
                  hintText: "Time",
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  controller: widget.descriptionIDController,
                  multiLineInput: true,
                  height: 250,
                  requiredText: true,
                  readOnly: true,
                  hintText: "Appointment Description",
                ),
                const SizedBox(height: 10),
                // SizedBox(
                //   // width: 500,
                //   child: MIHTextField(
                //     controller: widget.titleController,
                //     hintText: "Patient ID Number",
                //     editable: false,
                //     required: false,
                //   ),
                // ),
                // const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  void appointmentUpdateWindow(MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider, int index, double bodyWidth) {
    List<Appointment> appointmentList = mzansiProfileProvider.personalHome
        ? mihCalendarProvider.personalAppointments!
        : mihCalendarProvider.businessAppointments!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Update Appointment",
          onWindowTapClose: () {
            setState(() {
              widget.titleController.text = appointmentList[index].title;
              widget.descriptionIDController.text =
                  appointmentList[index].description;
              widget.dateController.text =
                  appointmentList[index].date_time.split('T')[0];
              widget.timeController.text = appointmentList[index]
                  .date_time
                  .split('T')[1]
                  .substring(0, 5);
            });
            context.pop();
          },
          windowBody: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.05)
                    : const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                MihForm(
                  formKey: _formKey,
                  formFields: [
                    MihTextFormField(
                      fillColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      inputColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      controller: widget.titleController,
                      multiLineInput: false,
                      requiredText: true,
                      hintText: "Appointment Title",
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    MihDateField(
                      controller: widget.dateController,
                      labelText: "Date",
                      required: true,
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    MihTimeField(
                      controller: widget.timeController,
                      labelText: "Time",
                      required: true,
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    MihTextFormField(
                      fillColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      inputColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      controller: widget.descriptionIDController,
                      multiLineInput: true,
                      height: 250,
                      requiredText: true,
                      hintText: "Appointment Description",
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          MihButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                updateAppointmentCall(mzansiProfileProvider,
                                    mihCalendarProvider, index);
                              } else {
                                MihAlertServices().inputErrorMessage(context);
                              }
                            },
                            buttonColor: MihColors.getGreenColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            width: 300,
                            child: Text(
                              "Update",
                              style: TextStyle(
                                color: MihColors.getPrimaryColor(
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
                                        "Dark"),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isAppointmentInputValid() {
    if (widget.dateController.text.isEmpty ||
        widget.timeController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void deleteAppointmentConfirmationWindow(
      MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider,
      int index) {
    MihAlertServices().deleteConfirmationMessage(
      "This appointment will be deleted permanently from your calendar. Are you certain you want to delete it?",
      () {
        deleteAppointmentCall(
            mzansiProfileProvider, mihCalendarProvider, index);
      },
      context,
    );
  }

  Future<void> updateAppointmentCall(
      MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider,
      int index) async {
    int statusCode;
    if (isAppointmentInputValid()) {
      List<Appointment> appointmentList = mzansiProfileProvider.personalHome
          ? mihCalendarProvider.personalAppointments!
          : mihCalendarProvider.businessAppointments!;
      KenLogger.success("ersonalHome: ${mzansiProfileProvider.personalHome}");
      if (mzansiProfileProvider.personalHome == true) {
        statusCode = await MihMzansiCalendarApis.updatePersonalAppointment(
          mzansiProfileProvider.user!,
          mzansiProfileProvider.business,
          null,
          appointmentList[index].idappointments,
          widget.titleController.text,
          widget.descriptionIDController.text,
          widget.dateController.text,
          widget.timeController.text,
          mihCalendarProvider,
          context,
        );
      } else if (mzansiProfileProvider.personalHome == false &&
          widget.inWaitingRoom == false) {
        statusCode = await MihMzansiCalendarApis.updateBusinessAppointment(
          mzansiProfileProvider.user!,
          mzansiProfileProvider.business,
          mzansiProfileProvider.businessUser,
          appointmentList[index].idappointments,
          widget.titleController.text,
          widget.descriptionIDController.text,
          widget.dateController.text,
          widget.timeController.text,
          mihCalendarProvider,
          context,
        );
      } else {
        statusCode = await MihMzansiCalendarApis.updatePatientAppointment(
          mzansiProfileProvider.user!,
          mzansiProfileProvider.business,
          mzansiProfileProvider.businessUser,
          appointmentList[index].idappointments,
          widget.titleController.text,
          widget.descriptionIDController.text,
          widget.dateController.text,
          widget.timeController.text,
          context,
        );
      }
      if (statusCode == 200) {
        context.pop();
        context.pop();
        successPopUp("Successfully Updated Appointment",
            "You appointment has been successfully updated.");
      } else {
        MihAlertServices().internetConnectionLost(context);
      }
    } else {
      MihAlertServices().inputErrorMessage(context);
    }
  }

  Future<void> deleteAppointmentCall(
      MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider,
      int index) async {
    List<Appointment> appointmentList = mzansiProfileProvider.personalHome
        ? mihCalendarProvider.personalAppointments!
        : mihCalendarProvider.businessAppointments!;
    int statucCode = await MihMzansiCalendarApis.deleteAppointmentAPICall(
      mzansiProfileProvider.user!,
      mzansiProfileProvider.personalHome,
      mzansiProfileProvider.business,
      mzansiProfileProvider.businessUser,
      widget.inWaitingRoom,
      appointmentList[index].idappointments,
      mihCalendarProvider,
      context,
    );
    if (statucCode == 200) {
      context.pop();
      context.pop();
      successPopUp("Successfully Deleted Appointment",
          "You appointment has been successfully deleted from your calendar.");
    } else {
      MihAlertServices().internetConnectionLost(context);
    }
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
                    clearControllers();
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

  bool canEditAppointment(MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider, int index) {
    List<Appointment> appointmentList = mzansiProfileProvider.personalHome
        ? mihCalendarProvider.personalAppointments!
        : mihCalendarProvider.businessAppointments!;
    if (mzansiProfileProvider.personalHome == true &&
        appointmentList[index].app_id == mzansiProfileProvider.user!.app_id &&
        appointmentList[index].business_id == "") {
      return true;
    } else if (mzansiProfileProvider.personalHome == false &&
        appointmentList[index].business_id ==
            mzansiProfileProvider.business!.business_id &&
        appointmentList[index].app_id.isEmpty) {
      return true;
    } else if (mzansiProfileProvider.personalHome == false &&
        appointmentList[index].business_id ==
            mzansiProfileProvider.business!.business_id &&
        appointmentList[index].app_id.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void dispose() {
    daysExtensionController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    setState(() {
      width = size.width;
      height = size.height;
    });
    return Consumer2<MzansiProfileProvider, MihCalendarProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider,
          MihCalendarProvider mihCalendarProvider,
          Widget? child) {
        // List<Appointment> appointmentList = mzansiProfileProvider.personalHome
        //     ? mihCalendarProvider.personalAppointments!
        //     : mihCalendarProvider.businessAppointments!;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: getPaddingSize()),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: mzansiProfileProvider.personalHome
                ? mihCalendarProvider.personalAppointments!.length
                : mihCalendarProvider.businessAppointments!.length,
            itemBuilder: (context, index) {
              return displayAppointment(
                  mzansiProfileProvider, mihCalendarProvider, index, width);
            },
          ),
        );
      },
    );
  }
}
