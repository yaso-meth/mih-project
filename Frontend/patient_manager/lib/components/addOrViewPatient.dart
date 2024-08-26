import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/mihLoadingCircle.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/objects/patients.dart';
import 'package:patient_manager/pages/patientAdd.dart';
import 'package:patient_manager/pages/patientView.dart';
import 'package:supertokens_flutter/http.dart' as http;

class AddOrViewPatient extends StatefulWidget {
  //final AppUser signedInUser;
  final PatientViewArguments arguments;
  const AddOrViewPatient({
    super.key,
    required this.arguments,
  });

  @override
  State<AddOrViewPatient> createState() => _AddOrViewPatientState();
}

class _AddOrViewPatientState extends State<AddOrViewPatient> {
  Future<Patient?> fetchPatient() async {
    //print("Patien manager page: $endpoint");
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/patients/${widget.arguments.signedInUser.app_id}"));
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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchPatient(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          // Extracting data from snapshot object
          //final data = snapshot.data as String;
          return PatientView(
              arguments: PatientViewArguments(
            widget.arguments.signedInUser,
            snapshot.requireData,
            null,
            null,
            widget.arguments.type,
          ));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Mihloadingcircle();
        } else {
          return AddPatient(signedInUser: widget.arguments.signedInUser);
        }
      },
    );
  }
}
