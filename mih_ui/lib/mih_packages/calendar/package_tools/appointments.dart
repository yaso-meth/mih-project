import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_calendar.dart';
import 'package:mzansi_innovation_hub/mih_packages/calendar/components/mih_appointment_add_window.dart';
import 'package:mzansi_innovation_hub/mih_providers/mih_calendar_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
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

  Future<void> _updateSelectedDate(
    int daysOffset,
    MihCalendarProvider mihCalendarProvider,
    MzansiProfileProvider mzansiProfileProvider,
  ) async {
    final String rawDay = mihCalendarProvider.selectedDay;
    final DateTime currentDay = DateTime.parse(rawDay);
    final DateTime newDate = currentDay.add(Duration(days: daysOffset));
    final String formattedDate = newDate.toIso8601String().split('T')[0];
    mihCalendarProvider.setSelectedDay(formattedDate);
    mihCalendarProvider.loadCachedCalendar();
    await mihCalendarProvider.syncWithMihServerData(mzansiProfileProvider);
  }

  Widget displayAppointmentList(MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider) {
    List<Appointment> appointmentList = mzansiProfileProvider.personalHome
        ? mihCalendarProvider.personalAppointments!
        : mihCalendarProvider.businessAppointments!;

    return appointmentList.isNotEmpty
        ? Expanded(
            child: BuildAppointmentList(
              inWaitingRoom: false,
              titleController: _appointmentTitleController,
              descriptionIDController: _appointmentDescriptionIDController,
              patientIdController: null,
              dateController: _appointmentDateController,
              timeController: _appointmentTimeController,
            ),
          )
        : Expanded(
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
                    "No appointments for ${mihCalendarProvider.selectedDay}",
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
  }

  void addAppointmentWindow(MzansiProfileProvider mzansiProfileProvider,
      MihCalendarProvider mihCalendarProvider, double width) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihAppointmentAddWindow(
          titleController: _appointmentTitleController,
          descriptionIDController: _appointmentDescriptionIDController,
          dateController: _appointmentDateController,
          timeController: _appointmentTimeController,
        );
      },
    );
  }

  String getTitle(MzansiProfileProvider mzansiProfileProvider) {
    if (mzansiProfileProvider.personalHome == false) {
      return "Business Appointments";
    } else {
      return "Personal Appointments";
    }
  }

  Widget getBody(double width) {
    return Consumer2<MzansiProfileProvider, MihCalendarProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider,
          MihCalendarProvider mihCalendarProvider,
          Widget? child) {
        if (mzansiProfileProvider.personalHome &&
            mihCalendarProvider.personalAppointments == null) {
          return const Center(
            child: Mihloadingcircle(),
          );
        }
        if (!mzansiProfileProvider.personalHome &&
            mihCalendarProvider.businessAppointments == null) {
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
                    mihCalendarProvider.setSelectedDay(value);
                    mihCalendarProvider.loadCachedCalendar();
                    await mihCalendarProvider
                        .syncWithMihServerData(mzansiProfileProvider);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                displayAppointmentList(
                  mzansiProfileProvider,
                  mihCalendarProvider,
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Align(
                alignment: AlignmentGeometry.bottomCenter,
                child: MihButton(
                  borderRadius: 100,
                  width: 65,
                  height: 65,
                  onPressed: () {
                    addAppointmentWindow(
                        mzansiProfileProvider, mihCalendarProvider, width);
                  },
                  buttonColor: MihColors.green(),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: MihColors.primary(),
                      size: 45,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              bottom: 10,
              child: MihButton(
                borderRadius: 100,
                width: 65,
                height: 65,
                onPressed: () {
                  _updateSelectedDate(
                      -1, mihCalendarProvider, mzansiProfileProvider);
                },
                buttonColor: MihColors.green(),
                child: Center(
                  child: Icon(
                    Icons.keyboard_arrow_left_rounded,
                    color: MihColors.primary(),
                    size: 60,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: MihButton(
                borderRadius: 100,
                width: 65,
                height: 65,
                onPressed: () {
                  _updateSelectedDate(
                      1, mihCalendarProvider, mzansiProfileProvider);
                },
                buttonColor: MihColors.green(),
                child: Center(
                  child: Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: MihColors.primary(),
                    size: 60,
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      backgroundColor: MihColors.primary(),
      borderOn: false,
      bodyItem: getBody(screenWidth),
    );
  }
}
