import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_providers/patient_manager_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MihEditPatientDetailsWindow extends StatefulWidget {
  const MihEditPatientDetailsWindow({super.key});

  @override
  State<MihEditPatientDetailsWindow> createState() =>
      _MihEditPatientDetailsWindowState();
}

class _MihEditPatientDetailsWindowState
    extends State<MihEditPatientDetailsWindow> {
  var idController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final cellController = TextEditingController();
  final emailController = TextEditingController();
  final medNoController = TextEditingController();
  final medNameController = TextEditingController();
  final medSchemeController = TextEditingController();
  final addressController = TextEditingController();
  final medAidController = TextEditingController();
  final medMainMemController = TextEditingController();
  final medAidCodeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late bool medAidPosition;
  late bool medMainMemberPosition;
  final ValueNotifier<bool> medRequired = ValueNotifier(false);

  Future<void> updatePatientApiCall(
      PatientManagerProvider patientManagerProvider) async {
    try {
      var statusCode = await MihPatientServices().updatePatientService(
        patientManagerProvider.selectedPatient!.app_id,
        idController.text,
        fnameController.text,
        lnameController.text,
        emailController.text,
        cellController.text,
        medAidController.text,
        medMainMemController.text,
        medNoController.text,
        medAidCodeController.text,
        medNameController.text,
        medSchemeController.text,
        addressController.text,
        patientManagerProvider,
      );
      if (statusCode == 200) {
        successPopUp(
          "Successfully Updated Profile!",
          "${fnameController.text} ${lnameController.text}'s information has been updated successfully! Their medical records and details are now current.",
        );
      } else {
        MihAlertServices().errorBasicAlert(
          "Error Updating Profile",
          "There was an error updating your profile. Please try again later.",
          context,
        );
      }
    } catch (error) {
      MihAlertServices().internetConnectionAlert(context);
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
          buttonColor: MihColors.primary(),
          elevation: 10,
          width: 300,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: MihColors.secondary(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      context,
    );
  }

  Widget displayForm(
      PatientManagerProvider patientManagerProvider, double width) {
    return SingleChildScrollView(
      child: Padding(
        padding: MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
            ? EdgeInsets.symmetric(horizontal: width * 0.05)
            : const EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: [
            MihForm(
              formKey: _formKey,
              formFields: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Personal",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: MihColors.secondary(),
                      ),
                    ),
                  ],
                ),
                Divider(color: MihColors.secondary()),
                const SizedBox(height: 10.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "*NB: Internet connection required to update profile.",
                    style: TextStyle(
                      color: MihColors.red(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                MihTextFormField(
                  fillColor: MihColors.secondary(),
                  inputColor: MihColors.primary(),
                  controller: idController,
                  multiLineInput: false,
                  requiredText: true,
                  hintText: "ID No.",
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
                const SizedBox(height: 10.0),
                MihTextFormField(
                  fillColor: MihColors.secondary(),
                  inputColor: MihColors.primary(),
                  controller: fnameController,
                  multiLineInput: false,
                  requiredText: true,
                  readOnly: true,
                  hintText: "First Name",
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
                const SizedBox(height: 10.0),
                MihTextFormField(
                  fillColor: MihColors.secondary(),
                  inputColor: MihColors.primary(),
                  controller: lnameController,
                  multiLineInput: false,
                  requiredText: true,
                  readOnly: true,
                  hintText: "Surname",
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
                const SizedBox(height: 10.0),
                MihTextFormField(
                  fillColor: MihColors.secondary(),
                  inputColor: MihColors.primary(),
                  controller: cellController,
                  multiLineInput: false,
                  requiredText: true,
                  hintText: "Cell No.",
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
                const SizedBox(height: 10.0),
                MihTextFormField(
                  fillColor: MihColors.secondary(),
                  inputColor: MihColors.primary(),
                  controller: emailController,
                  multiLineInput: false,
                  requiredText: true,
                  readOnly: true,
                  hintText: "Email",
                  validator: (value) {
                    return MihValidationServices().validateEmail(value);
                  },
                ),
                const SizedBox(height: 10.0),
                MihTextFormField(
                  height: 100,
                  fillColor: MihColors.secondary(),
                  inputColor: MihColors.primary(),
                  controller: addressController,
                  multiLineInput: true,
                  requiredText: true,
                  hintText: "Address",
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
                const SizedBox(height: 15.0),
                Center(
                  child: Text(
                    "Medical Aid Details",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                      color: MihColors.secondary(),
                    ),
                  ),
                ),
                Divider(color: MihColors.secondary()),
                const SizedBox(height: 10.0),
                MihToggle(
                  hintText: "Medical Aid",
                  initialPostion: medAidPosition,
                  fillColor: MihColors.secondary(),
                  secondaryFillColor: MihColors.primary(),
                  onChange: (value) {
                    if (value) {
                      setState(() {
                        medAidController.text = "Yes";
                        medAidPosition = value;
                      });
                    } else {
                      setState(() {
                        medAidController.text = "No";
                        medAidPosition = value;
                      });
                    }
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: medRequired,
                  builder: (BuildContext context, bool value, Widget? child) {
                    return Visibility(
                      visible: value,
                      child: Column(
                        children: [
                          const SizedBox(height: 10.0),
                          MihToggle(
                            hintText: "Main Member",
                            initialPostion: medMainMemberPosition,
                            fillColor: MihColors.secondary(),
                            secondaryFillColor: MihColors.primary(),
                            onChange: (value) {
                              if (value) {
                                setState(() {
                                  medMainMemController.text = "Yes";
                                  medMainMemberPosition = value;
                                });
                              } else {
                                setState(() {
                                  medMainMemController.text = "No";
                                  medMainMemberPosition = value;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 10.0),
                          MihTextFormField(
                            fillColor: MihColors.secondary(),
                            inputColor: MihColors.primary(),
                            controller: medNoController,
                            multiLineInput: false,
                            requiredText: true,
                            hintText: "No.",
                            validator: (validationValue) {
                              if (value) {
                                return MihValidationServices()
                                    .isEmpty(validationValue);
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          MihTextFormField(
                            fillColor: MihColors.secondary(),
                            inputColor: MihColors.primary(),
                            controller: medAidCodeController,
                            multiLineInput: false,
                            requiredText: true,
                            hintText: "Code",
                            validator: (validationValue) {
                              if (value) {
                                return MihValidationServices()
                                    .isEmpty(validationValue);
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          MihTextFormField(
                            fillColor: MihColors.secondary(),
                            inputColor: MihColors.primary(),
                            controller: medNameController,
                            multiLineInput: false,
                            requiredText: true,
                            hintText: "Name",
                            validator: (validationValue) {
                              if (value) {
                                return MihValidationServices()
                                    .isEmpty(validationValue);
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          MihTextFormField(
                            fillColor: MihColors.secondary(),
                            inputColor: MihColors.primary(),
                            controller: medSchemeController,
                            multiLineInput: false,
                            requiredText: true,
                            hintText: "Plan",
                            validator: (validationValue) {
                              if (value) {
                                return MihValidationServices()
                                    .isEmpty(validationValue);
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: MihButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updatePatientApiCall(patientManagerProvider);
                      } else {
                        MihAlertServices().inputErrorAlert(context);
                      }
                    },
                    buttonColor: MihColors.green(),
                    width: 300,
                    child: Text(
                      "Update",
                      style: TextStyle(
                        color: MihColors.primary(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void isRequired() {
    if (medAidController.text == "Yes") {
      medRequired.value = true;
    } else if (medAidController.text == "No") {
      medRequired.value = false;
    } else {}
  }

  @override
  void dispose() {
    idController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    cellController.dispose();
    emailController.dispose();
    medNoController.dispose();
    medNameController.dispose();
    medSchemeController.dispose();
    addressController.dispose();
    medAidController.dispose();
    medAidCodeController.removeListener(isRequired);
    medMainMemController.dispose();
    medAidCodeController.dispose();
    medRequired.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    medAidController.addListener(isRequired);
    PatientManagerProvider patientManagerProvider =
        context.read<PatientManagerProvider>();
    setState(() {
      idController.text = patientManagerProvider.selectedPatient!.id_no;
      fnameController.text = patientManagerProvider.selectedPatient!.first_name;
      lnameController.text = patientManagerProvider.selectedPatient!.last_name;
      cellController.text = patientManagerProvider.selectedPatient!.cell_no;
      emailController.text = patientManagerProvider.selectedPatient!.email;
      medNameController.text =
          patientManagerProvider.selectedPatient!.medical_aid_name;
      medNoController.text =
          patientManagerProvider.selectedPatient!.medical_aid_no;
      medSchemeController.text =
          patientManagerProvider.selectedPatient!.medical_aid_scheme;
      addressController.text = patientManagerProvider.selectedPatient!.address;
      medAidController.text =
          patientManagerProvider.selectedPatient!.medical_aid;
      medMainMemController.text =
          patientManagerProvider.selectedPatient!.medical_aid_main_member;
      medAidCodeController.text =
          patientManagerProvider.selectedPatient!.medical_aid_code;
    });
    if (medAidController.text == "Yes") {
      medAidPosition = true;
    } else {
      medAidPosition = false;
      medAidController.text = "No";
    }
    if (medMainMemController.text == "Yes") {
      medMainMemberPosition = true;
    } else {
      medMainMemberPosition = false;
      medMainMemController.text = "No";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "Edit Patient Details",
      onWindowTapClose: () {
        context.pop();
      },
      windowBody: getBody(size.width),
    );
  }

  Widget getBody(double width) {
    return Consumer<PatientManagerProvider>(
      builder: (BuildContext context,
          PatientManagerProvider patientManagerProvider, Widget? child) {
        return KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (event) async {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              if (_formKey.currentState!.validate()) {
                updatePatientApiCall(patientManagerProvider);
              } else {
                MihAlertServices().inputErrorAlert(context);
              }
            }
          },
          child: displayForm(patientManagerProvider, width),
        );
      },
    );
  }
}
