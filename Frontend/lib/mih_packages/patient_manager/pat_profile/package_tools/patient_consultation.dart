import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/list_builders/build_notes_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientConsultation extends StatefulWidget {
  const PatientConsultation({
    super.key,
  });

  @override
  State<PatientConsultation> createState() => _PatientConsultationState();
}

class _PatientConsultationState extends State<PatientConsultation> {
  final titleController = TextEditingController();
  final noteTextController = TextEditingController();
  final officeController = TextEditingController();
  final dateController = TextEditingController();
  final doctorController = TextEditingController();
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  String endpoint = "${AppEnviroment.baseApiUrl}/notes/patients/";
  final _formKey = GlobalKey<FormState>();

  Future<void> addPatientNoteAPICall(
    MzansiProfileProvider profileProvider,
    PatientManagerProvider patManProvider,
  ) async {
    int statuscode = await MihPatientServices().addPatientNoteAPICall(
      titleController.text,
      noteTextController.text,
      profileProvider,
      patManProvider,
    );
    if (statuscode == 201) {
      context.pop();
      MihAlertServices().successBasicAlert(
        "Success!",
        "Note added successfully.",
        context,
      );
      titleController.clear();
      noteTextController.clear();
      officeController.clear();
      dateController.clear();
      doctorController.clear();
    } else {
      MihAlertServices().internetConnectionAlert(context);
    }
  }

  void addNotePopUp(
    MzansiProfileProvider profileProvider,
    PatientManagerProvider patManProvider,
    double width,
  ) {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    var title = "";
    KenLogger.success("Business User: ${profileProvider.businessUser}");
    if (profileProvider.businessUser?.title == "Doctor") {
      title = "Dr.";
    }
    setState(() {
      officeController.text = profileProvider.business!.Name;
      doctorController.text =
          "$title ${profileProvider.user!.fname} ${profileProvider.user!.lname}";
      dateController.text = date.toString().substring(0, 10);
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Add Note",
        onWindowTapClose: () {
          context.pop(context);
          titleController.clear();
          noteTextController.clear();
        },
        windowBody: Padding(
          padding:
              MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.05)
                  : const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              MihForm(
                formKey: _formKey,
                formFields: [
                  MihTextFormField(
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    controller: officeController,
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
                    controller: doctorController,
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
                    controller: titleController,
                    multiLineInput: false,
                    requiredText: true,
                    hintText: "Note Title",
                    validator: (value) {
                      return MihValidationServices().isEmpty(value);
                    },
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
                    hintText: "Note Details",
                    validator: (value) {
                      return MihValidationServices().validateLength(value, 512);
                    },
                  ),
                  SizedBox(
                    height: 15,
                    child: ValueListenableBuilder(
                      builder:
                          (BuildContext context, int value, Widget? child) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "$value",
                              style: TextStyle(
                                color: getNoteDetailLimitColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "/512",
                              style: TextStyle(
                                color: getNoteDetailLimitColor(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                      valueListenable: _counter,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Center(
                    child: MihButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addPatientNoteAPICall(
                              profileProvider, patManProvider);
                        } else {
                          MihAlertServices().inputErrorAlert(context);
                        }
                      },
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        "Add Note",
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
      return MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark");
    } else {
      return MihColors.getRedColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark");
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
    noteTextController.addListener(() {
      setState(() {
        _counter.value = noteTextController.text.characters.length;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(screenWidth),
    );
  }

  Widget getBody(double width) {
    return Consumer2<MzansiProfileProvider, PatientManagerProvider>(
      builder: (BuildContext context, MzansiProfileProvider profileProvider,
          PatientManagerProvider patientManagerProvider, Widget? child) {
        return Stack(
          children: [
            BuildNotesList(),
            Visibility(
              visible: !patientManagerProvider.personalMode,
              child: Positioned(
                right: 10,
                bottom: 10,
                child: MihFloatingMenu(
                  icon: Icons.add,
                  animatedIcon: AnimatedIcons.menu_close,
                  children: [
                    SpeedDialChild(
                      child: Icon(
                        Icons.add,
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                      label: "Add Note",
                      labelBackgroundColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      labelStyle: TextStyle(
                        color: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        fontWeight: FontWeight.bold,
                      ),
                      backgroundColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      onTap: () {
                        // addConsultationNotePopUp();
                        addNotePopUp(
                            profileProvider, patientManagerProvider, width);
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
