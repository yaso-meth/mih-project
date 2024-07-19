import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/buildPatientList.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:http/http.dart' as http;
import 'package:patient_manager/components/mySearchInput.dart';
import 'package:patient_manager/components/patManAppDrawer.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/patients.dart';

class PatientManager extends StatefulWidget {
  final String userEmail;

  const PatientManager({
    super.key,
    required this.userEmail,
  });

  @override
  State<PatientManager> createState() => _PatientManagerState();
}

//
class _PatientManagerState extends State<PatientManager> {
  TextEditingController searchController = TextEditingController();
  String endpoint = "${AppEnviroment.baseApiUrl}/patients/user/";
  late Future<List<Patient>> futurePatients;
  String errorCode = "";
  String errorBody = "";

  String searchString = "";

  Future<List<Patient>> fetchPatients(String endpoint) async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(endpoint));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: {response.statusCode}");
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

  Widget displayList(List<Patient> patientsList, String searchString) {
    if (searchString.isNotEmpty && searchString != "") {
      return Padding(
        padding: const EdgeInsets.only(
          left: 25,
          right: 25,
          bottom: 25,
        ),
        child: Container(
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
            //searchString: searchString,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(
        left: 25,
        right: 25,
        bottom: 25,
      ),
      child: Container(
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
                color:
                    MzanziInnovationHub.of(context)!.theme.messageTextColor()),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget patientSearch(double w, double h) {
    return SizedBox(
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
          onTap: () {},
          onChanged: (value) {
            setState(() {
              searchString = value;
            });
          },
        ),
        //spacer
        const SizedBox(height: 10),
        FutureBuilder(
          future: futurePatients,
          builder: (context, snapshot) {
            //print("patient Liust  ${snapshot.data}");
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                child: Container(
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
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            } else if (snapshot.hasData) {
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
              return Padding(
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  bottom: 25,
                ),
                child: Container(
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
                      "$errorCode: Error pulling Patients Data\n$endpoint${widget.userEmail}\n$errorBody",
                      style: TextStyle(
                          fontSize: 25,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .errorColor()),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ]),
    );
  }

  @override
  void initState() {
    // errorCode = "";
    // errorBody = "";
    //print("patient manager page: ${widget.userEmail}");
    futurePatients = fetchPatients(endpoint + widget.userEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: const MyAppBar(barTitle: "Patient Manager"),
      drawer: PatManAppDrawer(userEmail: widget.userEmail),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 65, right: 5),
        child: FloatingActionButton.extended(
          label: Text(
            "Add Patient",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            ),
          ),
          //backgroundColor: Colors.blueAccent,
          onPressed: () {
            Navigator.of(context)
                .pushNamed('/patient-manager/add', arguments: widget.userEmail);
          },
          icon: Icon(
            Icons.add,
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
          ),
        ),
      ),
      body: patientSearch(screenWidth, screenHeight),
    );
  }
}
