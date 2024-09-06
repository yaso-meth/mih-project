import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/inputsAndButtons/mihTextInput.dart';
import 'package:patient_manager/components/popUpMessages/mihDeleteMessage.dart';
import 'package:patient_manager/components/popUpMessages/mihErrorMessage.dart';
import 'package:patient_manager/components/inputsAndButtons/mihMLTextInput.dart';
import 'package:patient_manager/components/popUpMessages/mihSuccessMessage.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:patient_manager/objects/arguments.dart';
import 'package:patient_manager/objects/business.dart';
import 'package:patient_manager/objects/businessUser.dart';
//import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/objects/notes.dart';
import 'package:patient_manager/objects/patients.dart';
import 'package:supertokens_flutter/http.dart' as http;

class BuildNotesList extends StatefulWidget {
  final AppUser signedInUser;
  final List<Note> notes;
  final Patient selectedPatient;
  final Business? business;
  final BusinessUser? businessUser;
  const BuildNotesList({
    super.key,
    required this.notes,
    required this.signedInUser,
    required this.selectedPatient,
    required this.business,
    required this.businessUser,
  });

  @override
  State<BuildNotesList> createState() => _BuildNotesListState();
}

class _BuildNotesListState extends State<BuildNotesList> {
  final noteTitleController = TextEditingController();
  final noteTextController = TextEditingController();
  final businessNameController = TextEditingController();
  final userNameController = TextEditingController();
  final dateController = TextEditingController();
  int indexOn = 0;
  final baseAPI = AppEnviroment.baseApiUrl;

  Future<void> deleteNoteApiCall(int NoteId) async {
    var response = await http.delete(
      Uri.parse("$baseAPI/notes/delete/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{"idpatient_notes": NoteId}),
    );
    //print("Here4");
    //print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      if (widget.business == null) {
        Navigator.of(context).pushNamed('/patient-manager/patient',
            arguments: PatientViewArguments(
                widget.signedInUser,
                widget.selectedPatient,
                widget.businessUser,
                widget.business,
                "personal"));
      } else {
        Navigator.of(context).pushNamed('/patient-manager/patient',
            arguments: PatientViewArguments(
                widget.signedInUser,
                widget.selectedPatient,
                widget.businessUser,
                widget.business,
                "business"));
      }
      setState(() {});
      String message =
          "The note has been deleted successfully. This means it will no longer be visible on your and cannot be used for future appointments.";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
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

  void deletePatientPopUp(int NoteId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MIHDeleteMessage(
        deleteType: "Note",
        onTap: () {
          deleteNoteApiCall(NoteId);
        },
      ),
    );
  }

  void viewNotePopUp(Note selectednote) {
    setState(() {
      noteTitleController.text = selectednote.note_name;
      noteTextController.text = selectednote.note_text;
      businessNameController.text = selectednote.doc_office;
      userNameController.text = selectednote.doctor;
      dateController.text = selectednote.insert_date;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(15.0),
              width: 700.0,
              //height: 475.0,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    width: 5.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    selectednote.note_name,
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
                      controller: businessNameController,
                      hintText: "Office",
                      editable: false,
                      required: false,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 700,
                    child: MIHTextField(
                      controller: userNameController,
                      hintText: "Created By",
                      editable: false,
                      required: false,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 700,
                    child: MIHTextField(
                      controller: dateController,
                      hintText: "Created Date",
                      editable: false,
                      required: false,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: 700,
                    child: MIHTextField(
                      controller: noteTitleController,
                      hintText: "Note Title",
                      editable: false,
                      required: false,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: MIHMLTextField(
                      controller: noteTextController,
                      hintText: "Note Details",
                      editable: false,
                      required: false,
                    ),
                  ),
                  //const SizedBox(height: 25.0),
                  // SizedBox(
                  //   width: 300,
                  //   height: 100,
                  //   child: MIHButton(
                  //     onTap: () {
                  //       Navigator.pop(context);
                  //     },
                  //     buttonText: "Close",
                  //     buttonColor: Colors.blueAccent,
                  //     textColor: Colors.white,
                  //   ),
                  // )
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
                },
                icon: Icon(
                  Icons.close,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                  size: 35,
                ),
              ),
            ),
            Positioned(
              top: 5,
              left: 5,
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  deletePatientPopUp(selectednote.idpatient_notes);
                },
                icon: Icon(
                  Icons.delete,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    noteTextController.dispose();
    businessNameController.dispose();
    userNameController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    //double width = size.width;
    double height = size.height;
    if (widget.notes.isNotEmpty) {
      return SizedBox(
        height: height - 173,
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            );
          },
          itemCount: widget.notes.length,
          itemBuilder: (context, index) {
            String notePreview = widget.notes[index].note_text;
            if (notePreview.length > 30) {
              notePreview = "${notePreview.substring(0, 30)} ...";
            }
            return ListTile(
              title: Text(
                "${widget.notes[index].note_name}\n${widget.notes[index].doc_office} - ${widget.notes[index].doctor}",
                style: TextStyle(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
              subtitle: Text(
                "${widget.notes[index].insert_date}:\n$notePreview",
                style: TextStyle(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ), //Text(widget.notes[index].note_text),
              trailing: Icon(
                Icons.arrow_forward,
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              ),
              onTap: () {
                viewNotePopUp(widget.notes[index]);
              },
            );
          },
        ),
      );
    } else {
      return SizedBox(
        height: height - 173,
        child: const Center(
          child: Text(
            "No Notes Available",
            style: TextStyle(fontSize: 25, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }
}
