import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/components/builders/buildPatientList.dart';
import 'package:patient_manager/components/builders/buildPatientQueueList.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/components/mihAppDrawer.dart';
import 'package:patient_manager/components/mihLoadingCircle.dart';
import 'package:patient_manager/components/inputsAndButtons/mihDateInput.dart';
import 'package:patient_manager/components/popUpMessages/mihErrorMessage.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/objects/patientQueue.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:patient_manager/components/inputsAndButtons/mihSearchInput.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/patients.dart';

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
      return Container(
        height: 500,
        decoration: BoxDecoration(
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 3.0,
          ),
        ),
        child: BuildPatientsList(
          patients: patientsList,
          signedInUser: widget.arguments.signedInUser,
          business: widget.arguments.business,
          arguments: widget.arguments,
        ),
      );
    }
    return Container(
      //height: 500,
      decoration: BoxDecoration(
        color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 3.0),
      ),
      child: Center(
        child: Text(
          "Enter ID or Medical Aid No. of Patient",
          style: TextStyle(
              fontSize: 25,
              color: MzanziInnovationHub.of(context)!.theme.messageTextColor()),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget patientSearch(double w, double h) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (event) async {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.enter) {
          submitPatientForm();
        }
      },
      child: SizedBox(
        width: w,
        height: 600,
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          const SizedBox(height: 5),
          const Text(
            "Patient Search",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
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
                return Container(
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
                );
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

                return Expanded(
                  child: displayPatientList(patientsList, searchString),
                );
              } else {
                return Container(
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
                  child: Center(
                    child: Text(
                      "$errorCode: Error pulling Patients Data\n$baseUrl/patients/search/$searchString\n$errorBody",
                      style: TextStyle(
                          fontSize: 25,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .errorColor()),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
          ),
        ]),
      ),
    );
  }

  Widget displayQueueList(List<PatientQueue> patientQueueList) {
    if (patientQueueList.isNotEmpty) {
      return Container(
        height: 500,
        decoration: BoxDecoration(
          color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 3.0,
          ),
        ),
        child: BuildPatientQueueList(
          patientQueue: patientQueueList,
          signedInUser: widget.arguments.signedInUser,
          business: widget.arguments.business,
          businessUser: widget.arguments.businessUser,
        ),
      );
    }
    return Container(
      //height: 500,
      decoration: BoxDecoration(
        color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 3.0),
      ),
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

  Widget patientQueue(double w, double h) {
    return SizedBox(
      width: w,
      height: 600,
      child: Column(mainAxisSize: MainAxisSize.max, children: [
        //const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                ))
          ],
        ),
        const SizedBox(height: 10),
        MIHDateField(
          controller: queueDateController,
          LableText: "Date",
          required: true,
        ),
        //spacer
        const SizedBox(height: 10),
        FutureBuilder(
          future: patientQueueResults,
          builder: (context, snapshot) {
            //print("patient Queue List  ${snapshot.hasData}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                //height: 500,
                decoration: BoxDecoration(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      width: 3.0),
                ),
                child: const Mihloadingcircle(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              List<PatientQueue> patientQueueList;
              // if (searchString == "") {
              //   patientQueueList = [];
              // } else {
              patientQueueList = filterQueueResults(
                  snapshot.requireData, queueDateController.text);
              //   print(patientQueueList);
              // }

              return Expanded(
                child: displayQueueList(patientQueueList),
              );
            } else {
              return Container(
                //height: 500,
                decoration: BoxDecoration(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      width: 3.0),
                ),
                child: Center(
                  child: Text(
                    "$errorCode: Error pulling Patients Data\n$baseUrl/patients/search/$searchString\n$errorBody",
                    style: TextStyle(
                        fontSize: 25,
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .errorColor()),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          },
        ),
      ]),
    );
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

  Widget showSelection(int index, double screenWidth, double screenHeight) {
    if (index == 0) {
      return SizedBox(
        width: 660,
        child: patientQueue(screenWidth, screenHeight),
      );
    } else {
      return SizedBox(
        width: 660,
        child: patientSearch(screenWidth, screenHeight),
      );
    }
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const MIHAppBar(barTitle: "Patient Manager"),
      drawer: MIHAppDrawer(signedInUser: widget.arguments.signedInUser),
      //floatingActionButtonLocation: FloatingActionButtonLocation.,
      // floatingActionButton: FloatingActionButton.extended(
      //   label: Text(
      //     "Add Patient",
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
      //     ),
      //   ),
      //   //backgroundColor: Colors.blueAccent,
      //   onPressed: () {
      //     Navigator.of(context).pushNamed('/patient-manager/add',
      //         arguments: widget.signedInUser.email);
      //   },
      //   icon: Icon(
      //     Icons.add,
      //     color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
            ),
            showSelection(_selectedIndex, screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }
}
