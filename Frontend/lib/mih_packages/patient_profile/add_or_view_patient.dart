import 'dart:convert';

import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:supertokens_flutter/http.dart' as http;

import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_env/env.dart';
import '../../mih_objects/arguments.dart';
import '../../mih_objects/patients.dart';
import 'patient_add.dart';
import 'patient_view.dart';

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
    var size = MediaQuery.of(context).size;
    setState(() {
      width = size.width;
      height = size.height;
    });
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
