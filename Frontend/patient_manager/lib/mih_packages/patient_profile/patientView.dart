import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/mih_packages/patient_profile/patientDetails.dart';
import 'package:patient_manager/mih_packages/patient_profile/patientFiles.dart';
import 'package:patient_manager/mih_packages/patient_profile/patientNotes.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_action.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_body.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_header.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
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
  late double popUpWidth;
  late double? popUpheight;
  late double popUpTitleSize;
  late double popUpSubtitleSize;
  late double popUpBodySize;
  late double popUpIconSize;
  late double popUpPaddingSize;
  late double width;
  late double height;

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

  void checkScreenSize() {
    if (MzanziInnovationHub.of(context)!.theme.screenType == "desktop") {
      setState(() {
        popUpWidth = (width / 4) * 2;
        popUpheight = null;
      });
    } else {
      setState(() {
        popUpWidth = width - (width * 0.1);
        popUpheight = null;
      });
    }
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

  MIHAction getActionButton() {
    return MIHAction(
      icon: Icons.arrow_back,
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      },
    );
  }

  MIHHeader getHeader() {
    return MIHHeader(
      headerAlignment: MainAxisAlignment.end,
      headerItems: [
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
    );
  }

  MIHBody getBody() {
    return MIHBody(
      borderOn: true,
      bodyItems: [showSelection(_selectedIndex)],
    );
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
    checkScreenSize();
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(),
      body: getBody(),
    );
    // return Scaffold(
    //   body: SafeArea(
    //     child: SingleChildScrollView(
    //       child: Stack(
    //         children: [
    //           Container(
    //             width: width,
    //             height: height,
    //             padding: const EdgeInsets.symmetric(
    //                 vertical: 10.0, horizontal: 15.0),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.max,
    //               children: [
    //                 Row(
    //                   crossAxisAlignment: CrossAxisAlignment.end,
    //                   mainAxisAlignment: MainAxisAlignment.end,
    //                   children: [
    //                     IconButton(
    //                       onPressed: () {
    //                         setState(() {
    //                           _selectedIndex = 0;
    //                         });
    //                       },
    //                       icon: const Icon(
    //                         Icons.perm_identity,
    //                         size: 35,
    //                       ),
    //                     ),
    //                     IconButton(
    //                       onPressed: () {
    //                         setState(() {
    //                           _selectedIndex = 1;
    //                         });
    //                       },
    //                       icon: const Icon(
    //                         Icons.article_outlined,
    //                         size: 35,
    //                       ),
    //                     ),
    //                     IconButton(
    //                       onPressed: () {
    //                         setState(() {
    //                           _selectedIndex = 2;
    //                         });
    //                       },
    //                       icon: const Icon(
    //                         Icons.file_present,
    //                         size: 35,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //                 const SizedBox(
    //                   height: 10.0,
    //                 ),
    //                 showSelection(_selectedIndex),
    //               ],
    //             ),
    //           ),
    //           Positioned(
    //             top: 10,
    //             left: 5,
    //             width: 50,
    //             height: 50,
    //             child: IconButton(
    //               onPressed: () {
    //                 Navigator.of(context).pop();
    //               },
    //               icon: const Icon(Icons.arrow_back),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
