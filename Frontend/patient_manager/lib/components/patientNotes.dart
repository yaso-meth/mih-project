import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/buildNotesList.dart';
import 'package:patient_manager/components/myMLTextInput.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/objects/notes.dart';
import 'package:http/http.dart' as http;

Future<List<Note>> fetchNotes(String endpoint) async {
  final response = await http.get(Uri.parse(endpoint));
  if (response.statusCode == 200) {
    Iterable l = jsonDecode(response.body);
    List<Note> notes = List<Note>.from(l.map((model) => Note.fromJson(model)));
    return notes;
  } else {
    throw Exception('failed to load patients');
  }
}

class PatientNotes extends StatefulWidget {
  final int patientIndex;
  const PatientNotes({super.key, required this.patientIndex});

  @override
  State<PatientNotes> createState() => _PatientNotesState();
}

class _PatientNotesState extends State<PatientNotes> {
  String endpoint = "http://localhost:80/notes/patients/";
  String apiUrlAddNote = "http://localhost:80/notes/insert/";
  final titleController = TextEditingController();
  final noteTextController = TextEditingController();
  late Future<List<Note>> futueNotes;

  Future<void> addPatientNoteAPICall() async {
    var response = await http.post(
      Uri.parse(apiUrlAddNote),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "note_name": titleController.text,
        "note_text": noteTextController.text,
        "patient_id": widget.patientIndex,
      }),
    );
    if (response.statusCode == 201) {
      setState(() {
        futueNotes = fetchNotes(endpoint + widget.patientIndex.toString());
      });
      // Navigator.of(context)
      //     .pushNamed('/patient-manager', arguments: widget.userEmail);
      String message = "Successfully added Note";
      messagePopUp(message);
    } else {
      messagePopUp("error");
    }
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

  @override
  void initState() {
    futueNotes = fetchNotes(endpoint + widget.patientIndex.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futueNotes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final notesList = snapshot.data!;
          return Flexible(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                elevation: 20.0,
                child: Container(
                  //height: 300.0,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 219, 218, 218),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Expanded(
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Notes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text("Add Note"),
                                      ],
                                    ),
                                    content: Column(
                                      children: [
                                        SizedBox(
                                          width: 700,
                                          child: MyTextField(
                                            controller: titleController,
                                            hintText: "Title of Note",
                                            editable: true,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 25.0,
                                        ),
                                        Expanded(
                                          child: MyMLTextField(
                                            controller: noteTextController,
                                            hintText: "Note Details",
                                            editable: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          addPatientNoteAPICall();
                                          Navigator.pop(context);
                                          //print(widget.patientIndex);
                                        },
                                        child: const Text(
                                          "Submit",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      )
                                    ],
                                  ),
                                );
                              },
                              icon: const Icon(Icons.add),
                            )
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(),
                        ),
                        const SizedBox(height: 10),
                        BuildNotesList(notes: notesList),
                      ]),
                    ),
                  ),
                ),
              ),
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
