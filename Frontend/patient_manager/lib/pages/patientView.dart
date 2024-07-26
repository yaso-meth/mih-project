import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/patientDetails.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:patient_manager/components/patientFiles.dart';
import 'package:patient_manager/components/patientNotes.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/patients.dart';
import 'package:supertokens_flutter/http.dart' as http;

class PatientView extends StatefulWidget {
  final AppUser signedInUser;
  const PatientView({
    super.key,
    required this.signedInUser,
  });

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  Future<Patient?> fetchPatient() async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/patients/${widget.signedInUser.app_id}"));
    print("Here");
    print("Body: ${response.body}");
    print("Code: ${response.statusCode}");
    // var errorCode = response.statusCode.toString();
    // var errorBody = response.body;

    if (response.statusCode == 200) {
      print("Here1");
      var decodedData = jsonDecode(response.body);
      print("Here2");
      Patient patients = Patient.fromJson(decodedData as Map<String, dynamic>);
      print("Here3");
      print(patients);
      return patients;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchPatient(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Checking if future is resolved
        else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: const MyAppBar(barTitle: "Patient View"),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15.0),
                  child: Column(
                    children: [
                      PatientDetails(selectedPatient: snapshot.data!),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Wrap(
                        spacing: 10.0,
                        runSpacing: 10.0,
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        children: [
                          SizedBox(
                            width: 650,
                            child: PatientNotes(
                              patientIndex: snapshot.data!.idpatients,
                            ),
                          ),
                          SizedBox(
                            width: 650,
                            child: PatientFiles(
                              patientIndex: snapshot.data!.idpatients,
                              selectedPatient: snapshot.data!,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }
        return Center(
          child: Text(
            '${snapshot.error} occurred',
            style: TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }
}
