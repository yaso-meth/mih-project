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
import 'package:uuid/uuid.dart';

class MihAppointmentAddWindow extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionIDController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  const MihAppointmentAddWindow({
    super.key,
    required this.titleController,
    required this.descriptionIDController,
    required this.dateController,
    required this.timeController,
  });

  @override
  State<MihAppointmentAddWindow> createState() =>
      _MihAppointmentAddWindowState();
}

class _MihAppointmentAddWindowState extends State<MihAppointmentAddWindow> {
  final _formKey = GlobalKey<FormState>();

  bool isAppointmentInputValid() {
    if (widget.titleController.text.isEmpty ||
        widget.descriptionIDController.text.isEmpty ||
        widget.dateController.text.isEmpty ||
        widget.timeController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> addAppointmentCall(
    MzansiProfileProvider mzansiProfileProvider,
    MihCalendarProvider mihCalendarProvider,
  ) async {
    if (isAppointmentInputValid()) {
      String offlineId = Uuid().v4();
      mihCalendarProvider.addNewAppointmentLocally(
        mzansiProfileProvider,
        Appointment(
          idappointments: 0,
          app_id: mzansiProfileProvider.personalHome
              ? mzansiProfileProvider.user!.app_id
              : '',
          business_id: !mzansiProfileProvider.personalHome
              ? mzansiProfileProvider.business!.business_id
              : '',
          date_time:
              "${widget.dateController.text} ${widget.timeController.text}",
          title: widget.titleController.text,
          description: widget.descriptionIDController.text,
          offline_id: offlineId,
        ),
      );
      successPopUp("Successfully Added Appointment",
          "You appointment has been successfully added to your calendar.");
    } else {
      MihAlertServices().inputErrorAlert(context);
    }
    // checkforchange();
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
              widget.dateController.clear();
              widget.timeController.clear();
              widget.titleController.clear();
              widget.descriptionIDController.clear();
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
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Add Appointment",
          onWindowTapClose: () {
            context.pop();
            widget.dateController.clear();
            widget.timeController.clear();
            widget.titleController.clear();
            widget.descriptionIDController.clear();
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
                      child: MihButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addAppointmentCall(
                              profileProvider,
                              calendarProvider,
                            );
                          } else {
                            MihAlertServices().inputErrorAlert(context);
                          }
                        },
                        buttonColor: MihColors.green(),
                        width: 300,
                        child: Text(
                          "Add",
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
        );
      },
    );
  }
}
