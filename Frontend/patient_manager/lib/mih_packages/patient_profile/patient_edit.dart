import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_action.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_body.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_header.dart';
import 'package:patient_manager/mih_components/mih_layout/mih_layout_builder.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:patient_manager/mih_env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/mih_objects/app_user.dart';
import 'package:patient_manager/mih_objects/arguments.dart';
import 'package:patient_manager/mih_objects/patients.dart';
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

  late int futureDocOfficeId;
  late String userEmail;
  late bool medRequired;

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
                    SizedBox(
                        width: 300,
                        height: 50,
                        child: MIHButton(
                          onTap: deletePatientApiCall,
                          buttonText: "Delete",
                          buttonColor: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          textColor: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                        ))
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
    if (medRequired) {
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
    //print("listerner triggered");
    if (medAidController.text == "Yes") {
      setState(() {
        medRequired = true;
      });
    } else {
      setState(() {
        medRequired = false;
      });
    }
  }

  Widget displayForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Personal Details",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                //alignment: Alignment.topRight,
                onPressed: () {
                  deletePatientPopUp();
                },
              ),
            ],
          ),
          Divider(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: idController,
            hintText: "13 digit ID Number or Passport",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: fnameController,
            hintText: "First Name",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: lnameController,
            hintText: "Last Name",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: cellController,
            hintText: "Cell Number",
            editable: true,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: emailController,
            hintText: "Email",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: addressController,
            hintText: "Address",
            editable: true,
            required: true,
          ),
          const SizedBox(height: 15.0),
          Text(
            "Medical Aid Details",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            ),
          ),
          Divider(
              color: MzanziInnovationHub.of(context)!.theme.secondaryColor()),
          const SizedBox(height: 10.0),
          MIHDropdownField(
            controller: medAidController,
            hintText: "Medical Aid",
            onSelect: (selected) {
              if (selected == "Yes") {
                setState(() {
                  medRequired = true;
                });
              } else {
                setState(() {
                  medRequired = false;
                });
              }
            },
            editable: true,
            required: true,
            dropdownOptions: const ["Yes", "No"],
          ),
          Visibility(
            visible: medRequired,
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                MIHDropdownField(
                  controller: medMainMemController,
                  hintText: "Main Member.",
                  editable: medRequired,
                  required: medRequired,
                  dropdownOptions: const ["Yes", "No"],
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: medNoController,
                  hintText: "Medical Aid No.",
                  editable: medRequired,
                  required: medRequired,
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: medAidCodeController,
                  hintText: "Medical Aid Code",
                  editable: medRequired,
                  required: medRequired,
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: medNameController,
                  hintText: "Medical Aid Name",
                  editable: medRequired,
                  required: medRequired,
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: medSchemeController,
                  hintText: "Medical Aid Scheme",
                  editable: medRequired,
                  required: medRequired,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30.0),
          SizedBox(
            width: 500.0,
            height: 50.0,
            child: MIHButton(
              onTap: () {
                submitForm();
              },
              buttonText: "Update",
              buttonColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
            ),
          ),
        ],
      ),
    );
  }

  void submitForm() {
    if (isFieldsFilled()) {
      if (!medRequired) {
        setState(() {
          medMainMemController.text = "";
          medNoController.text = "";
          medAidCodeController.text = "";
          medNameController.text = "";
          medSchemeController.text = "";
        });
      }
      updatePatientApiCall();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    }
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

  MIHBody getBody() {
    return MIHBody(
      borderOn: true,
      bodyItems: [
        KeyboardListener(
          focusNode: _focusNode,
          autofocus: true,
          onKeyEvent: (event) async {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.enter) {
              submitForm();
            }
          },
          child: displayForm(),
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
    medMainMemController.dispose();
    medAidCodeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getLoginUserEmail();
    medAidController.addListener(isRequired);
    setState(() {
      idController.value = TextEditingValue(text: widget.selectedPatient.id_no);
      fnameController.value =
          TextEditingValue(text: widget.selectedPatient.first_name);
      lnameController.value =
          TextEditingValue(text: widget.selectedPatient.last_name);
      cellController.value =
          TextEditingValue(text: widget.selectedPatient.cell_no);
      emailController.value =
          TextEditingValue(text: widget.selectedPatient.email);
      medNameController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_name);
      medNoController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_no);
      medSchemeController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_scheme);
      addressController.value =
          TextEditingValue(text: widget.selectedPatient.address);
      medAidController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid);
      medMainMemController.value = TextEditingValue(
          text: widget.selectedPatient.medical_aid_main_member);
      medAidCodeController.value =
          TextEditingValue(text: widget.selectedPatient.medical_aid_code);
    });

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
      body: getBody(),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
    );
    // return Scaffold(
    //   // appBar: const MIHAppBar(
    //   //   barTitle: "Edit Patient",
    //   //   propicFile: null,
    //   // ),
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
    //         ),
    //         Positioned(
    //             top: 10,
    //             right: 5,
    //             width: 50,
    //             height: 50,
    //             child: IconButton(
    //               icon: const Icon(Icons.delete),
    //               color:
    //                   MzanziInnovationHub.of(context)!.theme.secondaryColor(),
    //               //alignment: Alignment.topRight,
    //               onPressed: () {
    //                 deletePatientPopUp();
    //               },
    //             ))
    //       ],
    //     ),
    //   ),
    // );
  }
}
