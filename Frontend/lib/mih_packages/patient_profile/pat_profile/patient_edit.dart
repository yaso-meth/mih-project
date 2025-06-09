import 'dart:convert';

import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_action.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_header.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_toggle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:mzansi_innovation_hub/mih_objects/patients.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:supertokens_flutter/http.dart' as http;

class EditPatient extends StatefulWidget {
  final Patient selectedPatient;
  final AppUser signedInUser;
  const EditPatient({
    super.key,
    required this.selectedPatient,
    required this.signedInUser,
  });

  @override
  State<EditPatient> createState() => _EditPatientState();
}

class _EditPatientState extends State<EditPatient> {
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
  final baseAPI = AppEnviroment.baseApiUrl;
  final docOfficeIdApiUrl = "${AppEnviroment.baseApiUrl}/users/profile/";
  final apiUrlEdit = "${AppEnviroment.baseApiUrl}/patients/update/";
  final apiUrlDelete = "${AppEnviroment.baseApiUrl}/patients/delete/";
  final _formKey = GlobalKey<FormState>();

  late bool medAidPosition;
  late bool medMainMemberPosition;
  late int futureDocOfficeId;
  late String userEmail;
  // bool medRequired = false;
  final ValueNotifier<bool> medRequired = ValueNotifier(false);

  late double width;
  late double height;

  final FocusNode _focusNode = FocusNode();

  // Future getOfficeIdByUser(String endpoint) async {
  //   final response = await http.get(Uri.parse(endpoint));
  //   if (response.statusCode == 200) {
  //     String body = response.body;
  //     var decodedData = jsonDecode(body);
  //     AppUser u = AppUser.fromJson(decodedData as Map<String, dynamic>);
  //     setState(() {
  //       //futureDocOfficeId = u.docOffice_id;
  //       //print(futureDocOfficeId);
  //     });
  //   } else {
  //     internetConnectionPopUp();
  //     throw Exception('failed to load patients');
  //   }
  // }

  Future<void> updatePatientApiCall() async {
    //print("Here1");
    //userEmail = getLoginUserEmail() as String;
    //print(userEmail);
    //print("Here2");
    //await getOfficeIdByUser(docOfficeIdApiUrl + userEmail);
    //print(futureDocOfficeId.toString());
    //print("Here3");
    var response = await http.put(
      Uri.parse(apiUrlEdit),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "id_no": idController.text,
        "first_name": fnameController.text,
        "last_name": lnameController.text,
        "email": emailController.text,
        "cell_no": cellController.text,
        "medical_aid": medAidController.text,
        "medical_aid_main_member": medMainMemController.text,
        "medical_aid_no": medNoController.text,
        "medical_aid_code": medAidCodeController.text,
        "medical_aid_name": medNameController.text,
        "medical_aid_scheme": medSchemeController.text,
        "address": addressController.text,
        "app_id": widget.selectedPatient.app_id,
      }),
    );
    // print("Here4");
    // print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed('/patient-profile',
          arguments: PatientViewArguments(
              widget.signedInUser, null, null, null, "personal"));
      //Navigator.of(context).pushNamed('/');
      String message =
          "${fnameController.text} ${lnameController.text}'s information has been updated successfully! Their medical records and details are now current.";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> deletePatientApiCall() async {
    //print("Here1");
    //userEmail = getLoginUserEmail() as String;
    //print(userEmail);
    //print("Here2");
    //await getOfficeIdByUser(docOfficeIdApiUrl + userEmail);
    //print("Office ID: ${futureDocOfficeId.toString()}");
    //print("OPatient ID No: ${idController.text}");
    //print("Here3");
    var response = await http.delete(
      Uri.parse(apiUrlDelete),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(
          <String, dynamic>{"app_id": widget.selectedPatient.app_id}),
    );
    //print("Here4");
    //print(response.statusCode);
    if (response.statusCode == 200) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).popAndPushNamed('/patient-profile',
          arguments: PatientViewArguments(
              widget.signedInUser, null, null, null, "personal"));
      String message =
          "${fnameController.text} ${lnameController.text}'s record has been deleted successfully. This means it will no longer be visible in patient manager and cannot be used for future appointments.";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> getLoginUserEmail() async {
    var uid = await SuperTokens.getUserId();
    var response = await http.get(Uri.parse("$baseAPI/user/$uid"));
    if (response.statusCode == 200) {
      var user = jsonDecode(response.body);
      userEmail = user["email"];
    }
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

  void internetConnectionPopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void deletePatientPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              width: 700.0,
              height: (height / 3) * 2,
              decoration: BoxDecoration(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(
                    color:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    width: 5.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      size: 100,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Are you sure you want to delete this?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        "This action is permanent! Deleting ${fnameController.text} ${lnameController.text} will remove him\\her from your account. You won't be able to recover it once it's gone.",
                        style: TextStyle(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        "Here's what you'll be deleting:",
                        style: TextStyle(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: SizedBox(
                        width: 450,
                        child: Text(
                          "1) Patient Profile Information.\n2) Patient Notes\n3) Patient Files.",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    MihButton(
                      onPressed: deletePatientApiCall,
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      width: 300,
                      child: Text(
                        "Delete",
                        style: TextStyle(
                          color: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
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

  void isRequired() {
    print("listerner triggered");
    if (medAidController.text == "Yes") {
      medRequired.value = true;
    } else if (medAidController.text == "No") {
      medRequired.value = false;
    } else {
      //print("here");
    }
  }

  Widget displayForm(double width) {
    return SingleChildScrollView(
      child: Padding(
        padding: MzanziInnovationHub.of(context)!.theme.screenType == "desktop"
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
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                    ),
                  ],
                ),
                Divider(
                    color: MzanziInnovationHub.of(context)!
                        .theme
                        .secondaryColor()),
                const SizedBox(height: 10.0),
                MihTextFormField(
                  fillColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  inputColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                  fillColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  inputColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  controller: fnameController,
                  multiLineInput: false,
                  requiredText: true,
                  hintText: "First Name",
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
                const SizedBox(height: 10.0),
                MihTextFormField(
                  fillColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  inputColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  controller: lnameController,
                  multiLineInput: false,
                  requiredText: true,
                  hintText: "Surname",
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
                const SizedBox(height: 10.0),
                MihTextFormField(
                  fillColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  inputColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                  fillColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  inputColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                  fillColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  inputColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
                Divider(
                    color: MzanziInnovationHub.of(context)!
                        .theme
                        .secondaryColor()),
                const SizedBox(height: 10.0),
                MihToggle(
                  hintText: "Medical Aid",
                  initialPostion: medAidPosition,
                  fillColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  secondaryFillColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            secondaryFillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
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
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            inputColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
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
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            inputColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
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
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            inputColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
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
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            inputColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
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
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    width: 300,
                    child: Text(
                      "Update",
                      style: TextStyle(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
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
    updatePatientApiCall();
  }

  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "Edit Patient Details",
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
    medMainMemController.dispose();
    medAidCodeController.dispose();
    medRequired.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getLoginUserEmail();
    medAidController.addListener(isRequired);
    setState(() {
      idController.text = widget.selectedPatient.id_no;
      fnameController.text = widget.selectedPatient.first_name;
      lnameController.text = widget.selectedPatient.last_name;
      cellController.text = widget.selectedPatient.cell_no;
      emailController.text = widget.selectedPatient.email;
      medNameController.text = widget.selectedPatient.medical_aid_name;
      medNoController.text = widget.selectedPatient.medical_aid_no;
      medSchemeController.text = widget.selectedPatient.medical_aid_scheme;
      addressController.text = widget.selectedPatient.address;
      medAidController.text = widget.selectedPatient.medical_aid;
      medMainMemController.text =
          widget.selectedPatient.medical_aid_main_member;
      medAidCodeController.text = widget.selectedPatient.medical_aid_code;
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
    setState(() {
      width = size.width;
      height = size.height;
    });
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(),
      secondaryActionButton: null,
      body: getBody(width),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
  }
}
