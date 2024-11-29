import 'dart:convert';

import 'package:Mzansi_Innovation_Hub/mih_packages/patient_profile/patient_claims_statements.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_detector/flutter_swipe_detector.dart';
import '../../main.dart';
import 'package:supertokens_flutter/http.dart' as http;

import '../../mih_components/mih_layout/mih_action.dart';
import '../../mih_components/mih_layout/mih_body.dart';
import '../../mih_components/mih_layout/mih_header.dart';
import '../../mih_components/mih_layout/mih_layout_builder.dart';
import '../../mih_env/env.dart';
import '../../mih_objects/arguments.dart';
import '../../mih_objects/patients.dart';
import 'patient_details.dart';
import 'patient_files.dart';
import 'patient_notes.dart';

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
    } else if (index == 2) {
      return PatientFiles(
        patientIndex: widget.arguments.selectedPatient!.idpatients,
        selectedPatient: widget.arguments.selectedPatient!,
        signedInUser: widget.arguments.signedInUser,
        business: widget.arguments.business,
        businessUser: widget.arguments.businessUser,
        type: widget.arguments.type,
      );
    } else {
      return PatientClaimsOrStatements(
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
    if (widget.arguments.type == "Personal") {
      return MIHAction(
        icon: const Icon(Icons.arrow_back),
        iconSize: 35,
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).popAndPushNamed(
            '/',
            arguments: true,
          );
        },
      );
    } else {
      return MIHAction(
        icon: const Icon(Icons.arrow_back),
        iconSize: 35,
        onTap: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  MIHHeader getHeader() {
    return MIHHeader(
      headerAlignment: MainAxisAlignment.end,
      headerItems: [
        //============ Patient Details ================
        Visibility(
          visible: _selectedIndex != 0,
          child: IconButton(
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
        ),
        Visibility(
          visible: _selectedIndex == 0,
          child: IconButton.filled(
            iconSize: 35,
            onPressed: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
            icon: const Icon(
              Icons.perm_identity,
            ),
          ),
        ),
        //============ Patient Notes ================
        Visibility(
          visible: _selectedIndex != 1,
          child: IconButton(
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
        ),
        Visibility(
          visible: _selectedIndex == 1,
          child: IconButton.filled(
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
        ),
        //============ Patient Files ================
        Visibility(
          visible: _selectedIndex != 2,
          child: IconButton(
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
        ),
        Visibility(
          visible: _selectedIndex == 2,
          child: IconButton.filled(
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
        ),
        //============ Claims/ Statements ================
        Visibility(
          visible: _selectedIndex != 3,
          child: IconButton(
            onPressed: () {
              setState(() {
                _selectedIndex = 3;
              });
            },
            icon: const Icon(
              Icons.file_open_outlined,
              size: 35,
            ),
          ),
        ),
        Visibility(
          visible: _selectedIndex == 3,
          child: IconButton.filled(
            onPressed: () {
              setState(() {
                _selectedIndex = 3;
              });
            },
            icon: const Icon(
              Icons.file_open_outlined,
              size: 35,
            ),
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
    return SwipeDetector(
      onSwipeLeft: (offset) {
        if (_selectedIndex < 2) {
          setState(() {
            _selectedIndex += 1;
          });
        }
        //print("swipe left");
      },
      onSwipeRight: (offset) {
        if (_selectedIndex > 0) {
          setState(() {
            _selectedIndex -= 1;
          });
        }
        //print("swipe right");
      },
      child: MIHLayoutBuilder(
        actionButton: getActionButton(),
        header: getHeader(),
        secondaryActionButton: null,
        body: getBody(),
        actionDrawer: null,
        secondaryActionDrawer: null,
        bottomNavBar: null,
        pullDownToRefresh: false,
        onPullDown: () async {},
      ),
    );
  }
}
