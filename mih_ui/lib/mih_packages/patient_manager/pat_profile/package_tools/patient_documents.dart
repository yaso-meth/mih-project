import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_date_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/components/prescip_input.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_manager/pat_profile/list_builders/build_files_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PatientDocuments extends StatefulWidget {
  const PatientDocuments({
    super.key,
  });

  @override
  State<PatientDocuments> createState() => _PatientDocumentsState();
}

class _PatientDocumentsState extends State<PatientDocuments> {
  final selectedFileController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateTextController = TextEditingController();
  final retDateTextController = TextEditingController();
  final medicineController = TextEditingController();
  final quantityController = TextEditingController();
  final dosageController = TextEditingController();
  final timesDailyController = TextEditingController();
  final noDaysController = TextEditingController();
  final noRepeatsController = TextEditingController();
  final outputController = TextEditingController();
  late PlatformFile? selected;
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  late String env;

  Future<void> submitDocUploadForm(
      PatientManagerProvider patientManagerProvider) async {
    if (isFileFieldsFilled()) {
      await uploadSelectedFile(patientManagerProvider, selected);
    } else {
      MihAlertServices().inputErrorAlert(context);
    }
  }

  Future<void> addPatientFileLocationToDB(
      PatientManagerProvider patientManagerProvider, PlatformFile? file) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    int statusCode =
        await MihPatientServices().addPatientFile(file, patientManagerProvider);
    if (statusCode == 201) {
      setState(() {
        selectedFileController.clear();
      });
      var fname = file!.name.replaceAll(RegExp(r' '), '-');
      // end loading circle
      Navigator.of(context).pop();
      String message =
          "The file $fname has been successfully generated and added to ${patientManagerProvider.selectedPatient!.first_name} ${patientManagerProvider.selectedPatient!.last_name}'s record. You can now access and download it for their use.";
      successPopUp("Successfully Uplouded File", message);
    } else {
      MihAlertServices().internetConnectionAlert(context);
    }
  }

  Future<void> uploadSelectedFile(
      PatientManagerProvider patientManagerProvider, PlatformFile? file) async {
    var response = await MihFileApi.uploadFile(
      patientManagerProvider.selectedPatient!.app_id,
      env,
      "patient_files",
      file,
      context,
    );
    if (response == 200) {
      await addPatientFileLocationToDB(patientManagerProvider, file);
    } else {
      MihAlertServices().internetConnectionAlert(context);
    }
  }

  Future<void> generateMedCert(MzansiProfileProvider profileProvider,
      PatientManagerProvider patientManagerProvider) async {
    //start loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    int statusCodeCetificateGeneration =
        await MihPatientServices().generateMedicalCertificate(
      startDateController.text,
      endDateTextController.text,
      retDateTextController.text,
      profileProvider,
      patientManagerProvider,
    );
    DateTime now = DateTime.now();
    String fileName =
        "Med-Cert-${patientManagerProvider.selectedPatient!.first_name} ${patientManagerProvider.selectedPatient!.last_name}-${now.toString().substring(0, 19)}.pdf"
            .replaceAll(RegExp(r' '), '-');
    if (statusCodeCetificateGeneration == 200) {
      context.pop(); //Loading removal
      String message =
          "The medical certificate $fileName has been successfully generated and added to ${patientManagerProvider.selectedPatient!.first_name} ${patientManagerProvider.selectedPatient!.last_name}'s record. You can now access and download it for their use.";
      await MihPatientServices().getPatientDocuments(patientManagerProvider);
      successPopUp("Successfully Generated Certificate", message);
    } else {
      MihAlertServices().internetConnectionAlert(context);
    }
  }

  void uploudFilePopUp(
      PatientManagerProvider patientManagerProvider, double width) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Upload File",
        onWindowTapClose: () {
          Navigator.pop(context);
        },
        windowBody: Padding(
          padding:
              MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.05)
                  : const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MihForm(
                formKey: _formKey,
                formFields: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: MihTextFormField(
                          fillColor: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          inputColor: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          controller: selectedFileController,
                          hintText: "Selected File",
                          requiredText: true,
                          readOnly: true,
                          validator: (value) {
                            return MihValidationServices().isEmpty(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      MihButton(
                        onPressed: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png', 'pdf'],
                            withData: true,
                          );
                          if (result == null) return;
                          final selectedFile = result.files.first;
                          print("Selected file: $selectedFile");
                          setState(() {
                            selected = selectedFile;
                          });
                          setState(() {
                            selectedFileController.text = selectedFile.name;
                          });
                        },
                        buttonColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        child: Text(
                          "Attach",
                          style: TextStyle(
                            color: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: MihButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          submitDocUploadForm(patientManagerProvider);
                          // uploadSelectedFile(selected);
                        } else {
                          MihAlertServices().inputErrorAlert(context);
                        }
                      },
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        "Add File",
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

  void medCertPopUp(
    MzansiProfileProvider profileProvider,
    PatientManagerProvider patientManagerProvider,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Create Medical Certificate",
        onWindowTapClose: () {
          Navigator.pop(context);
        },
        windowBody: Column(
          children: [
            MihForm(
              formKey: _formKey2,
              formFields: [
                MihDateField(
                  controller: startDateController,
                  labelText: "From",
                  required: true,
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
                const SizedBox(height: 10.0),
                MihDateField(
                  controller: endDateTextController,
                  labelText: "Up to Including",
                  required: true,
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
                const SizedBox(height: 10.0),
                MihDateField(
                  controller: retDateTextController,
                  labelText: "Return",
                  required: true,
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
                // Medcertinput(
                //   startDateController: startDateController,
                //   endDateTextController: endDateTextController,
                //   retDateTextController: retDateTextController,
                // ),
                const SizedBox(height: 15.0),
                Center(
                  child: MihButton(
                    onPressed: () async {
                      if (_formKey2.currentState!.validate()) {
                        await generateMedCert(
                            profileProvider, patientManagerProvider);
                        //Navigator.pop(context);
                      } else {
                        MihAlertServices().inputErrorAlert(context);
                      }
                    },
                    buttonColor: MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    width: 300,
                    child: Text(
                      "Generate",
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
    );
  }

  void prescritionPopUp(
    MzansiProfileProvider profileProvider,
    PatientManagerProvider patientManagerProvider,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Create Prescription",
        onWindowTapClose: () {
          medicineController.clear();
          quantityController.text = "1";
          dosageController.text = "1";
          timesDailyController.text = "1";
          noDaysController.text = "1";
          noRepeatsController.text = "0";
          Navigator.pop(context);
        },
        windowBody: Column(
          children: [
            PrescripInput(
              medicineController: medicineController,
              quantityController: quantityController,
              dosageController: dosageController,
              timesDailyController: timesDailyController,
              noDaysController: noDaysController,
              noRepeatsController: noRepeatsController,
              outputController: outputController,
              selectedPatient: patientManagerProvider.selectedPatient!,
              signedInUser: profileProvider.user!,
              business: profileProvider.business,
              businessUser: profileProvider.businessUser,
              env: env,
            ),
          ],
        ),
      ),
    );
  }

  bool isFileFieldsFilled() {
    if (selectedFileController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool isMedCertFieldsFilled() {
    if (startDateController.text.isEmpty ||
        endDateTextController.text.isEmpty ||
        retDateTextController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Widget getMenu(MzansiProfileProvider profileProvider,
      PatientManagerProvider patientManagerProvider, double width) {
    if (patientManagerProvider.personalMode) {
      return Positioned(
        right: 10,
        bottom: 10,
        child: MihFloatingMenu(
          icon: Icons.add,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.attach_file,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              label: "Attach Document",
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
                uploudFilePopUp(patientManagerProvider, width);
              },
            )
          ],
        ),
      );
    } else {
      return Positioned(
        right: 10,
        bottom: 10,
        child: MihFloatingMenu(
          icon: Icons.add,
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.attach_file,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              label: "Add Document",
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
                uploudFilePopUp(patientManagerProvider, width);
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.sick_outlined,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              label: "Generate Medical Certificate",
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
                medCertPopUp(profileProvider, patientManagerProvider);
              },
            ),
            SpeedDialChild(
              child: Icon(
                Icons.medication,
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              ),
              label: "Generate Prescription",
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
                prescritionPopUp(profileProvider, patientManagerProvider);
              },
            ),
          ],
        ),
      );
    }
  }

  void successPopUp(String title, String message) {
    MihAlertServices().successAdvancedAlert(
      title,
      message,
      [
        MihButton(
          onPressed: () {
            context.pop();
            context.pop();
          },
          buttonColor: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          elevation: 10,
          width: 300,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: MihColors.getSecondaryColor(
                  MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      context,
    );
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateTextController.dispose();
    retDateTextController.dispose();
    selectedFileController.dispose();
    medicineController.dispose();
    quantityController.dispose();
    dosageController.dispose();
    timesDailyController.dispose();
    noDaysController.dispose();
    noRepeatsController.dispose();
    outputController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (AppEnviroment.getEnv() == "Prod") {
      env = "Prod";
    } else {
      env = "Dev";
    }
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
            BuildFilesList(),
            getMenu(profileProvider, patientManagerProvider, width),
          ],
        );
      },
    );
  }
}
