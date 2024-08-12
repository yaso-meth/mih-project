import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/components/buildPatientList.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/components/mihLoadingCircle.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:patient_manager/components/mySearchInput.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/patients.dart';

class PatientManager extends StatefulWidget {
  final AppUser signedInUser;

  const PatientManager({
    super.key,
    required this.signedInUser,
  });

  @override
  State<PatientManager> createState() => _PatientManagerState();
}

//
class _PatientManagerState extends State<PatientManager> {
  TextEditingController searchController = TextEditingController();
  String baseUrl = AppEnviroment.baseApiUrl;

  final FocusNode _focusNode = FocusNode();
  String errorCode = "";
  String errorBody = "";

  String searchString = "";

  late Future<List<Patient>> patientSearchResults;

  Future<List<Patient>> fetchPatients(String search) async {
    //print("Patien manager page: $endpoint");
    final response =
        await http.get(Uri.parse("$baseUrl/patients/search/$search"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    errorCode = response.statusCode.toString();
    errorBody = response.body;

    if (response.statusCode == 200) {
      //print("Here1");
      Iterable l = jsonDecode(response.body);
      //print("Here2");
      List<Patient> patients =
          List<Patient>.from(l.map((model) => Patient.fromJson(model)));
      // print("Here3");
      // print(patients);
      return patients;
    } else {
      throw Exception('failed to load patients');
    }
  }

  List<Patient> filterSearchResults(List<Patient> mainList, String query) {
    List<Patient> templist = [];
    //print(query);
    for (var item in mainList) {
      if (item.id_no.contains(searchString) ||
          item.medical_aid_no.contains(searchString)) {
        //print(item.medical_aid_no);
        templist.add(item);
      }
    }
    return templist;
  }

  void submitForm() {
    setState(() {
      searchString = searchController.text;
      patientSearchResults = fetchPatients(searchString);
    });
  }

  Widget displayList(List<Patient> patientsList, String searchString) {
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
          signedInUser: widget.signedInUser,
        ),
      );
    }
    return Container(
      height: 500,
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
          submitForm();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 25,
          right: 25,
          bottom: 25,
        ),
        child: SizedBox(
          width: w,
          height: h,
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            //spacer
            const SizedBox(height: 10),
            MySearchField(
              controller: searchController,
              hintText: "ID or Medical Aid No. Search",
              required: false,
              editable: true,
              onTap: () {
                submitForm();
              },
              onChanged: (value) {},
            ),
            //spacer
            const SizedBox(height: 10),
            FutureBuilder(
              future: patientSearchResults,
              builder: (context, snapshot) {
                //print("patient Liust  ${snapshot.data}");
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 500,
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
                    child: displayList(patientsList, searchString),
                  );
                } else {
                  return Container(
                    height: 500,
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
                        "$errorCode: Error pulling Patients Data\n$baseUrl${widget.signedInUser.email}\n$errorBody",
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
      ),
    );
  }

  @override
  void initState() {
    // errorCode = "";
    // errorBody = "";
    //print("patient manager page: ${widget.userEmail}");
    patientSearchResults = fetchPatients("abc");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const MIHAppBar(barTitle: "Patient Manager"),
      // drawer: PatManAppDrawer(
      //   userEmail: widget.userEmail,
      //   logo: MzanziInnovationHub.of(context)!.theme.logoImage(),
      // ),
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
      body: patientSearch(screenWidth, screenHeight),
    );
  }
}
