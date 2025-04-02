import 'package:Mzansi_Innovation_Hub/mih_apis/mih_mzansi_calendar_apis.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_date_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_multiline_text_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_time_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_window.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package_components/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/appointment.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/business_user.dart';
import 'package:Mzansi_Innovation_Hub/mih_packages/calendar/builder/build_appointment_list.dart';
import 'package:flutter/material.dart';
import '../../../main.dart';

import '../../../mih_components/mih_calendar.dart';
import '../../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../../mih_env/env.dart';
import '../../../mih_objects/app_user.dart';

class Appointments extends StatefulWidget {
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final bool personalSelected;

  const Appointments({
    super.key,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
    required this.personalSelected,
  });

  @override
  State<Appointments> createState() => _PatientAccessRequestState();
}

class _PatientAccessRequestState extends State<Appointments> {
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
  String baseUrl = AppEnviroment.baseApiUrl;

  String selectedDay = DateTime.now().toString().split(" ")[0];

  late Future<List<Appointment>> personalAppointmentResults;
  late Future<List<Appointment>> businessAppointmentResults;
  late Future<List<Appointment>> appointmentResults;

  Widget displayAppointmentList(List<Appointment> appointmentList) {
    if (appointmentList.isNotEmpty) {
      return Expanded(
        child: BuildAppointmentList(
          appointmentList: appointmentList,
          signedInUser: widget.signedInUser,
          business: widget.business,
          businessUser: widget.businessUser,
          personalSelected: widget.personalSelected,
          inWaitingRoom: false,
          titleController: _appointmentTitleController,
          descriptionIDController: _appointmentDescriptionIDController,
          patientIdController: null,
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

  void addAppointmentCall() {
    if (isAppointmentInputValid()) {
      if (widget.personalSelected == false) {
        MihMzansiCalendarApis.addBusinessAppointment(
          widget.signedInUser,
          widget.business!,
          widget.businessUser!,
          false,
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

  String getTitle() {
    if (widget.personalSelected == false) {
      return "Business Appointments";
    } else {
      return "Personal Appointments";
    }
  }

  void checkforchange() {
    setState(() {
      if (widget.personalSelected == false) {
        appointmentResults = MihMzansiCalendarApis.getBusinessAppointments(
          widget.business!.business_id,
          false,
          selectedDay,
        );
      } else {
        appointmentResults = MihMzansiCalendarApis.getPersonalAppointments(
          widget.signedInUser.app_id,
          selectedDay,
        );
      }
    });
  }

  Widget getBody() {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Column(
            children: [
              Text(
                getTitle(),
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
                          return displayAppointmentList(snapshot.requireData);
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
                  addAppointmentWindow();
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
      if (widget.personalSelected == false) {
        appointmentResults = MihMzansiCalendarApis.getBusinessAppointments(
          widget.business!.business_id,
          false,
          selectedDay,
        );
      } else {
        appointmentResults = MihMzansiCalendarApis.getPersonalAppointments(
          widget.signedInUser.app_id,
          selectedDay,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }
}
