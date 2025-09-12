import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_patient_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_header.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_toggle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPatient extends StatefulWidget {
  final AppUser signedInUser;

  const AddPatient({
    super.key,
    required this.signedInUser,
  });

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  final idController = TextEditingController();
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

  late bool medAidPosition;
  late bool medMainMemberPosition;
  final baseAPI = AppEnviroment.baseApiUrl;
  late int futureDocOfficeId;
  //late bool medRequired;
  final ValueNotifier<bool> medRequired = ValueNotifier(false);
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool isFieldsFilled() {
    if (medRequired.value) {
      if (idController.text.isEmpty ||
          fnameController.text.isEmpty ||
          lnameController.text.isEmpty ||
          cellController.text.isEmpty ||
          emailController.text.isEmpty ||
          medNoController.text.isEmpty ||
          medNameController.text.isEmpty ||
          medSchemeController.text.isEmpty ||
          addressController.text.isEmpty ||
          medAidController.text.isEmpty ||
          medMainMemController.text.isEmpty ||
          medAidCodeController.text.isEmpty) {
        return false;
      } else {
        return true;
      }
    } else {
      if (idController.text.isEmpty ||
          fnameController.text.isEmpty ||
          lnameController.text.isEmpty ||
          cellController.text.isEmpty ||
          emailController.text.isEmpty ||
          addressController.text.isEmpty ||
          medAidController.text.isEmpty) {
        return false;
      } else {
        return true;
      }
    }
  }

  Future<void> addPatientService() async {
    int statusCode = await MihPatientServices().addPatientService(
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
      widget.signedInUser,
    );
    if (statusCode == 201) {
      String message =
          "${fnameController.text} ${lnameController.text} patient profile has been successfully added!\n";
      successPopUp("Successfully created Patient Profile", message);
    } else {
      internetConnectionPopUp();
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
                    context.goNamed(
                      'patientProfile',
                      extra: PatientViewArguments(
                        widget.signedInUser,
                        null,
                        null,
                        null,
                        "personal",
                      ),
                    );
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

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void messagePopUp(error) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(error),
        );
      },
    );
  }

  void isRequired() {
    //print("listerner triggered");
    if (medAidController.text == "Yes") {
      medRequired.value = true;
    } else {
      medRequired.value = false;
    }
  }

  Widget displayForm(double width) {
    return SingleChildScrollView(
      child: Padding(
        padding: MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
            ? EdgeInsets.symmetric(horizontal: width * 0.2)
            : EdgeInsets.symmetric(horizontal: width * 0.075),
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
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ],
                ),
                Divider(
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark")),
                const SizedBox(height: 10.0),
                MihTextFormField(
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                ),
                Divider(
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark")),
                const SizedBox(height: 10.0),
                MihToggle(
                  hintText: "Medical Aid",
                  initialPostion: medAidPosition,
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  secondaryFillColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                            fillColor: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            secondaryFillColor: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
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
                            fillColor: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            inputColor: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
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
                            fillColor: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            inputColor: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
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
                            fillColor: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            inputColor: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
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
                            fillColor: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            inputColor: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
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
                        submitForm();
                      } else {
                        MihAlertServices().formNotFilledCompletely(context);
                      }
                    },
                    buttonColor: MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    width: 300,
                    child: Text(
                      "Add",
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
                const SizedBox(height: 20.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void submitForm() {
    addPatientService();
  }

  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        context.goNamed(
          'mihHome',
          extra: true,
        );
        FocusScope.of(context).unfocus();
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "Set Up Patient Profile",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ],
    );
  }

  MIHBody getBody(double width) {
    return MIHBody(
      borderOn: false,
      bodyItems: [
        KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (event) async {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              if (_formKey.currentState!.validate()) {
                submitForm();
              } else {
                MihAlertServices().formNotFilledCompletely(context);
              }
            }
          },
          child: displayForm(width),
        ),
      ],
    );
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
    medRequired.dispose();
    medMainMemController.dispose();
    medAidCodeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    medAidController.addListener(isRequired);
    setState(() {
      fnameController.text = widget.signedInUser.fname;
      lnameController.text = widget.signedInUser.lname;
      emailController.text = widget.signedInUser.email;
      medAidPosition = false;
      medMainMemberPosition = false;
      medAidController.text = "No";
      medMainMemController.text = "No";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(),
      secondaryActionButton: null,
      body: getBody(screenWidth),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
    // return Scaffold(
    //   // appBar: const MIHAppBar(
    //   //   barTitle: "Add Patient",
    //   //   propicFile: null,
    //   // ),
    //   //drawer: MIHAppDrawer(signedInUser: widget.signedInUser),
    //   body: SafeArea(
    //     child: Stack(
    //       children: [
    //         KeyboardListener(
    //           focusNode: _focusNode,
    //           autofocus: true,
    //           onKeyEvent: (event) async {
    //             if (event is KeyDownEvent &&
    //                 event.logicalKey == LogicalKeyboardKey.enter) {
    //               submitForm();
    //             }
    //           },
    //           child: displayForm(),
    //         ),
    //         Positioned(
    //           top: 10,
    //           left: 5,
    //           width: 50,
    //           height: 50,
    //           child: IconButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             icon: const Icon(Icons.arrow_back),
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
