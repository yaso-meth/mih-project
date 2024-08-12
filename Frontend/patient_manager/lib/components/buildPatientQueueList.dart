import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/objects/patientQueue.dart';
import 'package:patient_manager/objects/patients.dart';
import 'package:supertokens_flutter/http.dart' as http;

class BuildPatientQueueList extends StatefulWidget {
  final List<PatientQueue> patientQueue;
  final AppUser signedInUser;

  const BuildPatientQueueList({
    super.key,
    required this.patientQueue,
    required this.signedInUser,
  });

  @override
  State<BuildPatientQueueList> createState() => _BuildPatientsListState();
}

class _BuildPatientsListState extends State<BuildPatientQueueList> {
  String baseAPI = AppEnviroment.baseApiUrl;

  Future<Patient> fetchPatients(String app_id) async {
    //print("pat man drawer: " + endpointUserData + widget.userEmail);

    var response = await http.get(Uri.parse("$baseAPI/patients/$app_id"));

    // print(response.statusCode);
    // print(response.body);
    if (response.statusCode == 200) {
      // print("here");
      String body = response.body;
      var decodedData = jsonDecode(body);
      Patient u = Patient.fromJson(decodedData);
      // print(u.email);
      //setState(() {
      //_widgetOptions = setLayout(u);
      //});
      return u;
    } else {
      throw Exception("Error: GetUserData status code ${response.statusCode}");
    }
  }

  Widget displayQueue(int index) {
    String title =
        widget.patientQueue[index].date_time.split('T')[1].substring(0, 5);
    String subtitle =
        "Name: ${widget.patientQueue[index].first_name} ${widget.patientQueue[index].last_name}\nID No.: ${widget.patientQueue[index].id_no}\nMedical Aid No: ";
    if (widget.patientQueue[index].medical_aid_no == "") {
      subtitle += "No Medical Aid";
    } else {
      subtitle += widget.patientQueue[index].medical_aid_no;
    }
    return ListTile(
      title: Text(
        "Appointment: $title",
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        ),
      ),
      onTap: () {
        Patient selectedPatient;
        fetchPatients(widget.patientQueue[index].app_id).then(
          (result) {
            setState(() {
              selectedPatient = result;
              Navigator.of(context).pushNamed('/patient-manager/patient',
                  arguments: PatientViewArguments(
                      widget.signedInUser, selectedPatient, "business"));
            });
          },
        );
      },
      trailing: Icon(
        Icons.arrow_forward,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, index) {
        return Divider(
          color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
        );
      },
      itemCount: widget.patientQueue.length,
      itemBuilder: (context, index) {
        //final patient = widget.patients[index].id_no.contains(widget.searchString);
        //print(index);
        return displayQueue(index);
      },
    );
  }
}
