import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/buildPatientList.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:http/http.dart' as http;
import 'package:patient_manager/components/mySearchInput.dart';
import 'package:patient_manager/components/patManAppDrawer.dart';
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

class _PatientManagerState extends State<PatientManager> {
  TextEditingController searchController = TextEditingController();
  String endpoint = "http://localhost:80/patients/user/";
  late Future<List<Patient>> futurePatients;

  String searchString = "";

  Future<List<Patient>> fetchPatients(String endpoint) async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(endpoint));
    //print(response.statusCode);
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Patient> patients =
          List<Patient>.from(l.map((model) => Patient.fromJson(model)));
      return patients;
    } else {
      throw Exception('failed to load patients');
    }
  }

  List<Patient> filterSearchResults(List<Patient> mainList, String query) {
    return mainList
        .where((tempList) => tempList.id_no.contains(query.toLowerCase()))
        .toList();
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25.0),
            border: Border.all(color: Colors.blueAccent, width: 3.0),
          ),
          child: BuildPatientsList(
            patients: patientsList,
            searchString: searchString,
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.blueAccent, width: 3.0),
        ),
        child: const Center(
          child: Text(
            "Enter ID of Patient",
            style: TextStyle(fontSize: 25, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget patientSearch() {
    return Column(children: [
      //spacer
      const SizedBox(height: 10),
      MySearchField(
        controller: searchController,
        hintText: "ID Search",
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<Patient> patientsList;
            if (searchString == "") {
              patientsList = snapshot.data!;
            } else {
              patientsList = filterSearchResults(snapshot.data!, searchString);
            }

            return Expanded(
              child: displayList(patientsList, searchString),
            );
          } else {
            return const PatManAppDrawer(userEmail: "Error pulling email");
          }
        },
      ),
    ]);
  }

  @override
  void initState() {
    futurePatients = fetchPatients(endpoint + widget.userEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(barTitle: "Patient Manager"),
      drawer: PatManAppDrawer(userEmail: widget.userEmail),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 65, right: 5),
        child: FloatingActionButton.extended(
          label: const Text(
            "Add Patient",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            Navigator.of(context)
                .pushNamed('/patient-manager/add', arguments: widget.userEmail);
          },
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: patientSearch(),
          ),
        ],
      ),
    );
  }
}
