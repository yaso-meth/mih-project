import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:patient_manager/components/mihDeleteMessage.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/components/myMLTextInput.dart';
import 'package:patient_manager/components/mySuccessMessage.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
//import 'package:patient_manager/components/mybutton.dart';
import 'package:patient_manager/objects/notes.dart';
import 'package:supertokens_flutter/http.dart' as http;

class BuildNotesList extends StatefulWidget {
  final AppUser signedInUser;
  final List<Note> notes;
  const BuildNotesList({
    super.key,
    required this.notes,
    required this.signedInUser,
  });

  @override
  State<BuildNotesList> createState() => _BuildNotesListState();
}

class _BuildNotesListState extends State<BuildNotesList> {
  final noteTextController = TextEditingController();
  int indexOn = 0;
  final baseAPI = AppEnviroment.baseApiUrl;

  Future<void> deleteNoteApiCall(int NoteId) async {
    //print("Here1");
    //userEmail = getLoginUserEmail() as String;
    //print(userEmail);
    //print("Here2");
    //await getOfficeIdByUser(docOfficeIdApiUrl + userEmail);
    //print("Office ID: ${futureDocOfficeId.toString()}");
    //print("OPatient ID No: ${idController.text}");
    //print("Here3");
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
      Navigator.of(context)
          .pushNamed('/patient-profile', arguments: widget.signedInUser);
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
        return const MyErrorMessage(errorType: "Internet Connection");
      },
    );
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

  void viewNotePopUp(String title, String note, int noteId) {
    setState(() {
      noteTextController.text = note;
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
                //mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deletePatientPopUp(noteId);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25.0),
                  Expanded(
                    child: MyMLTextField(
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
                  //   child: MyButton(
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
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notes.isNotEmpty) {
      return SizedBox(
        height: 290.0,
        child: ListView.separated(
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            );
          },
          itemCount: widget.notes.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                widget.notes[index].note_name,
                style: TextStyle(
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
              subtitle: Text(
                "${widget.notes[index].insert_date}:\n${widget.notes[index].note_text}",
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
                viewNotePopUp(
                    widget.notes[index].note_name,
                    "${widget.notes[index].insert_date}:\n${widget.notes[index].note_text}",
                    widget.notes[index].idpatient_notes);
              },
            );
          },
        ),
      );
    } else {
      return const SizedBox(
        height: 290.0,
        child: Center(
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
