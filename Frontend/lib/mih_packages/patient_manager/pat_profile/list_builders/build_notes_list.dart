import 'dart:convert';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_delete_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
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
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                  label: "Delete Note",
                  labelBackgroundColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  labelStyle: TextStyle(
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
              fillColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              inputColor: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              controller: businessNameController,
              multiLineInput: false,
              requiredText: true,
              readOnly: true,
              hintText: "Office",
            ),
            const SizedBox(height: 10.0),
            MihTextFormField(
              fillColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              inputColor: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              controller: userNameController,
              multiLineInput: false,
              requiredText: true,
              readOnly: true,
              hintText: "Created By",
            ),
            const SizedBox(height: 10.0),
            MihTextFormField(
              fillColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              inputColor: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              controller: dateController,
              multiLineInput: false,
              requiredText: true,
              readOnly: true,
              hintText: "Created Date",
            ),
            const SizedBox(height: 10.0),
            MihTextFormField(
              fillColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              inputColor: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              controller: noteTitleController,
              multiLineInput: false,
              requiredText: true,
              readOnly: true,
              hintText: "Note Title",
            ),
            const SizedBox(height: 10.0),
            MihTextFormField(
              height: 250,
              fillColor: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              inputColor: MihColors.getPrimaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
            color: MihColors.getSecondaryColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ),
            subtitle: Text(
              "${widget.notes[index].insert_date}:\n$notePreview",
              style: TextStyle(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
            ), //Text(widget.notes[index].note_text),
            trailing: Icon(
              Icons.arrow_forward,
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
            ),
            onTap: () {
              viewNotePopUp(widget.notes[index]);
            },
          );
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 50),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Icon(
                  MihIcons.mihRing,
                  size: 165,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                Icon(
                  Icons.article_outlined,
                  size: 110,
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    "No Notes have been added to this profile.",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Visibility(
              visible: widget.business != null,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                    children: [
                      TextSpan(text: "Press "),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.menu,
                          size: 20,
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                        ),
                      ),
                      TextSpan(text: " to add the first note"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      // return const Center(
      //   child: Text(
      //     "No Notes Available",
      //     style: TextStyle(fontSize: 25, color: Colors.grey),
      //     textAlign: TextAlign.center,
      //   ),
      // );
    }
  }
}
