import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

import '../../mih_apis/mih_api_calls.dart';
import '../../mih_components/mih_calendar.dart';
import '../../mih_components/mih_layout/mih_action.dart';
import '../../mih_components/mih_layout/mih_body.dart';
import '../../mih_components/mih_layout/mih_header.dart';
import '../../mih_components/mih_layout/mih_layout_builder.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_env/env.dart';
import '../../mih_objects/access_request.dart';
import '../../mih_objects/app_user.dart';
import '../../mih_objects/patient_queue.dart';
import 'builder/build_appointment_list.dart';

class Appointments extends StatefulWidget {
  final AppUser signedInUser;

  const Appointments({
    super.key,
    required this.signedInUser,
  });

  @override
  State<Appointments> createState() => _PatientAccessRequestState();
}

class _PatientAccessRequestState extends State<Appointments> {
  TextEditingController filterController = TextEditingController();
  TextEditingController appointmentDateController = TextEditingController();
  String baseUrl = AppEnviroment.baseApiUrl;

  String errorCode = "";
  String errorBody = "";
  String datefilter = "";
  String accessFilter = "";
  bool forceRefresh = false;
  late String selectedDropdown;
  String selectedDay = DateTime.now().toString().split(" ")[0];

  late Future<List<AccessRequest>> accessRequestResults;
  late Future<List<PatientQueue>> personalQueueResults;

  Widget displayQueueList(List<PatientQueue> patientQueueList) {
    if (patientQueueList.isNotEmpty) {
      return Expanded(
        child: BuildAppointmentList(
          patientQueue: patientQueueList,
          signedInUser: widget.signedInUser,
        ),
      );
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Center(
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

  void checkforchange() {
    setState(() {
      personalQueueResults = MIHApiCalls.fetchPersonalAppointmentsAPICall(
        selectedDay,
        widget.signedInUser.app_id,
      );
    });
  }

  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();

        Navigator.of(context).popAndPushNamed(
          '/',
          arguments: AuthArguments(true, false),
        );
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "Appointments",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  MIHBody getBody() {
    return MIHBody(
      borderOn: true,
      bodyItems: [
        MIHCalendar(
            calendarWidth: 500,
            rowHeight: 35,
            setDate: (value) {
              setState(() {
                selectedDay = value;
                appointmentDateController.text = selectedDay;
              });
            }),
        Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            FutureBuilder(
                future: personalQueueResults,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Expanded(
                        child: Center(child: Mihloadingcircle()));
                  } else if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return displayQueueList(snapshot.requireData);
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
    );
  }

  @override
  void dispose() {
    filterController.dispose();
    appointmentDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    appointmentDateController.addListener(checkforchange);
    setState(() {
      personalQueueResults = MIHApiCalls.fetchPersonalAppointmentsAPICall(
        selectedDay,
        widget.signedInUser.app_id,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(),
      secondaryActionButton: null,
      body: getBody(),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
  }
}
