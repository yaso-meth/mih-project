import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/buildFilesList.dart';
import 'package:patient_manager/components/myDateInput.dart';
import 'package:patient_manager/objects/files.dart';

import 'package:http/http.dart' as http;

Future<List<PFile>> fetchNotes(String endpoint) async {
  final response = await http.get(Uri.parse(endpoint));
  print(response.statusCode);
  //print(response.body);
  if (response.statusCode == 200) {
    Iterable l = jsonDecode(response.body);
    List<PFile> files =
        List<PFile>.from(l.map((model) => PFile.fromJson(model)));
    return files;
  } else {
    throw Exception('failed to load patients');
  }
}

class PatientFiles extends StatefulWidget {
  final int patientIndex;
  const PatientFiles({super.key, required this.patientIndex});

  @override
  State<PatientFiles> createState() => _PatientFilesState();
}

class _PatientFilesState extends State<PatientFiles> {
  String endpoint = "http://localhost:80/files/patients/";
  String apiUrlAddNote = "http://localhost:80/notes/insert/";
  final startDateController = TextEditingController();
  final endDateTextController = TextEditingController();
  late Future<List<PFile>> futueFiles;

  Future<void> addPatientNoteAPICall() async {
    var response = await http.post(
      Uri.parse(apiUrlAddNote),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "note_name": startDateController.text,
        "note_text": endDateTextController.text,
        "patient_id": widget.patientIndex,
      }),
    );
    if (response.statusCode == 201) {
      setState(() {
        futueFiles = fetchNotes(endpoint + widget.patientIndex.toString());
      });
      // Navigator.of(context)
      //     .pushNamed('/patient-manager', arguments: widget.userEmail);
      String message = "Successfully added Files";
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
    futueFiles = fetchNotes(endpoint + widget.patientIndex.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futueFiles,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final filesList = snapshot.data!;
          return Flexible(
            flex: 1,
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
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Files",
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Create Medical Certificate"),
                                    ],
                                  ),
                                  content: SizedBox(
                                    height: 250,
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 50.0),
                                        SizedBox(
                                          width: 700,
                                          child: MyDateField(
                                            controller: startDateController,
                                            LableText: "From",
                                          ),
                                        ),
                                        const SizedBox(height: 25.0),
                                        SizedBox(
                                          width: 700,
                                          child: MyDateField(
                                            controller: endDateTextController,
                                            LableText: "Up to Including",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        //addPatientNoteAPICall();
                                        Navigator.pop(context);
                                        //print(widget.patientIndex);
                                      },
                                      child: const Text(
                                        "Generate",
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
                            icon: const Icon(Icons.sick_outlined),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.medication_outlined),
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Divider(),
                      ),
                      const SizedBox(height: 10),
                      BuildFilesList(files: filesList),
                    ]),
                  ),
                ),
              ),
            ),
          );
        } else {
          return const Center(
            child: Text("Error Loading Files"),
          );
        }
      },
    );
  }
}
