import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_objects/notes.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';
import 'package:provider/provider.dart';

class BuildNotesList extends StatefulWidget {
  const BuildNotesList({
    super.key,
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

  Future<void> deleteNoteApiCall(
      PatientManagerProvider patientManagerProvider, int NoteId) async {
    int statusCode = await MihPatientServices()
        .deletePatientConsultaionNote(NoteId, patientManagerProvider);
    //print("Here4");
    //print(response.statusCode);
    if (statusCode == 200) {
      String message =
          "The note has been deleted successfully. This means it will no longer be visible on your and cannot be used for future appointments.";
      successPopUp("Successfuly Deleted", message);
    } else {
      MihAlertServices().internetConnectionLost(context);
    }
  }

  void successPopUp(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.check_circle_outline_rounded,
            size: 150,
            color: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          alertTitle: title,
          alertBody: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: MihButton(
                  onPressed: () {
                    context.pop();
                    context.pop();
                  },
                  buttonColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  elevation: 10,
                  width: 300,
                  child: Text(
                    "Dismiss",
                    style: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          alertColour: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      },
    );
  }

  void deletePatientPopUp(
      PatientManagerProvider patientManagerProvider, int NoteId) {
    MihAlertServices().deleteConfirmationMessage(
      "This note will be deleted permanently. Are you certain you want to delete it?",
      () {
        deleteNoteApiCall(patientManagerProvider, NoteId);
      },
      context,
    );
  }

  void viewNotePopUp(MzansiProfileProvider profileProvider,
      PatientManagerProvider patientManagerProvider, Note selectednote) {
    setState(() {
      noteTitleController.text = selectednote.note_name;
      noteTextController.text = selectednote.note_text;
      businessNameController.text = selectednote.doc_office;
      userNameController.text = selectednote.doctor;
      dateController.text = selectednote.insert_date;
    });
    bool hasAccessToDelete = false;
    if (!patientManagerProvider.personalMode &&
        selectednote.doc_office == profileProvider.business!.Name) {
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
                    deletePatientPopUp(
                        patientManagerProvider, selectednote.idpatient_notes);
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
    return Consumer2<MzansiProfileProvider, PatientManagerProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          PatientManagerProvider patientManagerProvider, Widget? child) {
        if (patientManagerProvider.consultationNotes!.isNotEmpty) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                color: MihColors.getSecondaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              );
            },
            itemCount: patientManagerProvider.consultationNotes!.length,
            itemBuilder: (context, index) {
              String notePreview =
                  patientManagerProvider.consultationNotes![index].note_text;
              if (notePreview.length > 30) {
                notePreview = "${notePreview.substring(0, 30)} ...";
              }
              return ListTile(
                leading: Icon(
                  Icons.note,
                  size: 50,
                  color: MihColors.getGoldColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                title: Text(
                  "${patientManagerProvider.consultationNotes![index].note_name}\n${patientManagerProvider.consultationNotes![index].doc_office} - ${patientManagerProvider.consultationNotes![index].doctor}",
                  style: TextStyle(
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
                subtitle: Text(
                  "${patientManagerProvider.consultationNotes![index].insert_date}:\n$notePreview",
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
                  viewNotePopUp(
                    profileProvider,
                    patientManagerProvider,
                    patientManagerProvider.consultationNotes![index],
                  );
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
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                    Icon(
                      Icons.article_outlined,
                      size: 110,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
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
                  visible: !patientManagerProvider.personalMode,
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
        }
      },
    );
  }
}
