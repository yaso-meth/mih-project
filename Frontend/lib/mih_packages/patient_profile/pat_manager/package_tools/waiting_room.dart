import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_apis/mih_mzansi_calendar_apis.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_calendar.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_date_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_multiline_text_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_time_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_window.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:Mzansi_Innovation_Hub/mih_env/env.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/app_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/appointment.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/calendar/builder/build_appointment_list.dart';
import 'package:flutter/material.dart';

class WaitingRoom extends StatefulWidget {
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final bool personalSelected;
  final Function(int) onIndexChange;
  const WaitingRoom({
    super.key,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
    required this.personalSelected,
    required this.onIndexChange,
  });

  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> {
  TextEditingController selectedAppointmentDateController =
      TextEditingController();
  final TextEditingController _appointmentTitleController =
      TextEditingController();
  final TextEditingController _appointmentDescriptionIDController =
      TextEditingController();
  final TextEditingController _appointmentDateController =
      TextEditingController();
  final TextEditingController _appointmentTimeController =
      TextEditingController();
  final TextEditingController _patientController = TextEditingController();
  String baseUrl = AppEnviroment.baseApiUrl;

  String selectedDay = DateTime.now().toString().split(" ")[0];

  late Future<List<Appointment>> businessAppointmentResults;
  late Future<List<Appointment>> appointmentResults;
  bool inWaitingRoom = true;

  // Business Appointment Tool
  Widget getBusinessAppointmentsTool() {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Column(
            children: [
              const Text(
                "Waiting Room",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              MIHCalendar(
                  calendarWidth: 500,
                  rowHeight: 35,
                  setDate: (value) {
                    setState(() {
                      selectedDay = value;
                      selectedAppointmentDateController.text = selectedDay;
                    });
                  }),
              // Divider(
              //   color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              // ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  FutureBuilder(
                      future: appointmentResults,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Expanded(
                              child: Center(child: Mihloadingcircle()));
                        } else if (snapshot.connectionState ==
                                ConnectionState.done &&
                            snapshot.hasData) {
                          return
                              // Container(child: const Placeholder());
                              displayAppointmentList(snapshot.requireData);
                        } else {
                          return Center(
                            child: Text(
                              "Error pulling appointments",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: MzanziInnovationHub.of(context)!
                                      .theme
                                      .errorColor()),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                      }),
                ],
              )
            ],
          ),
        ),
        Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
              child: IconButton(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                onPressed: () {
                  appointmentTypeSelection();
                },
                icon: const Icon(
                  Icons.add,
                  size: 50,
                ),
              ),
            ))
      ],
    );
  }

  Widget displayAppointmentList(List<Appointment> appointmentList) {
    if (appointmentList.isNotEmpty) {
      return Expanded(
        child: BuildAppointmentList(
          appointmentList: appointmentList,
          signedInUser: widget.signedInUser,
          business: widget.business,
          businessUser: widget.businessUser,
          personalSelected: widget.personalSelected,
          inWaitingRoom: true,
          titleController: _appointmentTitleController,
          descriptionIDController: _appointmentDescriptionIDController,
          patientIdController: _patientController,
          dateController: _appointmentDateController,
          timeController: _appointmentTimeController,
        ),
      );
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            "No Appointments for $selectedDay",
            style: TextStyle(
              fontSize: 25,
              color: MzanziInnovationHub.of(context)!.theme.messageTextColor(),
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      ),
    );
  }

  void appointmentTypeSelection() {
    String question = "What type of appointment would you like to add?";
    question +=
        "\n\nExisting Patient: Add an appointment for an patient your practice has access to.";
    question +=
        "\nExisting MIH User: Add an appointment for an existing MIH user your practice does not have access to.";
    question +=
        "\nSkeleton Appointment: Add an appointment without a patient linked.";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MIHWindow(
          fullscreen: false,
          windowTitle: "Appointment Type",
          windowTools: [],
          onWindowTapClose: () {
            Navigator.of(context).pop();
          },
          windowBody: [
            Text(
              question,
              style: TextStyle(
                  fontSize: 20,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor()),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: 500,
              height: 50,
              child: MIHButton(
                onTap: () {
                  widget.onIndexChange(1);
                  Navigator.of(context).pop();
                },
                buttonText: "Existing Patient",
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                textColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 500,
              height: 50,
              child: MIHButton(
                onTap: () {
                  widget.onIndexChange(2);
                  Navigator.of(context).pop();
                },
                buttonText: "Existing MIH User",
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                textColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 500,
              height: 50,
              child: MIHButton(
                onTap: () {
                  Navigator.pop(context);
                  addAppointmentWindow();
                },
                buttonText: "Skeleton Appointment",
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                textColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
              ),
            ),
          ],
        );
      },
    );
  }

  void addAppointmentWindow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MIHWindow(
          fullscreen: false,
          windowTitle: "Add Appointment",
          windowTools: [],
          onWindowTapClose: () {
            Navigator.of(context).pop();
            _appointmentDateController.clear();
            _appointmentTimeController.clear();
            _appointmentTitleController.clear();
            _appointmentDescriptionIDController.clear();
            _patientController.clear();
          },
          windowBody: [
            SizedBox(
              // width: 500,
              child: MIHTextField(
                controller: _appointmentTitleController,
                hintText: "Title",
                editable: true,
                required: true,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              // width: 500,
              child: MIHDateField(
                controller: _appointmentDateController,
                lableText: "Date",
                required: true,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              // width: 500,
              child: MIHTimeField(
                controller: _appointmentTimeController,
                lableText: "Time",
                required: true,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              // width: 500,
              height: 250,
              child: MIHMLTextField(
                controller: _appointmentDescriptionIDController,
                hintText: "Description",
                editable: true,
                required: true,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 500,
              height: 50,
              child: MIHButton(
                onTap: () {
                  addAppointmentCall();
                },
                buttonText: "Add",
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                textColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
              ),
            ),
          ],
        );
      },
    );
  }

  void addAppointmentCall() {
    if (isAppointmentInputValid()) {
      if (widget.personalSelected == false) {
        MihMzansiCalendarApis.addBusinessAppointment(
          widget.signedInUser,
          widget.business!,
          widget.businessUser!,
          true,
          _appointmentTitleController.text,
          _appointmentDescriptionIDController.text,
          _appointmentDateController.text,
          _appointmentTimeController.text,
          context,
        );
      } else {
        MihMzansiCalendarApis.addPersonalAppointment(
          widget.signedInUser,
          _appointmentTitleController.text,
          _appointmentDescriptionIDController.text,
          _appointmentDateController.text,
          _appointmentTimeController.text,
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
    checkforchange();
  }

  bool isAppointmentInputValid() {
    if (_appointmentTitleController.text.isEmpty ||
        _appointmentDescriptionIDController.text.isEmpty ||
        _appointmentDateController.text.isEmpty ||
        _appointmentTimeController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void checkforchange() {
    setState(() {
      appointmentResults = MihMzansiCalendarApis.getBusinessAppointments(
        widget.business!.business_id,
        true,
        selectedDay,
      );
    });
  }

  @override
  void dispose() {
    selectedAppointmentDateController.dispose();
    _appointmentDateController.dispose();
    _appointmentTimeController.dispose();
    _appointmentTitleController.dispose();
    _appointmentDescriptionIDController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    selectedAppointmentDateController.addListener(checkforchange);
    setState(() {
      appointmentResults = MihMzansiCalendarApis.getBusinessAppointments(
        widget.business!.business_id,
        true,
        selectedDay,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBusinessAppointmentsTool(),
    );
  }
}
