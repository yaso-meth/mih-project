import 'dart:convert';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_multiline_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/notes.dart';
import 'package:mzansi_innovation_hub/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/list_builders/build_notes_list.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

class PatientConsultation extends StatefulWidget {
  final String patientAppId;
  final Patient selectedPatient;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final String type;
  const PatientConsultation({
    super.key,
    required this.patientAppId,
    required this.selectedPatient,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
    required this.type,
  });

  @override
  State<PatientConsultation> createState() => _PatientConsultationState();
}

class _PatientConsultationState extends State<PatientConsultation> {
  late Future<List<Note>> futueNotes;
  final titleController = TextEditingController();
  final noteTextController = TextEditingController();
  final officeController = TextEditingController();
  final dateController = TextEditingController();
  final doctorController = TextEditingController();
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  String endpoint = "${AppEnviroment.baseApiUrl}/notes/patients/";

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

  void addNotePopUp() {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    var title = "";
    print("Business User: ${widget.businessUser}");
    if (widget.businessUser?.title == "Doctor") {
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
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Add Note",
        windowTools: null,
        onWindowTapClose: () {
          Navigator.pop(context);
          titleController.clear();
          noteTextController.clear();
        },
        windowBody: Column(
          children: [
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
                textColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
              ),
            )
          ],
        ),
      ),
    );
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

  bool isFieldsFilled() {
    if (titleController.text.isEmpty ||
        noteTextController.text.isEmpty ||
        _counter.value >= 512) {
      return false;
    } else {
      return true;
    }
  }

  Color getNoteDetailLimitColor() {
    if (_counter.value <= 512) {
      return MzanziInnovationHub.of(context)!.theme.secondaryColor();
    } else {
      return MzanziInnovationHub.of(context)!.theme.errorColor();
    }
  }

  List<Widget> setIcons() {
    if (widget.type == "personal") {
      return [
        Text(
          "Consultation Notes",
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
          "Consultation Notes",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        ),
        IconButton(
          onPressed: () {
            // addConsultationNotePopUp();
            addNotePopUp();
          },
          icon: Icon(Icons.add,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
        )
      ];
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
    noteTextController.addListener(() {
      setState(() {
        _counter.value = noteTextController.text.characters.length;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: FutureBuilder(
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
                    children: [
                      Text(
                        "Consultation Notes",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor()),
                      ),
                    ],
                  ),
                  Divider(
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor()),
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
          ),
        ),
        Visibility(
          visible: widget.type != "personal",
          child: Positioned(
            right: 0,
            bottom: 0,
            child: MihFloatingMenu(
              icon: Icons.add,
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  child: Icon(
                    Icons.add,
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                  label: "Add Note",
                  labelBackgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
                  labelStyle: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
                  onTap: () {
                    // addConsultationNotePopUp();
                    addNotePopUp();
                  },
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
