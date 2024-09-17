import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/mih_packages/patient_profile/builder/build_notes_list.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_multiline_text_input.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:patient_manager/mih_env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/mih_objects/app_user.dart';
import 'package:patient_manager/mih_objects/business.dart';
import 'package:patient_manager/mih_objects/business_user.dart';
import 'package:patient_manager/mih_objects/notes.dart';
import 'package:patient_manager/mih_objects/patients.dart';
import 'package:supertokens_flutter/http.dart' as http;

class PatientNotes extends StatefulWidget {
  final String patientAppId;
  final Patient selectedPatient;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final String type;
  const PatientNotes({
    super.key,
    required this.patientAppId,
    required this.selectedPatient,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
    required this.type,
  });

  @override
  State<PatientNotes> createState() => _PatientNotesState();
}

class _PatientNotesState extends State<PatientNotes> {
  String endpoint = "${AppEnviroment.baseApiUrl}/notes/patients/";
  String apiUrlAddNote = "${AppEnviroment.baseApiUrl}/notes/insert/";
  final titleController = TextEditingController();
  final noteTextController = TextEditingController();
  final officeController = TextEditingController();
  final dateController = TextEditingController();
  final doctorController = TextEditingController();
  late Future<List<Note>> futueNotes;

  Future<List<Note>> fetchNotes(String endpoint) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/notes/patients/${widget.selectedPatient.app_id}"));
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<Note> notes =
          List<Note>.from(l.map((model) => Note.fromJson(model)));
      //print("Here notes");
      return notes;
    } else {
      internetConnectionPopUp();
      throw Exception('failed to load patients');
    }
  }

  Future<void> addPatientNoteAPICall() async {
    // String title = "";
    // if (widget.businessUser!.title == "Doctor") {
    //   title = "Dr.";
    // }
    var response = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/notes/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "note_name": titleController.text,
        "note_text": noteTextController.text,
        "doc_office": officeController.text,
        "doctor": doctorController.text,
        "app_id": widget.selectedPatient.app_id,
      }),
    );
    if (response.statusCode == 201) {
      setState(() {
        futueNotes = fetchNotes(endpoint + widget.patientAppId.toString());
      });
      // Navigator.of(context)
      //     .pushNamed('/patient-manager', arguments: widget.userEmail);
      String message =
          "Your note has been successfully added to the patients medical record. You can now view it alongside their other important information.";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  void successPopUp(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MIHSuccessMessage(
          successType: "Success",
          successMessage: message,
        );
      },
    );
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void messagePopUp(error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(error),
        );
      },
    );
  }

  void addNotePopUp() {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    var title = "";
    if (widget.businessUser!.title == "Doctor") {
      title = "Dr.";
    }
    setState(() {
      officeController.text = widget.business!.Name;
      doctorController.text =
          "$title ${widget.signedInUser.fname} ${widget.signedInUser.lname}";
      dateController.text = date.toString().substring(0, 10);
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 700.0,
              //height: 500.0,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    width: 5.0),
              ),
              child: Column(
                //mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "Add Note",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  SizedBox(
                    width: 700,
                    child: MIHTextField(
                      controller: officeController,
                      hintText: "Office",
                      editable: false,
                      required: true,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 700,
                    child: MIHTextField(
                      controller: doctorController,
                      hintText: "Created By",
                      editable: false,
                      required: true,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 700,
                    child: MIHTextField(
                      controller: dateController,
                      hintText: "Created Date",
                      editable: false,
                      required: true,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 700,
                    child: MIHTextField(
                      controller: titleController,
                      hintText: "Note Title",
                      editable: true,
                      required: true,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: MIHMLTextField(
                      controller: noteTextController,
                      hintText: "Note Details",
                      editable: true,
                      required: true,
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: 300,
                    height: 50,
                    child: MIHButton(
                      onTap: () {
                        if (isFieldsFilled()) {
                          addPatientNoteAPICall();
                          Navigator.pop(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const MIHErrorMessage(
                                  errorType: "Input Error");
                            },
                          );
                        }
                      },
                      buttonText: "Add Note",
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      textColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  titleController.clear();
                  noteTextController.clear();
                },
                icon: Icon(
                  Icons.close,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                  size: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isFieldsFilled() {
    if (titleController.text.isEmpty || noteTextController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  List<Widget> setIcons() {
    if (widget.type == "personal") {
      return [
        Text(
          "Notes",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        ),
      ];
    } else {
      return [
        Text(
          "Notes",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        ),
        IconButton(
          onPressed: () {
            addNotePopUp();
          },
          icon: Icon(Icons.add,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        )
      ];
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    noteTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    futueNotes = fetchNotes(endpoint + widget.patientAppId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futueNotes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Mihloadingcircle(),
          );
        } else if (snapshot.hasData) {
          final notesList = snapshot.data!;
          return Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: setIcons(),
            ),
            Divider(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
            const SizedBox(height: 10),
            BuildNotesList(
              notes: notesList,
              signedInUser: widget.signedInUser,
              selectedPatient: widget.selectedPatient,
              business: widget.business,
              businessUser: widget.businessUser,
            ),
          ]);
        } else {
          return const Center(
            child: Text("Error Loading Notes"),
          );
        }
      },
    );
  }
}
