import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_calendar.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_mzansi_calendar_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_date_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_time_field.dart';
import 'package:mzansi_innovation_hub/mih_objects/appointment.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/builder/build_appointment_list.dart';
import 'package:provider/provider.dart';

class Appointments extends StatefulWidget {
  const Appointments({
    super.key,
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

  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();

  Widget displayAppointmentList(MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider) {
    List<Appointment> appointmentList = mzansiProfileProvider.personalHome
        ? mihCalendarProvider.personalAppointments!
        : mihCalendarProvider.businessAppointments!;
    if (appointmentList.isNotEmpty) {
      return Expanded(
        child: BuildAppointmentList(
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
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Icon(
              MihIcons.calendar,
              size: 165,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
            const SizedBox(height: 10),
            Text(
              "No appointments for ${mihCalendarProvider.selectedDay}",
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                  children: [
                    TextSpan(text: "Press "),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.menu,
                        size: 20,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
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
  }

  void addAppointmentWindow(MzansiProfileProvider mzansiProfileProvider,
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
                      fillColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      inputColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      controller: _appointmentDescriptionIDController,
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
                                mzansiProfileProvider, mihCalendarProvider);
                          } else {
                            MihAlertServices().inputErrorAlert(context);
                          }
                        },
                        buttonColor: MihColors.getGreenColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        width: 300,
                        child: Text(
                          "Add",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
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

  Future<void> addAppointmentCall(
    MzansiProfileProvider mzansiProfileProvider,
    MihCalendarProvider mihCalendarProvider,
  ) async {
    if (isAppointmentInputValid()) {
      int statusCode;
      if (mzansiProfileProvider.personalHome == false) {
        statusCode = await MihMzansiCalendarApis.addBusinessAppointment(
          mzansiProfileProvider.user!,
          mzansiProfileProvider.business!,
          mzansiProfileProvider.businessUser!,
          false,
          _appointmentTitleController.text,
          _appointmentDescriptionIDController.text,
          _appointmentDateController.text,
          _appointmentTimeController.text,
          mihCalendarProvider,
          context,
        );
      } else {
        statusCode = await MihMzansiCalendarApis.addPersonalAppointment(
          mzansiProfileProvider.user!,
          _appointmentTitleController.text,
          _appointmentDescriptionIDController.text,
          _appointmentDateController.text,
          _appointmentTimeController.text,
          mihCalendarProvider,
          context,
        );
      }
      if (statusCode == 201) {
        context.pop();
        successPopUp("Successfully Added Appointment",
            "You appointment has been successfully added to your calendar.");
        if (mzansiProfileProvider.personalHome == true) {
          await MihMzansiCalendarApis.getPersonalAppointments(
            mzansiProfileProvider.user!.app_id,
            mihCalendarProvider.selectedDay,
            mihCalendarProvider,
          );
        } else {
          await MihMzansiCalendarApis.getBusinessAppointments(
            mzansiProfileProvider.business!.business_id,
            false,
            mihCalendarProvider.selectedDay,
            mihCalendarProvider,
          );
        }
      } else {
        MihAlertServices().internetConnectionAlert(context);
      }
    } else {
      MihAlertServices().inputErrorAlert(context);
    }
    checkforchange();
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
          buttonColor: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          elevation: 10,
          width: 300,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      context,
    );
  }

  String getTitle(MzansiProfileProvider mzansiProfileProvider) {
    if (mzansiProfileProvider.personalHome == false) {
      return "Business Appointments";
    } else {
      return "Personal Appointments";
    }
  }

  void checkforchange() {
    setState(() {
      isLoading = true;
    });
    _loadInitialAppointments();
  }

  Widget getBody(double width) {
    if (isLoading) {
      return const Center(
        child: Mihloadingcircle(),
      );
    }
    return Consumer2<MzansiProfileProvider, MihCalendarProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider,
          MihCalendarProvider mihCalendarProvider,
          Widget? child) {
        return Stack(
          children: [
            Column(
              children: [
                MIHCalendar(
                    calendarWidth: 500,
                    rowHeight: 35,
                    setDate: (value) {
                      mihCalendarProvider.setSelectedDay(value);
                      setState(() {
                        selectedAppointmentDateController.text = value;
                      });
                    }),
                // Divider(
                //   color: MihColors.getSecondaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                // ),
                displayAppointmentList(
                  mzansiProfileProvider,
                  mihCalendarProvider,
                )
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
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                    label: "Add Appointment",
                    labelBackgroundColor: MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    labelStyle: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    onTap: () {
                      addAppointmentWindow(
                          mzansiProfileProvider, mihCalendarProvider, width);
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

  Future<void> _loadInitialAppointments() async {
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    MihCalendarProvider mihCalendarProvider =
        context.read<MihCalendarProvider>();
    if (mzansiProfileProvider.personalHome == false) {
      await MihMzansiCalendarApis.getBusinessAppointments(
        mzansiProfileProvider.business!.business_id,
        false,
        mihCalendarProvider.selectedDay,
        mihCalendarProvider,
      );
    } else {
      await MihMzansiCalendarApis.getPersonalAppointments(
        mzansiProfileProvider.user!.app_id,
        mihCalendarProvider.selectedDay,
        mihCalendarProvider,
      );
    }
    setState(() {
      isLoading = false;
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadInitialAppointments();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(screenWidth),
    );
  }
}
