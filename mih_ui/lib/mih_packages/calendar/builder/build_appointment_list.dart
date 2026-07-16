import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/appointment.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/components/mih_appointment_details_window.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/components/mih_waiting_room_appointment_details_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
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
  int counter = 0;

  double getPaddingSize(double width) {
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

    Color appointmentColor = MihColors.highlight();

    if (currentDate == datePart) {
      if (appointHour < hourNow) {
        appointmentColor = MihColors.grey();
      } else if (appointHour == hourNow) {
        appointmentColor = MihColors.green();
      }
    } else if (DateTime.parse(datePart).isBefore(DateTime.parse(currentDate))) {
      appointmentColor = MihColors.grey();
    }

    return Material(
      color: appointmentColor,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        hoverColor: MihColors.secondary(),
        splashColor: Color.lerp(
          MihColors.bluishPurple(),
          Colors.black,
          0.01,
        ),
        title: Text(
          heading,
          style: TextStyle(
            color: MihColors.primary(),
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          description,
          style: TextStyle(
            color: MihColors.primary(),
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
        return MihAppointmentDetailsWindow(
          inWaitingRoom: widget.inWaitingRoom,
          titleController: widget.titleController,
          descriptionIDController: widget.descriptionIDController,
          patientIdController: widget.patientIdController,
          dateController: widget.dateController,
          timeController: widget.timeController,
          index: index,
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
        return MihWaitingRoomAppointmentDetailsWindow(
          inWaitingRoom: widget.inWaitingRoom,
          titleController: widget.titleController,
          descriptionIDController: widget.descriptionIDController,
          patientIdController: widget.patientIdController,
          dateController: widget.dateController,
          timeController: widget.timeController,
          index: index,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final width = size.width;
    return Consumer2<MzansiProfileProvider, MihCalendarProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider,
          MihCalendarProvider mihCalendarProvider,
          Widget? child) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: getPaddingSize(
              width,
            ),
          ),
          child: ListView.separated(
            itemCount: mzansiProfileProvider.personalHome
                ? mihCalendarProvider.personalAppointments!.length
                : mihCalendarProvider.businessAppointments!.length,
            itemBuilder: (context, index) {
              return displayAppointment(
                  mzansiProfileProvider, mihCalendarProvider, index, width);
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 3,
              );
            },
          ),
        );
      },
    );
  }
}
