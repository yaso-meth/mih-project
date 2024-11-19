import 'dart:convert';

import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:supertokens_flutter/http.dart' as http;

import '../../mih_components/mih_inputs_and_buttons/mih_button.dart';
import '../../mih_components/mih_inputs_and_buttons/mih_multiline_text_input.dart';
import '../../mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import '../../mih_components/mih_layout/mih_window.dart';
import '../../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../../mih_env/env.dart';
import '../../mih_objects/app_user.dart';
import '../../mih_objects/business.dart';
import '../../mih_objects/business_user.dart';
import '../../mih_objects/notes.dart';
import '../../mih_objects/patients.dart';
import 'builder/build_notes_list.dart';

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
  //int noteDetailCount = 0;
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);

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
      builder: (context) => MIHWindow(
        fullscreen: false,
        windowTitle: "Add Note",
        windowTools: const [],
        onWindowTapClose: () {
          Navigator.pop(context);
          titleController.clear();
          noteTextController.clear();
        },
        windowBody: [
          MIHTextField(
            controller: officeController,
            hintText: "Office",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: doctorController,
            hintText: "Created By",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: dateController,
            hintText: "Created Date",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: titleController,
            hintText: "Note Title",
            editable: true,
            required: true,
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            //width: 700,
            height: 250,
            child: MIHMLTextField(
              controller: noteTextController,
              hintText: "Note Details",
              editable: true,
              required: true,
            ),
          ),
          SizedBox(
            height: 15,
            child: ValueListenableBuilder(
              builder: (BuildContext context, int value, Widget? child) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "$value",
                      style: TextStyle(
                        color: getNoteDetailLimitColor(),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "/512",
                      style: TextStyle(
                        color: getNoteDetailLimitColor(),
                      ),
                    ),
                  ],
                );
              },
              valueListenable: _counter,
            ),
          ),
          const SizedBox(height: 15.0),
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
                      return const MIHErrorMessage(errorType: "Input Error");
                    },
                  );
                }
              },
              buttonText: "Add Note",
              buttonColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            ),
          )
        ],
      ),
    );
  }

  Color getNoteDetailLimitColor() {
    if (_counter.value <= 512) {
      return MzanziInnovationHub.of(context)!.theme.secondaryColor();
    } else {
      return MzanziInnovationHub.of(context)!.theme.errorColor();
    }
  }

  bool isFieldsFilled() {
    if (titleController.text.isEmpty ||
        noteTextController.text.isEmpty ||
        _counter.value >= 512) {
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
    doctorController.dispose();
    dateController.dispose();
    officeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    futueNotes = fetchNotes(endpoint + widget.patientAppId);
    // setState(() {
    //   noteDetailCount = noteTextController.text.length;
    // });
    noteTextController.addListener(() {
      setState(() {
        _counter.value = noteTextController.text.characters.length;
      });
      print(_counter.value);
    });
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
              type: widget.type,
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
