import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/mih_apis/mih_api_calls.dart';
import 'package:patient_manager/mih_components/mih_calendar.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_action.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_body.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_header.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:patient_manager/mih_objects/patient_access.dart';
import 'package:patient_manager/mih_packages/patient_profile/builder/build_patient_access_list.dart';
import 'package:patient_manager/mih_packages/patient_profile/builder/build_patient_list.dart';
import 'package:patient_manager/mih_packages/patient_profile/builder/build_patient_queue_list.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:patient_manager/mih_objects/arguments.dart';
import 'package:patient_manager/mih_objects/patient_queue.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_search_input.dart';
import 'package:patient_manager/mih_env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/mih_objects/patients.dart';

class PatientManager extends StatefulWidget {
  //final AppUser signedInUser;
  final BusinessArguments arguments;
  const PatientManager({
    super.key,
    required this.arguments,
  });

  @override
  State<PatientManager> createState() => _PatientManagerState();
}

//
class _PatientManagerState extends State<PatientManager> {
  TextEditingController searchController = TextEditingController();
  TextEditingController accessSearchController = TextEditingController();
  TextEditingController queueDateController = TextEditingController();

  String baseUrl = AppEnviroment.baseApiUrl;

  final FocusNode _focusNode = FocusNode();

  String searchString = "";
  String accessSearchString = "";
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  late String formattedDate;
  bool start = true;
  int _selectedIndex = 0;

  late Future<List<Patient>> patientSearchResults;
  late Future<List<PatientAccess>> patientAccessResults;
  late Future<List<PatientQueue>> patientQueueResults;

  //Waiting Room Widgets/ Functions
  List<PatientQueue> filterQueueResults(
      List<PatientQueue> queueList, String query) {
    List<PatientQueue> templist = [];
    //print(query);
    for (var item in queueList) {
      if (item.date_time.contains(query)) {
        //print(item.medical_aid_no);
        templist.add(item);
      }
    }
    //print(templist);
    return templist;
  }

  Widget displayQueueList(List<PatientQueue> patientQueueList) {
    if (patientQueueList.isNotEmpty) {
      return BuildPatientQueueList(
        patientQueue: patientQueueList,
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        businessUser: widget.arguments.businessUser,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: Center(
        child: Text(
          "No Appointments for $formattedDate",
          style: TextStyle(
              fontSize: 25,
              color: MzanziInnovationHub.of(context)!.theme.messageTextColor()),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget patientQueue() {
    return Column(mainAxisSize: MainAxisSize.max, children: [
      //const SizedBox(height: 15),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Waiting Room",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          IconButton(
            iconSize: 20,
            icon: const Icon(
              Icons.refresh,
            ),
            onPressed: () {
              refreshQueue();
            },
          ),
        ],
      ),
      Divider(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
      MIHCalendar(
          calendarWidth: 500,
          rowHeight: 35,
          setDate: (value) {
            setState(() {
              queueDateController.text = value;
            });
          }),
      //spacer
      FutureBuilder(
        future: patientQueueResults,
        builder: (context, snapshot) {
          //print("patient Queue List  ${snapshot.hasData}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Mihloadingcircle();
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<PatientQueue> patientQueueList;
            // if (searchString == "") {
            //   patientQueueList = [];
            // } else {
            patientQueueList = filterQueueResults(
                snapshot.requireData, queueDateController.text);
            //   print(patientQueueList);
            // }

            return displayQueueList(patientQueueList);
          } else {
            return Center(
              child: Text(
                "Error pulling Patients Data\n$baseUrl/patients/search/$searchString",
                style: TextStyle(
                    fontSize: 25,
                    color: MzanziInnovationHub.of(context)!.theme.errorColor()),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    ]);
  }

  void refreshQueue() {
    setState(() {
      start = true;
    });
    checkforchange();
  }

  void checkforchange() {
    if (start == true) {
      setState(() {
        patientQueueResults = MIHApiCalls.fetchPatientQueue(
            queueDateController.text, widget.arguments.business!.business_id);
        start = false;
      });
    }
    if (formattedDate != queueDateController.text) {
      setState(() {
        patientQueueResults = MIHApiCalls.fetchPatientQueue(
            queueDateController.text, widget.arguments.business!.business_id);
        formattedDate = queueDateController.text;
      });
    }
  }

  //Patient Lookup Widgets/ Functions

  List<Patient> filterSearchResults(List<Patient> patList, String query) {
    List<Patient> templist = [];
    //print(query);
    for (var item in patList) {
      if (item.id_no.contains(searchString) ||
          item.medical_aid_no.contains(searchString)) {
        //print(item.medical_aid_no);
        templist.add(item);
      }
    }
    return templist;
  }

  Widget displayPatientList(List<Patient> patientsList, String searchString) {
    if (patientsList.isNotEmpty) {
      return BuildPatientsList(
        patients: patientsList,
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        arguments: widget.arguments,
      );
    } else if (patientsList.isEmpty && searchString != "") {
      return Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Center(
          child: Text(
            "No ID or Medical Aid No. matches a Patient",
            style: TextStyle(
                fontSize: 25,
                color:
                    MzanziInnovationHub.of(context)!.theme.messageTextColor()),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 35.0),
        child: Center(
          child: Text(
            "Enter ID or Medical Aid No. of Patient",
            style: TextStyle(
                fontSize: 25,
                color:
                    MzanziInnovationHub.of(context)!.theme.messageTextColor()),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  Widget patientSearch() {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) async {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          submitPatientForm();
        }
      },
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        const Text(
          "Patient Lookup",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Divider(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),

        //spacer
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: MIHSearchField(
                controller: searchController,
                hintText: "ID or Medical Aid No. Search",
                required: false,
                editable: true,
                onTap: () {
                  submitPatientForm();
                },
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    searchController.clear();
                    searchString = "";
                  });
                  submitPatientForm();
                },
                icon: const Icon(
                  Icons.filter_alt_off,
                  size: 25,
                ))
          ],
        ),
        //spacer
        const SizedBox(height: 10),
        FutureBuilder(
          future: patientSearchResults,
          builder: (context, snapshot) {
            //print("patient Liust  ${snapshot.data}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Mihloadingcircle();
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List<Patient> patientsList;
              if (searchString == "") {
                patientsList = [];
              } else {
                patientsList =
                    filterSearchResults(snapshot.data!, searchString);
                //print(patientsList);
              }

              return displayPatientList(patientsList, searchString);
            } else {
              return Center(
                child: Text(
                  "Error pulling Patients Data\n$baseUrl/patients/search/$searchString",
                  style: TextStyle(
                      fontSize: 25,
                      color:
                          MzanziInnovationHub.of(context)!.theme.errorColor()),
                  textAlign: TextAlign.center,
                ),
              );
            }
          },
        ),
      ]),
    );
  }

  void submitPatientForm() {
    if (searchController.text != "") {
      setState(() {
        searchString = searchController.text;
        patientSearchResults = MIHApiCalls.fetchPatients(searchString);
      });
    }
    // else {
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return const MIHErrorMessage(errorType: "Input Error");
    //     },
    //   );
    // }
  }

  //Patient Access Widgets/ Functions

  List<PatientAccess> filterAccessResults(
      List<PatientAccess> patAccList, String query) {
    List<PatientAccess> templist = [];
    //print(query);
    for (var item in patAccList) {
      if (item.id_no.contains(query)) {
        //print(item.medical_aid_no);
        templist.add(item);
      }
    }
    return templist;
  }

  Widget displayPatientAccessList(List<PatientAccess> patientsAccessList) {
    if (patientsAccessList.isNotEmpty) {
      return BuildPatientAccessList(
        patientAccesses: patientsAccessList,
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        arguments: widget.arguments,
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 35.0),
      child: Center(
        child: Text(
          "No Patients matching search",
          style: TextStyle(
              fontSize: 25,
              color: MzanziInnovationHub.of(context)!.theme.messageTextColor()),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget patientAccessSearch() {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) async {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          submitPatientAccessForm();
        }
      },
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        const Text(
          "My Patient List",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Divider(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),

        //spacer
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              flex: 1,
              child: MIHSearchField(
                controller: accessSearchController,
                hintText: "ID Search",
                required: false,
                editable: true,
                onTap: () {
                  submitPatientAccessForm();
                },
              ),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    accessSearchController.clear();
                    accessSearchString = "";
                  });
                  submitPatientAccessForm();
                },
                icon: const Icon(
                  Icons.filter_alt_off,
                  size: 25,
                ))
          ],
        ),

        //spacer
        const SizedBox(height: 10),
        FutureBuilder(
          future: patientAccessResults,
          builder: (context, snapshot) {
            //print("patient Liust  ${snapshot.data}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Mihloadingcircle();
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List<PatientAccess> patientsAccessList;
              if (accessSearchString == "") {
                patientsAccessList = snapshot.data!;
              } else {
                patientsAccessList =
                    filterAccessResults(snapshot.data!, accessSearchString);
                //print(patientsList);
              }

              return displayPatientAccessList(patientsAccessList);
            } else {
              return Center(
                child: Text(
                  "Error pulling Patient Access Data\n$baseUrl/access-requests/business/patient/${widget.arguments.business!.business_id}",
                  style: TextStyle(
                      fontSize: 25,
                      color:
                          MzanziInnovationHub.of(context)!.theme.errorColor()),
                  textAlign: TextAlign.center,
                ),
              );
            }
          },
        ),
      ]),
    );
  }

  void submitPatientAccessForm() {
    // if (searchController.text != "") {
    setState(() {
      accessSearchString = accessSearchController.text;
      patientAccessResults = MIHApiCalls.getPatientAccessListOfBusiness(
          widget.arguments.business!.business_id);
    });
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return const MIHErrorMessage(errorType: "Input Error");
    //     },
    //   );
    // }
  }

  //Layout Widgets/ Functions

  Widget showSelection(int index) {
    if (index == 0) {
      return SizedBox(
        //width: 660,
        child: patientQueue(),
      );
    } else if (index == 1) {
      return SizedBox(
        //width: 660,
        child: patientAccessSearch(),
      );
    } else {
      return SizedBox(
        //width: 660,
        child: patientSearch(),
      );
    }
  }

  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();

        Navigator.of(context).popAndPushNamed(
          '/',
        );
      },
    );
  }

  MIHHeader getHeader() {
    return MIHHeader(
      headerAlignment: MainAxisAlignment.end,
      headerItems: [
        //============ Waiting Room ================
        Visibility(
          visible: _selectedIndex != 0,
          child: IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
            icon: const Icon(
              Icons.people,
              size: 35,
            ),
          ),
        ),
        Visibility(
          visible: _selectedIndex == 0,
          child: IconButton.filled(
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
            icon: const Icon(
              Icons.people,
              size: 35,
            ),
          ),
        ),
        //============ My Patient List ================
        Visibility(
          visible: _selectedIndex != 1,
          child: IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
            icon: const Icon(
              Icons.check_box_outlined,
              size: 35,
            ),
          ),
        ),
        Visibility(
          visible: _selectedIndex == 1,
          child: IconButton.filled(
            onPressed: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
            icon: const Icon(
              Icons.check_box_outlined,
              size: 35,
            ),
          ),
        ),
        //============ Patient Lookup ================
        Visibility(
          visible: _selectedIndex != 2,
          child: IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 2;
              });
            },
            icon: const Icon(
              Icons.search,
              size: 35,
            ),
          ),
        ),
        Visibility(
          visible: _selectedIndex == 2,
          child: IconButton.filled(
            onPressed: () {
              setState(() {
                _selectedIndex = 2;
              });
            },
            icon: const Icon(
              Icons.search,
              size: 35,
            ),
          ),
        ),
      ],
    );
  }

  MIHBody getBody() {
    return MIHBody(
      borderOn: true,
      bodyItems: [
        showSelection(_selectedIndex),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    accessSearchController.dispose();
    queueDateController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    patientSearchResults = MIHApiCalls.fetchPatients("abc");
    patientAccessResults = MIHApiCalls.getPatientAccessListOfBusiness(
        widget.arguments.business!.business_id);
    queueDateController.addListener(checkforchange);
    setState(() {
      formattedDate = formatter.format(now);
      queueDateController.text = formattedDate;
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
