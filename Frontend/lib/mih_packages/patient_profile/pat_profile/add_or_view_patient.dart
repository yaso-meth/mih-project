import 'dart:convert';

import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/patient_add.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/patient_profile.dart';
import 'package:flutter/material.dart';
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
  late double width;
  late double height;
  late Widget loading;
  late Future<Patient?> patient;

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
  void initState() {
    // TODO: implement initState
    super.initState();
    patient = fetchPatient();
  }

  @override
  Widget build(BuildContext context) {
    print("AddOrViewPatient");
    var size = MediaQuery.of(context).size;
    setState(() {
      width = size.width;
      height = size.height;
    });
    return FutureBuilder(
      future: patient,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          // Extracting data from snapshot object
          //final data = snapshot.data as String;
          return PatientProfile(
              arguments: PatientViewArguments(
            widget.arguments.signedInUser,
            snapshot.requireData,
            null,
            null,
            widget.arguments.type,
          ));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          loading = Container(
            width: width,
            height: height,
            color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            child: const Mihloadingcircle(),
          );

          return loading;
        } else {
          return AddPatient(signedInUser: widget.arguments.signedInUser);
        }
      },
    );
  }
}
