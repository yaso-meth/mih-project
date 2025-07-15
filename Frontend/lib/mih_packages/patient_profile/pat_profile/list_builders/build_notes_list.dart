import 'dart:convert';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_delete_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/notes.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patients.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

class BuildNotesList extends StatefulWidget {
  final AppUser signedInUser;
  final List<Note> notes;
  final Patient selectedPatient;
  final Business? business;
  final BusinessUser? businessUser;
  final String type;
  const BuildNotesList({
    super.key,
    required this.notes,
    required this.signedInUser,
    required this.selectedPatient,
    required this.business,
    required this.businessUser,
    required this.type,
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
    bool hasAccessToDelete = false;
    if (widget.type == "business" &&
        selectednote.doc_office == widget.business!.Name) {
      hasAccessToDelete = true;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Note Details",
        menuOptions: hasAccessToDelete
            ? [
                SpeedDialChild(
                  child: Icon(
                    Icons.delete,
                    color:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                  label: "Delete Note",
                  labelBackgroundColor:
                      MzansiInnovationHub.of(context)!.theme.successColor(),
                  labelStyle: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor:
                      MzansiInnovationHub.of(context)!.theme.successColor(),
                  onTap: () {
                    deletePatientPopUp(selectednote.idpatient_notes);
                  },
                ),
              ]
            : null,
        onWindowTapClose: () {
          Navigator.pop(context);
        },
        windowBody: Column(
          children: [
            const SizedBox(height: 10.0),
            MihTextFormField(
              fillColor:
                  MzansiInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
              controller: businessNameController,
              multiLineInput: false,
              requiredText: true,
              readOnly: true,
              hintText: "Office",
            ),
            const SizedBox(height: 10.0),
            MihTextFormField(
              fillColor:
                  MzansiInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
              controller: userNameController,
              multiLineInput: false,
              requiredText: true,
              readOnly: true,
              hintText: "Created By",
            ),
            const SizedBox(height: 10.0),
            MihTextFormField(
              fillColor:
                  MzansiInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
              controller: dateController,
              multiLineInput: false,
              requiredText: true,
              readOnly: true,
              hintText: "Created Date",
            ),
            const SizedBox(height: 10.0),
            MihTextFormField(
              fillColor:
                  MzansiInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
              controller: noteTitleController,
              multiLineInput: false,
              requiredText: true,
              readOnly: true,
              hintText: "Note Title",
            ),
            const SizedBox(height: 10.0),
            MihTextFormField(
              height: 250,
              fillColor:
                  MzansiInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzansiInnovationHub.of(context)!.theme.primaryColor(),
              controller: noteTextController,
              multiLineInput: true,
              requiredText: true,
              readOnly: true,
              hintText: "Note Details",
            ),
            const SizedBox(height: 10.0),
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
    if (widget.notes.isNotEmpty) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) {
          return Divider(
            color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
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
                color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ),
            subtitle: Text(
              "${widget.notes[index].insert_date}:\n$notePreview",
              style: TextStyle(
                color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
              ),
            ), //Text(widget.notes[index].note_text),
            trailing: Icon(
              Icons.arrow_forward,
              color: MzansiInnovationHub.of(context)!.theme.secondaryColor(),
            ),
            onTap: () {
              viewNotePopUp(widget.notes[index]);
            },
          );
        },
      );
    } else {
      return const Center(
        child: Text(
          "No Notes Available",
          style: TextStyle(fontSize: 25, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
