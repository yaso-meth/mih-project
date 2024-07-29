import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/buildNotesList.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/components/myMLTextInput.dart';
import 'package:patient_manager/components/mySuccessMessage.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/notes.dart';
import 'package:supertokens_flutter/http.dart' as http;

class PatientNotes extends StatefulWidget {
  final String patientAppId;
  final AppUser signedInUser;
  const PatientNotes(
      {super.key, required this.patientAppId, required this.signedInUser});

  @override
  State<PatientNotes> createState() => _PatientNotesState();
}

class _PatientNotesState extends State<PatientNotes> {
  String endpoint = "${AppEnviroment.baseApiUrl}/notes/patients/";
  String apiUrlAddNote = "${AppEnviroment.baseApiUrl}/notes/insert/";
  final titleController = TextEditingController();
  final noteTextController = TextEditingController();
  late Future<List<Note>> futueNotes;

  Future<List<Note>> fetchNotes(String endpoint) async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/notes/patients/${widget.patientAppId}"));
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
    var response = await http.post(
      Uri.parse(apiUrlAddNote),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "note_name": titleController.text,
        "note_text": noteTextController.text,
        "patient_id": widget.patientAppId,
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
        return MySuccessMessage(
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
        return const MyErrorMessage(errorType: "Internet Connection");
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
                    child: MyTextField(
                      controller: titleController,
                      hintText: "Title of Note",
                      editable: true,
                      required: true,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Expanded(
                    child: MyMLTextField(
                      controller: noteTextController,
                      hintText: "Note Details",
                      editable: true,
                      required: true,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    height: 100,
                    child: MyButton(
                      onTap: () {
                        if (isFieldsFilled()) {
                          addPatientNoteAPICall();
                          Navigator.pop(context);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const MyErrorMessage(
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
    if (widget.signedInUser.type == "personal") {
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
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData) {
          final notesList = snapshot.data!;
          return Container(
            //height: 300.0,
            decoration: BoxDecoration(
              color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  width: 3.0),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: setIcons(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Divider(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor()),
                ),
                const SizedBox(height: 10),
                BuildNotesList(notes: notesList),
              ]),
            ),
          );
        } else {
          return const Center(
            child: Text("Error Loading Notes"),
          );
        }
      },
    );
  }
}
