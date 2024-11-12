import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/mih_apis/mih_api_calls.dart';
import 'package:patient_manager/mih_components/mih_calendar.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_action.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_body.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_header.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:patient_manager/mih_objects/patient_queue.dart';
import 'package:patient_manager/mih_packages/access_review/builder/build_access_request_list.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:patient_manager/mih_env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/mih_objects/access_request.dart';
import 'package:patient_manager/mih_objects/app_user.dart';
import 'package:patient_manager/mih_packages/appointment/builder/build_appointment_list.dart';
import 'package:supertokens_flutter/http.dart' as http;

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

  Future<List<AccessRequest>> fetchAccessRequests() async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(
        Uri.parse("$baseUrl/access-requests/${widget.signedInUser.app_id}"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    errorCode = response.statusCode.toString();
    errorBody = response.body;

    if (response.statusCode == 200) {
      //print("Here1");
      Iterable l = jsonDecode(response.body);
      //print("Here2");
      List<AccessRequest> patientQueue = List<AccessRequest>.from(
          l.map((model) => AccessRequest.fromJson(model)));
      //print("Here3");
      //print(patientQueue);
      return patientQueue;
    } else {
      throw Exception('failed to load patients');
    }
  }

  List<AccessRequest> filterSearchResults(List<AccessRequest> accessList) {
    List<AccessRequest> templist = [];

    for (var item in accessList) {
      if (filterController.text == "All") {
        if (item.date_time.contains(datefilter)) {
          templist.add(item);
        }
      } else {
        if (item.date_time.contains(datefilter) &&
            item.access.contains(filterController.text.toLowerCase())) {
          templist.add(item);
        }
      }
    }
    return templist;
  }

  Widget displayAccessRequestList(List<AccessRequest> accessRequestList) {
    if (accessRequestList.isNotEmpty) {
      return BuildAccessRequestList(
        signedInUser: widget.signedInUser,
        accessRequests: accessRequestList,

        // BuildPatientQueueList(
        //   patientQueue: patientQueueList,
        //   signedInUser: widget.signedInUser,
        // ),
      );
    } else {
      return Center(
        child: Text(
          "No Request have been made.",
          style: TextStyle(
              fontSize: 25,
              color: MzanziInnovationHub.of(context)!.theme.messageTextColor()),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget viewAccessRequest(double w, double h) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: w,
        height: h,
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          //const SizedBox(height: 15),
          const Text(
            "Access Request",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: 500,
            child: MIHDropdownField(
              controller: filterController,
              hintText: "Access Types",
              dropdownOptions: const ["All", "Approved", "Pending", "Declined"],
              required: true,
              editable: true,
            ),
          ),
          const SizedBox(height: 10),
          FutureBuilder(
            future: accessRequestResults,
            builder: (context, snapshot) {
              //print("patient Queue List  ${snapshot.hasData}");
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Expanded(
                  child: Container(
                    //height: 500,
                    decoration: BoxDecoration(
                      color:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          width: 3.0),
                    ),
                    child: const Mihloadingcircle(),
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                List<AccessRequest> accessRequestList;
                accessRequestList = filterSearchResults(snapshot.requireData);
                if (accessRequestList.isNotEmpty) {
                  return BuildAccessRequestList(
                    signedInUser: widget.signedInUser,
                    accessRequests: accessRequestList,
                  );
                } else {
                  return Center(
                    child: Text(
                      "No Request have been made.",
                      style: TextStyle(
                          fontSize: 25,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .messageTextColor()),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                // return Expanded(
                //   child: displayAccessRequestList(accessRequestList),
                // );
              } else {
                return Center(
                  child: Text(
                    "$errorCode: Error pulling Patients Data\n$baseUrl/queue/patients/\n$errorBody",
                    style: TextStyle(
                        fontSize: 25,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .errorColor()),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            },
          ),
        ]),
      ),
    );
  }

  void refreshList() {
    if (forceRefresh == true) {
      setState(() {
        accessRequestResults = fetchAccessRequests();
        forceRefresh = false;
      });
    } else if (selectedDropdown != filterController.text) {
      setState(() {
        accessRequestResults = fetchAccessRequests();
        selectedDropdown = filterController.text;
      });
    }
    // setState(() {
    //   accessRequestResults = fetchAccessRequests();
    // });
  }

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
          arguments: true,
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
                  //return displayQueueList(snapshot.requireData);
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
    // selectedDropdown = "All";
    // filterController.text = "All";
    // filterController.addListener(refreshList);
    // setState(() {
    //   accessRequestResults = fetchAccessRequests();
    // });
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
