import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/appointment.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MihAppointmentUpdateWindow extends StatefulWidget {
  final bool inWaitingRoom;
  final TextEditingController titleController;
  final TextEditingController descriptionIDController;
  final TextEditingController? patientIdController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final int index;
  const MihAppointmentUpdateWindow({
    super.key,
    required this.inWaitingRoom,
    required this.titleController,
    required this.descriptionIDController,
    required this.patientIdController,
    required this.dateController,
    required this.timeController,
    required this.index,
  });

  @override
  State<MihAppointmentUpdateWindow> createState() =>
      _MihAppointmentUpdateWindowState();
}

class _MihAppointmentUpdateWindowState
    extends State<MihAppointmentUpdateWindow> {
  final _formKey = GlobalKey<FormState>();

  bool isAppointmentInputValid() {
    if (widget.dateController.text.isEmpty ||
        widget.timeController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void clearControllers() {
    widget.titleController.clear();
    widget.descriptionIDController.clear();
    widget.dateController.clear();
    widget.timeController.clear();
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
            context.pop();
            clearControllers();
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

  Future<void> updateAppointmentCall(
      MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider,
      int index) async {
    if (isAppointmentInputValid()) {
      List<Appointment> appointmentList = mzansiProfileProvider.personalHome
          ? mihCalendarProvider.personalAppointments!
          : mihCalendarProvider.businessAppointments!;
      await mihCalendarProvider.updateAppointmentLocally(
        mzansiProfileProvider,
        Appointment(
          idappointments: appointmentList[index].idappointments,
          app_id: appointmentList[index].app_id,
          business_id: appointmentList[index].business_id,
          date_time:
              "${widget.dateController.text} ${widget.timeController.text}",
          title: widget.titleController.text,
          description: widget.descriptionIDController.text,
          offline_id: appointmentList[index].offline_id,
        ),
      );
      successPopUp("Successfully Updated Appointment",
          "You appointment has been successfully updated.");
    } else {
      MihAlertServices().inputErrorAlert(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer2<MzansiProfileProvider, MihCalendarProvider>(
      builder: (
        BuildContext context,
        MzansiProfileProvider profileProvider,
        MihCalendarProvider calendarProvider,
        Widget? child,
      ) {
        List<Appointment> appointmentList = profileProvider.personalHome
            ? calendarProvider.personalAppointments!
            : calendarProvider.businessAppointments!;
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Update Appointment",
          onWindowTapClose: () {
            widget.titleController.text = appointmentList[widget.index].title;
            widget.descriptionIDController.text =
                appointmentList[widget.index].description;
            widget.dateController.text =
                appointmentList[widget.index].date_time.split(' ')[0];
            widget.timeController.text = appointmentList[widget.index]
                .date_time
                .split(' ')[1]
                .substring(0, 5);
            context.pop();
          },
          windowBody: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: size.width * 0.05)
                    : const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                MihForm(
                  formKey: _formKey,
                  formFields: [
                    MihTextFormField(
                      fillColor: MihColors.secondary(),
                      inputColor: MihColors.primary(),
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
                      fillColor: MihColors.secondary(),
                      inputColor: MihColors.primary(),
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
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        alignment: WrapAlignment.center,
                        runSpacing: 10,
                        spacing: 10,
                        children: [
                          MihButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                updateAppointmentCall(profileProvider,
                                    calendarProvider, widget.index);
                              } else {
                                MihAlertServices().inputErrorAlert(context);
                              }
                            },
                            buttonColor: MihColors.green(),
                            width: 300,
                            child: Text(
                              "Update",
                              style: TextStyle(
                                color: MihColors.primary(),
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
}
