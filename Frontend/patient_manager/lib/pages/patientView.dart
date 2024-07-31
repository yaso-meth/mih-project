import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/mihAppDrawer.dart';
import 'package:patient_manager/components/patientDetails.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/components/patientFiles.dart';
import 'package:patient_manager/components/patientNotes.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
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
    var patientAppId = widget.signedInUser.app_id;

    final response = await http
        .get(Uri.parse("${AppEnviroment.baseApiUrl}/patients/$patientAppId"));
    // print("Here");
    // print("Body: ${response.body}");
    // print("Code: ${response.statusCode}");
    // var errorCode = response.statusCode.toString();
    // var errorBody = response.body;

    if (response.statusCode == 200) {
      //print("Here1");
      var decodedData = jsonDecode(response.body);
      // print("Here2");
      Patient patients = Patient.fromJson(decodedData as Map<String, dynamic>);
      // print("Here3");
      // print(patients);
      return patients;
    }
    return null;
  }

  // Future<void> loadImage() async {
  //   try {
  //     var t = MzanziInnovationHub.of(context)!.theme.logoImage();
  //     await precacheImage(t.image, context);
  //   } catch (e) {
  //     print('Failed to load and cache the image: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // loadImage();
    // var logo = MzanziInnovationHub.of(context)!.theme.logoImage();
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
              appBar: const MIHAppBar(barTitle: "Patient View"),
              drawer: MIHAppDrawer(
                signedInUser: widget.signedInUser,
                logo: MzanziInnovationHub.of(context)!.theme.logoImage(),
              ),
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
                            width: 660,
                            child: PatientNotes(
                              patientAppId: snapshot.data!.app_id,
                              signedInUser: widget.signedInUser,
                            ),
                          ),
                          SizedBox(
                            width: 660,
                            child: PatientFiles(
                              patientIndex: snapshot.data!.idpatients,
                              selectedPatient: snapshot.data!,
                              signedInUser: widget.signedInUser,
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
