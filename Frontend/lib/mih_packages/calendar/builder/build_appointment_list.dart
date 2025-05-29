import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_mzansi_calendar_apis.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_date_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_multiline_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_time_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_delete_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/appointment.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:flutter/material.dart';

class BuildAppointmentList extends StatefulWidget {
  final List<Appointment> appointmentList;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final bool personalSelected;
  final bool inWaitingRoom;
  final TextEditingController titleController;
  final TextEditingController descriptionIDController;
  final TextEditingController? patientIdController;
  final TextEditingController dateController;
  final TextEditingController timeController;

  const BuildAppointmentList({
    super.key,
    required this.appointmentList,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
    required this.personalSelected,
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
  int counter = 0;
  late double width;
  late double height;

  double getPaddingSize() {
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
      return (width / 10);
    } else {
      return 0.0;
    }
  }

  Widget displayAppointment(int index) {
    String heading =
        "${widget.appointmentList[index].date_time.split('T')[1].substring(0, 5)} - ${widget.appointmentList[index].title.toUpperCase()}";
    String description = widget.appointmentList[index].description;
    DateTime now = new DateTime.now();
    int hourNow = int.parse(now.toString().split(' ')[1].substring(0, 2));
    String date =
        new DateTime(now.year, now.month, now.day).toString().split(' ')[0];
    String appointDate = widget.appointmentList[index].date_time.split('T')[0];
    int appointHour = int.parse(
        widget.appointmentList[index].date_time.split('T')[1].substring(0, 2));
    // print("Date Time Now: $now");
    // print("Hour Now: $hourNow");
    // print("Date: $date");
    // print("Appointment Date: $appointDate");
    // print("Appointment Hour: $appointHour");
    Color appointmentColor =
        MzanziInnovationHub.of(context)!.theme.secondaryColor();
    if (date == appointDate) {
      if (appointHour < hourNow) {
        appointmentColor =
            MzanziInnovationHub.of(context)!.theme.messageTextColor();
      } else if (appointHour == hourNow) {
        appointmentColor =
            MzanziInnovationHub.of(context)!.theme.successColor();
      }
    } else if (DateTime.parse(appointDate).isBefore(DateTime.parse(date))) {
      appointmentColor =
          MzanziInnovationHub.of(context)!.theme.messageTextColor();
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
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
            setState(() {
              widget.titleController.text = widget.appointmentList[index].title;
              widget.descriptionIDController.text =
                  widget.appointmentList[index].description;
              widget.dateController.text =
                  widget.appointmentList[index].date_time.split('T')[0];
              widget.timeController.text = widget
                  .appointmentList[index].date_time
                  .split('T')[1]
                  .substring(0, 5);
            });
            if (widget.inWaitingRoom == false) {
              appointmentDetailsWindow(index);
            } else {
              waitingRiinAppointmentDetailsWindow(index);
            }
          },
        ),
      ),
    );
  }

  void appointmentDetailsWindow(int index) {
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
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              ),
              label: "Edit Appointment",
              labelBackgroundColor:
                  MzanziInnovationHub.of(context)!.theme.successColor(),
              labelStyle: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor:
                  MzanziInnovationHub.of(context)!.theme.successColor(),
              onTap: () {
                appointmentUpdateWindow(index);
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.delete,
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              ),
              label: "Delete Appointment",
              labelBackgroundColor:
                  MzanziInnovationHub.of(context)!.theme.successColor(),
              labelStyle: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor:
                  MzanziInnovationHub.of(context)!.theme.successColor(),
              onTap: () {
                deleteAppointmentConfirmationWindow(index);
              },
            ),
          ],
          onWindowTapClose: () {
            Navigator.of(context).pop();
            widget.dateController.clear();
            widget.timeController.clear();
            widget.titleController.clear();
            widget.descriptionIDController.clear();
          },
          windowBody: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                // width: 500,
                child: MIHTextField(
                  controller: widget.titleController,
                  hintText: "Title",
                  editable: false,
                  required: false,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  // width: 500,
                  child: MIHTextField(
                controller: widget.dateController,
                hintText: "Date",
                editable: false,
                required: false,
              )),
              const SizedBox(height: 10),
              SizedBox(
                  // width: 500,
                  child: MIHTextField(
                controller: widget.timeController,
                hintText: "Time",
                editable: false,
                required: false,
              )),
              const SizedBox(height: 10),
              SizedBox(
                // width: 500,
                height: 250,
                child: MIHMLTextField(
                  controller: widget.descriptionIDController,
                  hintText: "Description",
                  editable: false,
                  required: false,
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void waitingRiinAppointmentDetailsWindow(int index) {
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
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              ),
              label: "Edit Appointment",
              labelBackgroundColor:
                  MzanziInnovationHub.of(context)!.theme.successColor(),
              labelStyle: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor:
                  MzanziInnovationHub.of(context)!.theme.successColor(),
              onTap: () {
                appointmentUpdateWindow(index);
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.delete,
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              ),
              label: "Delete Appointment",
              labelBackgroundColor:
                  MzanziInnovationHub.of(context)!.theme.successColor(),
              labelStyle: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor:
                  MzanziInnovationHub.of(context)!.theme.successColor(),
              onTap: () {
                deleteAppointmentConfirmationWindow(index);
              },
            ),
          ],
          onWindowTapClose: () {
            Navigator.of(context).pop();
            widget.dateController.clear();
            widget.timeController.clear();
            widget.titleController.clear();
            widget.descriptionIDController.clear();
          },
          windowBody: Column(
            children: [
              SizedBox(
                // width: 500,
                child: MIHTextField(
                  controller: widget.titleController,
                  hintText: "Title",
                  editable: false,
                  required: false,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                // width: 500,
                child: MIHTextField(
                  controller: widget.titleController,
                  hintText: "Patient ID Number",
                  editable: false,
                  required: false,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  // width: 500,
                  child: MIHTextField(
                controller: widget.dateController,
                hintText: "Date",
                editable: false,
                required: false,
              )),
              const SizedBox(height: 10),
              SizedBox(
                  // width: 500,
                  child: MIHTextField(
                controller: widget.timeController,
                hintText: "Time",
                editable: false,
                required: false,
              )),
              const SizedBox(height: 10),
              SizedBox(
                // width: 500,
                height: 250,
                child: MIHMLTextField(
                  controller: widget.descriptionIDController,
                  hintText: "Description",
                  editable: false,
                  required: false,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void appointmentUpdateWindow(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Update Appointment",
          onWindowTapClose: () {
            setState(() {
              widget.titleController.text = widget.appointmentList[index].title;
              widget.descriptionIDController.text =
                  widget.appointmentList[index].description;
              widget.dateController.text =
                  widget.appointmentList[index].date_time.split('T')[0];
              widget.timeController.text = widget
                  .appointmentList[index].date_time
                  .split('T')[1]
                  .substring(0, 5);
            });
            Navigator.of(context).pop();
          },
          windowBody: Column(
            children: [
              SizedBox(
                // width: 500,
                child: MIHTextField(
                  controller: widget.titleController,
                  hintText: "Title",
                  editable: true,
                  required: true,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                // width: 500,
                child: MIHDateField(
                  controller: widget.dateController,
                  lableText: "Date",
                  required: true,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                // width: 500,
                child: MIHTimeField(
                  controller: widget.timeController,
                  lableText: "Time",
                  required: true,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                // width: 500,
                height: 250,
                child: MIHMLTextField(
                  controller: widget.descriptionIDController,
                  hintText: "Description",
                  editable: true,
                  required: true,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                runSpacing: 10,
                spacing: 10,
                children: [
                  MihButton(
                    onPressed: () {
                      updateAppointmentCall(index);
                    },
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.successColor(),
                    width: 300,
                    child: Text(
                      "Update",
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
              )
            ],
          ),
        );
      },
    );
  }

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

  void deleteAppointmentConfirmationWindow(int index) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MIHDeleteMessage(
            deleteType: "Appointment",
            onTap: () {
              deleteAppointmentCall(index);
            });
      },
    );
  }

  void updateAppointmentCall(int index) {
    if (isAppointmentInputValid()) {
      if (widget.personalSelected == true) {
        MihMzansiCalendarApis.updatePersonalAppointment(
          widget.signedInUser,
          widget.business,
          null,
          widget.appointmentList[index].idappointments,
          widget.titleController.text,
          widget.descriptionIDController.text,
          widget.dateController.text,
          widget.timeController.text,
          context,
        );
      } else if (widget.personalSelected == false &&
          widget.inWaitingRoom == false) {
        MihMzansiCalendarApis.updateBusinessAppointment(
          widget.signedInUser,
          widget.business,
          widget.businessUser,
          widget.appointmentList[index].idappointments,
          widget.titleController.text,
          widget.descriptionIDController.text,
          widget.dateController.text,
          widget.timeController.text,
          context,
        );
      } else {
        MihMzansiCalendarApis.updatePatientAppointment(
          widget.signedInUser,
          widget.business,
          widget.businessUser,
          widget.appointmentList[index].idappointments,
          widget.titleController.text,
          widget.descriptionIDController.text,
          widget.dateController.text,
          widget.timeController.text,
          context,
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    }
  }

  void deleteAppointmentCall(int index) {
    print("personal selected: ${widget.personalSelected}");
    MihMzansiCalendarApis.deleteAppointmentAPICall(
      widget.signedInUser,
      widget.personalSelected,
      widget.business,
      widget.businessUser,
      widget.inWaitingRoom,
      widget.appointmentList[index].idappointments,
      context,
    );
  }

  bool canEditAppointment(int index) {
    if (widget.personalSelected == true &&
        widget.appointmentList[index].app_id == widget.signedInUser.app_id &&
        widget.appointmentList[index].business_id == "") {
      return true;
    } else if (widget.personalSelected == false &&
        widget.appointmentList[index].business_id ==
            widget.business!.business_id &&
        widget.appointmentList[index].app_id.isEmpty) {
      return true;
    } else if (widget.personalSelected == false &&
        widget.appointmentList[index].business_id ==
            widget.business!.business_id &&
        widget.appointmentList[index].app_id.isNotEmpty) {
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getPaddingSize()),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.appointmentList.length,
        itemBuilder: (context, index) {
          return displayAppointment(index);
        },
      ),
    );
  }
}
