import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_calendar_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_calendar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_date_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_time_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/appointment.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/builder/build_appointment_list.dart';
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
  final _formKey = GlobalKey<FormState>();

  // Business Appointment Tool
  Widget getBusinessAppointmentsTool(double width) {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Column(
            children: [
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
          right: 10,
          bottom: 10,
          child: MihFloatingMenu(
            icon: Icons.add,
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                child: Icon(
                  Icons.add,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
                label: "Add Appointment",
                labelBackgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                labelStyle: TextStyle(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                onTap: () {
                  // addAppointmentWindow();
                  appointmentTypeSelection(width);
                },
              )
            ],
          ),
        ),
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

  void appointmentTypeSelection(double width) {
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
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Appointment Type",
          onWindowTapClose: () {
            Navigator.of(context).pop();
          },
          windowBody: Column(
            children: [
              Text(
                question,
                style: TextStyle(
                    fontSize: 20,
                    color: MzanziInnovationHub.of(context)!
                        .theme
                        .secondaryColor()),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 15),
              MihButton(
                onPressed: () {
                  widget.onIndexChange(1);
                  Navigator.of(context).pop();
                },
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                width: 300,
                child: Text(
                  "Existing Patient",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              MihButton(
                onPressed: () {
                  widget.onIndexChange(2);
                  Navigator.of(context).pop();
                },
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                width: 300,
                child: Text(
                  "Existing MIH User",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              MihButton(
                onPressed: () {
                  Navigator.pop(context);
                  addAppointmentWindow(width);
                },
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                width: 300,
                child: Text(
                  "Skeleton Appointment",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void addAppointmentWindow(double width) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Add Appointment",
          onWindowTapClose: () {
            Navigator.of(context).pop();
            _appointmentDateController.clear();
            _appointmentTimeController.clear();
            _appointmentTitleController.clear();
            _appointmentDescriptionIDController.clear();
            _patientController.clear();
          },
          windowBody: Padding(
            padding:
                MzanziInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.05)
                    : const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                MihForm(
                  formKey: _formKey,
                  formFields: [
                    MihTextFormField(
                      fillColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      inputColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                      controller: _appointmentTitleController,
                      multiLineInput: false,
                      requiredText: true,
                      hintText: "Appointment Title",
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    MihDateField(
                      controller: _appointmentDateController,
                      labelText: "Date",
                      required: true,
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    MihTimeField(
                      controller: _appointmentTimeController,
                      labelText: "Time",
                      required: true,
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    MihTextFormField(
                      height: 250,
                      fillColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      inputColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                      controller: _appointmentDescriptionIDController,
                      multiLineInput: true,
                      requiredText: true,
                      hintText: "Description",
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: MihButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addAppointmentCall();
                          } else {
                            MihAlertServices().formNotFilledCompletely(context);
                          }
                        },
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .successColor(),
                        width: 300,
                        child: Text(
                          "Add",
                          style: TextStyle(
                            color: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
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
    if (_appointmentDescriptionIDController.text.isEmpty ||
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
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBusinessAppointmentsTool(screenWidth),
    );
  }
}
