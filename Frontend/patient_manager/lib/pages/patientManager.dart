import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/buildPatientList.dart';
import 'package:patient_manager/components/myAppBar.dart';
import 'package:patient_manager/components/myAppDrawer.dart';
import 'package:patient_manager/main.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_client/mysql_client.dart';
import 'package:patient_manager/objects/patients.dart';

Future<List<Patient>> fetchPatients(String endpoint) async {
  print("fetch patients");
  final response = await http.get(Uri.parse(endpoint));
  //print("Status Code: " + response.statusCode.toString());
  if (response.statusCode == 200) {
    Iterable l = jsonDecode(response.body);
    List<Patient> patients =
        List<Patient>.from(l.map((model) => Patient.fromJson(model)));
    print("convert response to json");
    //print(response.body);
    // final patientsData =
    //     Patient.fromJson(jsonDecode(response.body)[0] as Map<String, dynamic>);
    print(patients);
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
  //String useremail = "";
  String endpoint = "http://localhost:80/patients/user/";
  late MySQLConnection conn;
  String resultsofDB = "";
  late Future<List<Patient>> futurePatients;

  // Future<String> getuserEmail() async {
  //   final res = await client.auth.getUser();
  //   //final response = await http.get(Uri.parse(endpoint));
  //   //print(json.decode(response.body));
  //   if (res.user!.email != null) {
  //     //print("User: " + res.user!.email.toString());
  //     useremail = res.user!.email!;

  //     //print(useremail);
  //     return useremail;
  //   }
  //   return "";
  // }

  // @override
  // void initState() {
  //   // String endpoint = "http://localhost:80/patients/";
  //   print("init now");
  //   print("Endpoint 1: " + endpoint);
  //   //print(getuserEmail());
  //   endpoint += userEmail;
  //   print("Endpoint 1: " + endpoint);
  //   futurePatients = fetchPatients(endpoint);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(barTitle: "Patient Manager"),
      drawer: MyAppDrawer(drawerTitle: widget.userEmail),
      body: FutureBuilder(
        future: fetchPatients(endpoint + widget.userEmail),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final patientsList = snapshot.data!;
            return BuildPatientsList(
              patients: patientsList,
            );
          } else {
            return const MyAppDrawer(drawerTitle: "Error pulling email");
          }
        },
      ),
    );

    // FutureBuilder<Patient>(
    //   future: futurePatients,
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       return Scaffold(
    //         appBar: const MyAppBar(barTitle: "Patient Manager"),
    //         body: Center(child: Text(snapshot.data.toString())),
    //         drawer: MyAppDrawer(drawerTitle: useremail),
    //       );
    //     } else if (snapshot.hasError) {
    //       print('${snapshot.error}');
    //       return Text('${snapshot.error}');
    //     } else {
    //       return Center(child: CircularProgressIndicator());
    //     }
    //   },
    // );
  }
}
