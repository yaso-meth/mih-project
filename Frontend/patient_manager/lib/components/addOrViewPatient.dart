import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/patients.dart';
import 'package:patient_manager/pages/patientAdd.dart';
import 'package:patient_manager/pages/patientView.dart';
import 'package:supertokens_flutter/http.dart' as http;

class AddOrViewPatient extends StatefulWidget {
  final AppUser signedInUser;
  const AddOrViewPatient({
    super.key,
    required this.signedInUser,
  });

  @override
  State<AddOrViewPatient> createState() => _AddOrViewPatientState();
}

class _AddOrViewPatientState extends State<AddOrViewPatient> {
  Future<Patient?> fetchPatient() async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/patients/${widget.signedInUser.app_id}"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    // var errorCode = response.statusCode.toString();
    // var errorBody = response.body;

    if (response.statusCode == 200) {
      // print("Here1");
      var decodedData = jsonDecode(response.body);
      // print("Here2");
      Patient patients = Patient.fromJson(decodedData as Map<String, dynamic>);
      // print("Here3");
      // print(patients);
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
            // Extracting data from snapshot object
            //final data = snapshot.data as String;
            return PatientView(signedInUser: widget.signedInUser);
          }
        }
        return AddPatient(signedInUser: widget.signedInUser);
      },
    );
  }
}
