import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/buildPatientList.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:patient_manager/components/myAppDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:patient_manager/components/mySearchInput.dart';
import 'package:patient_manager/objects/patients.dart';

Future<List<Patient>> fetchPatients(String endpoint) async {
  final response = await http.get(Uri.parse(endpoint));
  if (response.statusCode == 200) {
    Iterable l = jsonDecode(response.body);
    List<Patient> patients =
        List<Patient>.from(l.map((model) => Patient.fromJson(model)));
    return patients;
  } else {
    throw Exception('failed to load patients');
  }
}

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

  @override
  void initState() {
    futurePatients = fetchPatients(endpoint + widget.userEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(barTitle: "Patient Manager"),
      drawer: MyAppDrawer(drawerTitle: widget.userEmail),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "Create",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        onPressed: () {},
        icon: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        future: futurePatients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final patientsList = snapshot.data!;

            return Row(
              children: [
                Expanded(
                  child: Column(children: [
                    //spacer
                    const SizedBox(height: 10),
                    MySearchField(
                      controller: searchController,
                      hintText: "ID Search",
                      onChanged: (value) {
                        setState(() {
                          searchString = value;
                        });
                      },
                    ),
                    //spacer
                    const SizedBox(height: 10),
                    Expanded(
                      child: BuildPatientsList(
                        patients: patientsList,
                        searchString: searchString,
                      ),
                    ),
                  ]),
                ),
              ],
            );
          } else {
            return const MyAppDrawer(drawerTitle: "Error pulling email");
          }
        },
      ),
    );
  }
}
