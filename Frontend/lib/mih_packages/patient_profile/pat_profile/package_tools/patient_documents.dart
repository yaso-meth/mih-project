import 'dart:convert';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_date_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/files.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/patients.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/components/prescip_input.dart';
import 'package:mzansi_innovation_hub/mih_packages/patient_profile/pat_profile/list_builders/build_files_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

class PatientDocuments extends StatefulWidget {
  final int patientIndex;
  final Patient selectedPatient;
  final AppUser signedInUser;
  final Business? business;
  final BusinessUser? businessUser;
  final String type;
  const PatientDocuments({
    super.key,
    required this.patientIndex,
    required this.selectedPatient,
    required this.signedInUser,
    required this.business,
    required this.businessUser,
    required this.type,
  });

  @override
  State<PatientDocuments> createState() => _PatientDocumentsState();
}

class _PatientDocumentsState extends State<PatientDocuments> {
  late Future<List<PFile>> futueFiles;
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

  Future<void> submitDocUploadForm() async {
    if (isFileFieldsFilled()) {
      await uploadSelectedFile(selected);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    }
  }

  Future<List<PFile>> fetchFiles() async {
    final response = await http.get(Uri.parse(
        "${AppEnviroment.baseApiUrl}/patient_files/get/${widget.selectedPatient.app_id}"));
    //print(response.statusCode);
    //print(response.body);
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      List<PFile> files =
          List<PFile>.from(l.map((model) => PFile.fromJson(model)));
      return files;
    } else {
      internetConnectionPopUp();
      throw Exception('failed to load patients');
    }
  }

  Future<void> addPatientFileLocationToDB(PlatformFile? file) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var fname = file!.name.replaceAll(RegExp(r' '), '-');
    var filePath = "${widget.selectedPatient.app_id}/patient_files/$fname";
    var response2 = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/patient_files/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "file_path": filePath,
        "file_name": fname,
        "app_id": widget.selectedPatient.app_id
      }),
    );
    //print("here5");
    //print(response2.statusCode);
    if (response2.statusCode == 201) {
      setState(() {
        selectedFileController.clear();
        futueFiles = fetchFiles();
      });
      // end loading circle
      Navigator.of(context).pop();
      String message =
          "The file ${file.name.replaceAll(RegExp(r' '), '-')} has been successfully generated and added to ${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}'s record. You can now access and download it for their use.";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> uploadSelectedFile(PlatformFile? file) async {
    var response = await MihFileApi.uploadFile(
      widget.selectedPatient.app_id,
      env,
      "patient_files",
      file,
      context,
    );
    if (response == 200) {
      await addPatientFileLocationToDB(file);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> generateMedCert() async {
    //start loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    DateTime now = DateTime.now();
    // DateTime date = new DateTime(now.year, now.month, now.day);
    String fileName =
        "Med-Cert-${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}-${now.toString().substring(0, 19)}.pdf"
            .replaceAll(RegExp(r' '), '-');
    var response1 = await http.post(
      Uri.parse("${AppEnviroment.baseApiUrl}/minio/generate/med-cert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": widget.selectedPatient.app_id,
        "env": env,
        "patient_full_name":
            "${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}",
        "fileName": fileName,
        "id_no": widget.selectedPatient.id_no,
        "docfname":
            "DR. ${widget.signedInUser.fname} ${widget.signedInUser.lname}",
        "startDate": startDateController.text,
        "busName": widget.business!.Name,
        "busAddr": "*TO BE ADDED IN THE FUTURE*",
        "busNo": widget.business!.contact_no,
        "busEmail": widget.business!.bus_email,
        "endDate": endDateTextController.text,
        "returnDate": retDateTextController.text,
        "logo_path": widget.business!.logo_path,
        "sig_path": widget.businessUser!.sig_path,
      }),
    );
    print(response1.statusCode);
    if (response1.statusCode == 200) {
      var response2 = await http.post(
        Uri.parse("${AppEnviroment.baseApiUrl}/patient_files/insert/"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{
          "file_path":
              "${widget.selectedPatient.app_id}/patient_files/$fileName",
          "file_name": fileName,
          "app_id": widget.selectedPatient.app_id
        }),
      );
      //print(response2.statusCode);
      if (response2.statusCode == 201) {
        setState(() {
          startDateController.clear();
          endDateTextController.clear();
          retDateTextController.clear();
          futueFiles = fetchFiles();
        });
        // end loading circle
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        String message =
            "The medical certificate $fileName has been successfully generated and added to ${widget.selectedPatient.first_name} ${widget.selectedPatient.last_name}'s record. You can now access and download it for their use.";
        successPopUp(message);
      } else {
        internetConnectionPopUp();
      }
    } else {
      internetConnectionPopUp();
    }
  }

  void uploudFilePopUp(double width) {
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
                          submitDocUploadForm();
                          // uploadSelectedFile(selected);
                          Navigator.pop(context);
                        } else {
                          MihAlertServices().formNotFilledCompletely(context);
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

  void medCertPopUp() {
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
                        await generateMedCert();
                        //Navigator.pop(context);
                      } else {
                        MihAlertServices().formNotFilledCompletely(context);
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

  void prescritionPopUp() {
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
              selectedPatient: widget.selectedPatient,
              signedInUser: widget.signedInUser,
              business: widget.business,
              businessUser: widget.businessUser,
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

  Widget getMenu(double width) {
    if (widget.type == "personal") {
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
                uploudFilePopUp(width);
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
                uploudFilePopUp(width);
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
                medCertPopUp();
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
                prescritionPopUp();
              },
            ),
          ],
        ),
      );
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
    futueFiles = fetchFiles();
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
    return Stack(
      children: [
        MihSingleChildScroll(
          child: FutureBuilder(
            future: futueFiles,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Mihloadingcircle(),
                );
              } else if (snapshot.hasData) {
                final filesList = snapshot.data!;
                return Column(children: [
                  BuildFilesList(
                    files: filesList,
                    signedInUser: widget.signedInUser,
                    selectedPatient: widget.selectedPatient,
                    business: widget.business,
                    businessUser: widget.businessUser,
                    type: widget.type,
                    env: env,
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
        getMenu(width),
      ],
    );
  }
}
