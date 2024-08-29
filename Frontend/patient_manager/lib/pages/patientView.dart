import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/patientDetails.dart';
import 'package:patient_manager/components/patientFiles.dart';
import 'package:patient_manager/components/patientNotes.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/objects/patients.dart';
import 'package:supertokens_flutter/http.dart' as http;

class PatientView extends StatefulWidget {
  //final AppUser signedInUser;
  final PatientViewArguments arguments;
  const PatientView({
    super.key,
    required this.arguments,
  });

  @override
  State<PatientView> createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  int _selectedIndex = 0;
  Future<Patient?> fetchPatient() async {
    //print("Patien manager page: $endpoint");
    var patientAppId = widget.arguments.selectedPatient!.app_id;

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

  Widget showSelection(int index) {
    if (index == 0) {
      return PatientDetails(
        signedInUser: widget.arguments.signedInUser,
        selectedPatient: widget.arguments.selectedPatient!,
        type: widget.arguments.type,
      );
    } else if (index == 1) {
      return PatientNotes(
        patientAppId: widget.arguments.selectedPatient!.app_id,
        selectedPatient: widget.arguments.selectedPatient!,
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        businessUser: widget.arguments.businessUser,
        type: widget.arguments.type,
      );
    } else {
      return PatientFiles(
        patientIndex: widget.arguments.selectedPatient!.idpatients,
        selectedPatient: widget.arguments.selectedPatient!,
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        businessUser: widget.arguments.businessUser,
        type: widget.arguments.type,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // loadImage();
    // var logo = MzanziInnovationHub.of(context)!.theme.logoImage();
    return Scaffold(
      // appBar: const MIHAppBar(
      //   barTitle: "Patient Profile",
      //   propicFile: null,
      // ),
      //drawer: showDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 15.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                          icon: const Icon(
                            Icons.perm_identity,
                            size: 35,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          icon: const Icon(
                            Icons.article_outlined,
                            size: 35,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _selectedIndex = 2;
                            });
                          },
                          icon: const Icon(
                            Icons.file_present,
                            size: 35,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    showSelection(_selectedIndex),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                left: 5,
                width: 50,
                height: 50,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
