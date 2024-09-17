import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/MIH_Components/popUpMessages/mihWarningMessage.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/objects/business.dart';
import 'package:patient_manager/objects/businessUser.dart';
import 'package:patient_manager/objects/patientQueue.dart';
import 'package:patient_manager/objects/patients.dart';
import 'package:supertokens_flutter/http.dart' as http;

class BuildPatientQueueList extends StatefulWidget {
  final List<PatientQueue> patientQueue;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;

  const BuildPatientQueueList({
    super.key,
    required this.patientQueue,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
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
    String fname = widget.patientQueue[index].first_name[0] + "********";
    String lname = widget.patientQueue[index].last_name[0] + "********";
    String title =
        widget.patientQueue[index].date_time.split('T')[1].substring(0, 5);
    String subtitle = "";
    var nowDate = DateTime.now();
    var expireyDate = DateTime.parse(widget.patientQueue[index].revoke_date);

    if (widget.patientQueue[index].access != "approved" ||
        expireyDate.isBefore(nowDate)) {
      subtitle += "Name: $fname $lname\n";
      subtitle += "ID No.: ${widget.patientQueue[index].id_no}\n";
      subtitle += "Medical Aid No: ********";
      //subtitle += "********";
    } else {
      subtitle +=
          "Name: ${widget.patientQueue[index].first_name} ${widget.patientQueue[index].last_name}\nID No.: ${widget.patientQueue[index].id_no}\nMedical Aid No: ";
      if (widget.patientQueue[index].medical_aid_no == "") {
        subtitle += "No Medical Aid";
      } else {
        // subtitle +=
        //     "\nMedical Aid No: ";
        subtitle += widget.patientQueue[index].medical_aid_no;
      }
    }
    if (expireyDate.isBefore(nowDate)) {
      subtitle += "\nAccess Request: EXPIRED";
    } else {
      subtitle +=
          "\nAccess Request: ${widget.patientQueue[index].access.toUpperCase()}";
    }

    subtitle +=
        "\nAccess Expiration date: ${widget.patientQueue[index].revoke_date.substring(0, 16).replaceAll("T", " ")}";
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
        var todayDate = DateTime.now();
        var revokeDate = DateTime.parse(widget.patientQueue[index].revoke_date);
        // print(
        //     "Todays: $todayDate\nRevoke Date: $revokeDate\nHas revoke date passed: ${revokeDate.isBefore(todayDate)}");
        if (revokeDate.isBefore(todayDate)) {
          expiredAccessWarning();
        } else if (widget.patientQueue[index].access != "pending") {
          Patient selectedPatient;
          fetchPatients(widget.patientQueue[index].app_id).then(
            (result) {
              setState(() {
                selectedPatient = result;
                Navigator.of(context).pushNamed('/patient-manager/patient',
                    arguments: PatientViewArguments(
                      widget.signedInUser,
                      selectedPatient,
                      widget.businessUser,
                      widget.business,
                      "business",
                    ));
              });
            },
          );
        } else {
          noAccessWarning();
        }
      },
      trailing: Icon(
        Icons.arrow_forward,
        color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
      ),
    );
  }

  void noAccessWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "No Access");
      },
    );
  }

  void expiredAccessWarning() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHWarningMessage(warningType: "Expired Access");
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
