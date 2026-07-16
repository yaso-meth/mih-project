import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/appointment.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/components/mih_appointment_update_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:provider/provider.dart';

class MihAppointmentDetailsWindow extends StatefulWidget {
  final bool inWaitingRoom;
  final TextEditingController titleController;
  final TextEditingController descriptionIDController;
  final TextEditingController? patientIdController;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final int index;
  const MihAppointmentDetailsWindow({
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
  State<MihAppointmentDetailsWindow> createState() =>
      _MihAppointmentDetailsWindowState();
}

class _MihAppointmentDetailsWindowState
    extends State<MihAppointmentDetailsWindow> {
  void clearControllers() {
    widget.titleController.clear();
    widget.descriptionIDController.clear();
    widget.dateController.clear();
    widget.timeController.clear();
  }

  void appointmentUpdateWindow(int index, double bodyWidth) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return MihAppointmentUpdateWindow(
            inWaitingRoom: widget.inWaitingRoom,
            titleController: widget.titleController,
            descriptionIDController: widget.descriptionIDController,
            patientIdController: widget.patientIdController,
            dateController: widget.dateController,
            timeController: widget.timeController,
            index: widget.index,
          );
        });
  }

  void deleteAppointmentConfirmationWindow(
      MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider,
      int index) {
    MihAlertServices().deleteConfirmationAlert(
      "This appointment will be deleted permanently from your calendar. Are you certain you want to delete it?",
      () {
        deleteAppointmentCall(
            mzansiProfileProvider, mihCalendarProvider, index);
      },
      context,
    );
  }

  Future<void> deleteAppointmentCall(
      MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider,
      int index) async {
    List<Appointment> appointmentList = mzansiProfileProvider.personalHome
        ? mihCalendarProvider.personalAppointments!
        : mihCalendarProvider.businessAppointments!;
    await mihCalendarProvider.deleteAppointmentLocally(
      mzansiProfileProvider,
      appointmentList[index],
    );
    context.pop();
    context.pop();
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
          windowTitle: "Appointment Details",
          menuOptions: [
            SpeedDialChild(
              child: Icon(
                Icons.edit,
                color: MihColors.primary(),
              ),
              label: "Edit Appointment",
              labelBackgroundColor: MihColors.green(),
              labelStyle: TextStyle(
                color: MihColors.primary(),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: MihColors.green(),
              onTap: () {
                appointmentUpdateWindow(
                  widget.index,
                  size.width,
                );
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.delete,
                color: MihColors.primary(),
              ),
              label: "Delete Appointment",
              labelBackgroundColor: MihColors.green(),
              labelStyle: TextStyle(
                color: MihColors.primary(),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: MihColors.green(),
              onTap: () {
                deleteAppointmentConfirmationWindow(
                  profileProvider,
                  calendarProvider,
                  widget.index,
                );
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
                    ? EdgeInsets.symmetric(horizontal: size.width * 0.05)
                    : const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.secondary(),
                  inputColor: MihColors.primary(),
                  controller: widget.titleController,
                  multiLineInput: false,
                  requiredText: true,
                  readOnly: true,
                  hintText: "Appointment Title",
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.secondary(),
                  inputColor: MihColors.primary(),
                  controller: widget.dateController,
                  multiLineInput: false,
                  requiredText: true,
                  readOnly: true,
                  hintText: "Date",
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.secondary(),
                  inputColor: MihColors.primary(),
                  controller: widget.timeController,
                  multiLineInput: false,
                  requiredText: true,
                  readOnly: true,
                  hintText: "Time",
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor: MihColors.secondary(),
                  inputColor: MihColors.primary(),
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
}
