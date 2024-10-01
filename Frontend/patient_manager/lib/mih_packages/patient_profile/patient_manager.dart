import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_action.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_body.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_header.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:patient_manager/mih_packages/patient_profile/builder/build_patient_list.dart';
import 'package:patient_manager/mih_packages/patient_profile/builder/build_patient_queue_list.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_date_input.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:patient_manager/mih_objects/arguments.dart';
import 'package:patient_manager/mih_objects/patient_queue.dart';
import 'package:supertokens_flutter/http.dart' as http;
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
  TextEditingController queueDateController = TextEditingController();

  String baseUrl = AppEnviroment.baseApiUrl;

  final FocusNode _focusNode = FocusNode();
  String errorCode = "";
  String errorBody = "";

  String searchString = "";
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  late String formattedDate;
  bool start = true;
  int _selectedIndex = 0;

  late Future<List<Patient>> patientSearchResults;
  late Future<List<PatientQueue>> patientQueueResults;

  Future<List<PatientQueue>> fetchPatientQueue(String date) async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(
        "$baseUrl/queue/patients/${widget.arguments.businessUser!.business_id}"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    errorCode = response.statusCode.toString();
    errorBody = response.body;

    if (response.statusCode == 200) {
      //print("Here1");
      Iterable l = jsonDecode(response.body);
      //print("Here2");
      List<PatientQueue> patientQueue = List<PatientQueue>.from(
          l.map((model) => PatientQueue.fromJson(model)));
      //print("Here3");
      //print(patientQueue);
      return patientQueue;
    } else {
      throw Exception('failed to load patients');
    }
  }

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

  Future<List<Patient>> fetchPatients(String search) async {
    final response =
        await http.get(Uri.parse("$baseUrl/patients/search/$search"));
    errorCode = response.statusCode.toString();
    errorBody = response.body;

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Patient> patients =
          List<Patient>.from(l.map((model) => Patient.fromJson(model)));
      return patients;
    } else {
      throw Exception('failed to load patients');
    }
  }

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
    if (searchString.isNotEmpty && searchString != "") {
      return BuildPatientsList(
        patients: patientsList,
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        arguments: widget.arguments,
      );
    }
    return Center(
      child: Text(
        "Enter ID or Medical Aid No. of Patient",
        style: TextStyle(
            fontSize: 25,
            color: MzanziInnovationHub.of(context)!.theme.messageTextColor()),
        textAlign: TextAlign.center,
      ),
    );
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
          "Patient Search",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Divider(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),

        //spacer
        const SizedBox(height: 10),
        MIHSearchField(
          controller: searchController,
          hintText: "ID or Medical Aid No. Search",
          required: true,
          editable: true,
          onTap: () {
            submitPatientForm();
          },
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
                  "$errorCode: Error pulling Patients Data\n$baseUrl/patients/search/$searchString\n$errorBody",
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

  Widget displayQueueList(List<PatientQueue> patientQueueList) {
    if (patientQueueList.isNotEmpty) {
      return BuildPatientQueueList(
        patientQueue: patientQueueList,
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        businessUser: widget.arguments.businessUser,
      );
    }
    return Center(
      child: Text(
        "No Appointments for $formattedDate",
        style: TextStyle(
            fontSize: 25,
            color: MzanziInnovationHub.of(context)!.theme.messageTextColor()),
        textAlign: TextAlign.center,
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
            onPressed: () {
              refreshQueue();
            },
            icon: const Icon(
              Icons.refresh,
              size: 25,
            ),
          ),
        ],
      ),
      Divider(color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
      const SizedBox(height: 10),
      MIHDateField(
        controller: queueDateController,
        lableText: "Date",
        required: true,
      ),
      //spacer
      const SizedBox(height: 10),
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
                "$errorCode: Error pulling Patients Data\n$baseUrl/patients/search/$searchString\n$errorBody",
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

  void submitPatientForm() {
    if (searchController.text != "") {
      setState(() {
        searchString = searchController.text;
        patientSearchResults = fetchPatients(searchString);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    }
  }

  void checkforchange() {
    if (start == true) {
      setState(() {
        patientQueueResults = fetchPatientQueue(queueDateController.text);
        start = false;
      });
    }
    if (formattedDate != queueDateController.text) {
      setState(() {
        patientQueueResults = fetchPatientQueue(queueDateController.text);
        formattedDate = queueDateController.text;
      });
    }
  }

  Widget showSelection(int index) {
    if (index == 0) {
      return SizedBox(
        //width: 660,
        child: patientQueue(),
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
      },
    );
  }

  MIHHeader getHeader() {
    return MIHHeader(
      headerAlignment: MainAxisAlignment.end,
      headerItems: [
        IconButton(
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
        IconButton(
          onPressed: () {
            setState(() {
              _selectedIndex = 1;
            });
          },
          icon: const Icon(
            Icons.search,
            size: 35,
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
    queueDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    patientSearchResults = fetchPatients("abc");
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
      body: getBody(),
      rightDrawer: null,
      bottomNavBar: null,
    );
    // return Scaffold(
    //   // appBar: const MIHAppBar(
    //   //   barTitle: "Patient Manager",
    //   //   propicFile: null,
    //   // ),
    //   body: Stack(
    //     children: [
    //       Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           const SizedBox(height: 5),
    //           Row(
    //             crossAxisAlignment: CrossAxisAlignment.end,
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             children: [
    //               IconButton(
    //                 onPressed: () {
    //                   setState(() {
    //                     _selectedIndex = 0;
    //                   });
    //                 },
    //                 icon: const Icon(
    //                   Icons.people,
    //                   size: 35,
    //                 ),
    //               ),
    //               IconButton(
    //                 onPressed: () {
    //                   setState(() {
    //                     _selectedIndex = 1;
    //                   });
    //                 },
    //                 icon: const Icon(
    //                   Icons.search,
    //                   size: 35,
    //                 ),
    //               ),
    //               IconButton(
    //                 onPressed: () {
    //                   refreshQueue();
    //                 },
    //                 icon: const Icon(
    //                   Icons.refresh,
    //                   size: 35,
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 15),
    //             child: showSelection(_selectedIndex, screenWidth, screenHeight),
    //           ),
    //         ],
    //       ),
    //       Positioned(
    //         top: 5,
    //         left: 5,
    //         width: 50,
    //         height: 50,
    //         child: IconButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           icon: const Icon(Icons.arrow_back),
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
