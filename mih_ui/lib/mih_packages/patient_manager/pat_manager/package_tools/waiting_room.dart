import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_calendar.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_objects/appointment.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/builder/build_appointment_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class WaitingRoom extends StatefulWidget {
  const WaitingRoom({
    super.key,
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

  late Future<List<Appointment>> businessAppointmentResults;
  late Future<List<Appointment>> appointmentResults;
  bool inWaitingRoom = true;
  final _formKey = GlobalKey<FormState>();

  // Business Appointment Tool
  Widget getBusinessAppointmentsTool(double width) {
    return Consumer3<MzansiProfileProvider, PatientManagerProvider,
        MihCalendarProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider profileProvider,
          PatientManagerProvider patientManagerProvider,
          MihCalendarProvider calendarProvider,
          Widget? child) {
        if (calendarProvider.businessAppointments == null) {
          return const Center(
            child: Mihloadingcircle(),
          );
        }
        return Stack(
          children: [
            Column(
              children: [
                MIHCalendar(
                  calendarWidth: 500,
                  rowHeight: 35,
                  setDate: (value) async {
                    calendarProvider.setSelectedDay(value);
                    calendarProvider.loadCachedCalendar();
                    await calendarProvider
                        .syncWithMihServerData(profileProvider);
                  },
                ),
                displayAppointmentList(calendarProvider)
              ],
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
                      color: MihColors.primary(),
                    ),
                    label: "Add Appointment",
                    labelBackgroundColor: MihColors.green(),
                    labelStyle: TextStyle(
                      color: MihColors.primary(),
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: MihColors.green(),
                    onTap: () {
                      // addAppointmentWindow();
                      appointmentTypeSelection(
                        profileProvider,
                        patientManagerProvider,
                        calendarProvider,
                        width,
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget displayAppointmentList(MihCalendarProvider mihCalendarProvider) {
    if (mihCalendarProvider.businessAppointments!.isNotEmpty) {
      return Expanded(
        child: BuildAppointmentList(
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
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Icon(
              MihIcons.calendar,
              size: 165,
              color: MihColors.secondary(),
            ),
            const SizedBox(height: 10),
            Text(
              "No Appointments for ${mihCalendarProvider.selectedDay}",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MihColors.secondary(),
              ),
            ),
            const SizedBox(height: 25),
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: MihColors.secondary(),
                  ),
                  children: [
                    TextSpan(text: "Press "),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.menu,
                        size: 20,
                        color: MihColors.secondary(),
                      ),
                    ),
                    TextSpan(
                        text:
                            " to add an appointment or select a different date"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // return Expanded(
    //   child: Padding(
    //     padding: const EdgeInsets.only(top: 35.0),
    //     child: Align(
    //       alignment: Alignment.center,
    //       child: Text(
    //         "No Appointments for $selectedDay",
    //         style: TextStyle(
    //           fontSize: 25,
    //           color: MihColors.grey(),
    //         ),
    //         textAlign: TextAlign.center,
    //         softWrap: true,
    //       ),
    //     ),
    //   ),
    // );
  }

  void appointmentTypeSelection(
      MzansiProfileProvider profileProvider,
      PatientManagerProvider patientManagerProvider,
      MihCalendarProvider mihCalendarProvider,
      double width) {
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
            context.pop();
          },
          windowBody: Column(
            children: [
              Text(
                question,
                style: TextStyle(fontSize: 20, color: MihColors.secondary()),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 15),
              MihButton(
                onPressed: () {
                  patientManagerProvider.setPatientManagerIndex(1);
                  context.pop();
                },
                buttonColor: MihColors.secondary(),
                width: 300,
                child: Text(
                  "Existing Patient",
                  style: TextStyle(
                    color: MihColors.primary(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              MihButton(
                onPressed: () {
                  patientManagerProvider.setPatientManagerIndex(2);
                  context.pop();
                },
                buttonColor: MihColors.secondary(),
                width: 300,
                child: Text(
                  "Existing MIH User",
                  style: TextStyle(
                    color: MihColors.primary(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              MihButton(
                onPressed: () {
                  Navigator.pop(context);
                  addAppointmentWindow(
                      profileProvider, mihCalendarProvider, width);
                },
                buttonColor: MihColors.secondary(),
                width: 300,
                child: Text(
                  "Skeleton Appointment",
                  style: TextStyle(
                    color: MihColors.primary(),
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

  void addAppointmentWindow(MzansiProfileProvider profileProvider,
      MihCalendarProvider mihCalendarProvider, double width) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Add Appointment",
          onWindowTapClose: () {
            context.pop();
            _appointmentDateController.clear();
            _appointmentTimeController.clear();
            _appointmentTitleController.clear();
            _appointmentDescriptionIDController.clear();
            _patientController.clear();
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
                      fillColor: MihColors.secondary(),
                      inputColor: MihColors.primary(),
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
                      fillColor: MihColors.secondary(),
                      inputColor: MihColors.primary(),
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
                            addAppointmentCall(
                                profileProvider, mihCalendarProvider);
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

  Future<void> addAppointmentCall(
    MzansiProfileProvider profileProvider,
    MihCalendarProvider mihCalendarProvider,
  ) async {
    if (isAppointmentInputValid()) {
      String offlineId = Uuid().v4();
      mihCalendarProvider.addNewAppointmentLocally(
        profileProvider,
        Appointment(
          idappointments: 0,
          app_id: '',
          business_id: profileProvider.business!.business_id,
          date_time:
              "${_appointmentDateController.text} ${_appointmentTimeController.text}",
          title: _appointmentTitleController.text,
          description: _appointmentDescriptionIDController.text,
          offline_id: offlineId,
        ),
      );
      context.pop();
      successPopUp("Successfully Added Appointment",
          "You appointment has been successfully added to your calendar.");
    } else {
      MihAlertServices().inputErrorAlert(context);
    }
  }

  void successPopUp(String title, String message) {
    MihAlertServices().successAdvancedAlert(
      title,
      message,
      [
        MihButton(
          onPressed: () {
            context.pop();
            setState(() {
              _appointmentDateController.clear();
              _appointmentTimeController.clear();
              _appointmentTitleController.clear();
              _appointmentDescriptionIDController.clear();
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

  bool isAppointmentInputValid() {
    if (_appointmentDescriptionIDController.text.isEmpty ||
        _appointmentDateController.text.isEmpty ||
        _appointmentTimeController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      bodyItem: getBusinessAppointmentsTool(screenWidth),
    );
  }
}
