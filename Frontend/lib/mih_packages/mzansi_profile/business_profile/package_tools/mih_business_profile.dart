import 'dart:convert';

import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_file_api.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_location_api.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_file_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih-app_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supertokens_flutter/http.dart' as http;

class MihBusinessProfile extends StatefulWidget {
  final BusinessArguments arguments;
  const MihBusinessProfile({
    super.key,
    required this.arguments,
  });

  @override
  State<MihBusinessProfile> createState() => _MihBusinessProfileState();
}

class _MihBusinessProfileState extends State<MihBusinessProfile> {
  final FocusNode _focusNode = FocusNode();
  final baseAPI = AppEnviroment.baseApiUrl;

  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final regController = TextEditingController();
  final logonameController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final titleController = TextEditingController();
  final signtureController = TextEditingController();
  final accessController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final practiceNoController = TextEditingController();
  final vatNoController = TextEditingController();

  late PlatformFile? selectedLogo = null;
  late PlatformFile? selectedSignature = null;
  PlatformFile? logoFile;
  ImageProvider<Object>? logoPreview = null;

  final ValueNotifier<String> busType = ValueNotifier("");

  late String business_id;
  late String oldLogoPath;
  late String oldSigPath;
  String logoUri = "";

  Future<void> updateBusinessProfileAPICall(String business_id) async {
    print("inside update business profile api call");
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var response = await http.put(
      Uri.parse("$baseAPI/business/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "Name": nameController.text,
        "type": typeController.text,
        "registration_no": regController.text,
        "logo_name": logonameController.text,
        "logo_path":
            "${widget.arguments.signedInUser.app_id}/business_files/${logonameController.text}",
        "contact_no": contactController.text,
        "bus_email": emailController.text,
        "gps_location": locationController.text,
        "practice_no": practiceNoController.text,
        "vat_no": vatNoController.text,
      }),
    );
    if (response.statusCode == 200) {
      //var businessResponse = jsonDecode(response.body);
      //print(selectedLogo != null);
      if (logoFile != null) {
        uploadSelectedFile(logoFile);
      }
      updateBusinessUserAPICall(business_id);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> updateBusinessUserAPICall(String business_id) async {
    var response = await http.put(
      Uri.parse("$baseAPI/business-user/update/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "app_id": widget.arguments.signedInUser.app_id,
        "signature": signtureController.text,
        "sig_path":
            "${widget.arguments.signedInUser.app_id}/business_files/${signtureController.text}",
        "title": titleController.text,
        "access": accessController.text,
      }),
    );
    if (response.statusCode == 200) {
      if (selectedSignature != null) {
        uploadSelectedFile(selectedSignature);
        deleteFileApiCall(oldSigPath);
      }
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        '/',
        arguments: AuthArguments(
          false,
          false,
        ),
      );
      String message =
          "Your business profile is now live! You can now start connecting with customers and growing your business.";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> uploadSelectedFile(PlatformFile? file) async {
    print("Inside upload selected file");
    var response = await MihFileApi.uploadFile(
      widget.arguments.signedInUser.app_id,
      "business_files",
      file,
      context,
    );
    if (response == 200) {
      deleteFileApiCall(oldLogoPath);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> deleteFileApiCall(String filePath) async {
    // delete file from minio
    var response = await MihFileApi.deleteFile(
      widget.arguments.signedInUser.app_id,
      "business_files",
      filePath.split("/").last,
      context,
    );
    if (response == 200) {
      //SQL delete
    } else {
      internetConnectionPopUp();
    }
  }

  bool isFullAccess() {
    if (widget.arguments.businessUser!.access == "Partial") {
      return false;
    } else {
      return true;
    }
  }

  bool validEmail() {
    String text = emailController.text;
    var regex = RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
    return regex.hasMatch(text);
  }

  bool isFieldsFilled() {
    if (nameController.text.isEmpty ||
        typeController.text.isEmpty ||
        regController.text.isEmpty ||
        logonameController.text.isEmpty ||
        fnameController.text.isEmpty ||
        lnameController.text.isEmpty ||
        titleController.text.isEmpty ||
        signtureController.text.isEmpty ||
        accessController.text.isEmpty ||
        contactController.text.isEmpty ||
        emailController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void typeSelected() {
    if (typeController.text.isNotEmpty) {
      busType.value = typeController.text;
    } else {
      busType.value = "";
    }
  }

  void submitForm(String business_id) {
    if (!validEmail()) {
      emailError();
    } else if (isFieldsFilled()) {
      print("inside submit form mthod");
      updateBusinessProfileAPICall(business_id);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
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

  void emailError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Invalid Email");
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
    nameController.dispose();
    typeController.dispose();
    regController.dispose();
    logonameController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    titleController.dispose();
    signtureController.dispose();
    accessController.dispose();
    contactController.dispose();
    emailController.dispose();
    locationController.dispose();
    practiceNoController.dispose();
    vatNoController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    typeController.addListener(typeSelected);
    setState(() {
      titleController.text = widget.arguments.businessUser!.title;
      fnameController.text = widget.arguments.signedInUser.fname;
      lnameController.text = widget.arguments.signedInUser.lname;
      signtureController.text = widget.arguments.businessUser!.signature;
      titleController.text = widget.arguments.businessUser!.title;
      accessController.text = widget.arguments.businessUser!.access;
      oldSigPath = widget.arguments.businessUser!.sig_path;
      business_id = widget.arguments.business!.business_id;
      regController.text = widget.arguments.business!.registration_no;
      nameController.text = widget.arguments.business!.Name;
      typeController.text = widget.arguments.business!.type;
      logonameController.text = widget.arguments.business!.logo_name;
      oldLogoPath = widget.arguments.business!.logo_path;
      contactController.text = widget.arguments.business!.contact_no;
      emailController.text = widget.arguments.business!.bus_email;
      locationController.text = widget.arguments.business!.gps_location;
      practiceNoController.text = widget.arguments.business!.practice_no;
      vatNoController.text = widget.arguments.business!.vat_no;
    });
    MihFileApi.getMinioFileUrl(
      widget.arguments.business!.logo_path,
      context,
    ).then((value) {
      setState(() {
        logoUri = value;
      });
      logoPreview = NetworkImage(logoUri);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MihAppToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return MihSingleChildScroll(
      child: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) async {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.enter) {
            //print(business_id);
            submitForm(business_id);
          }
        },
        child: Column(
          children: [
            Visibility(
              visible: isFullAccess(),
              child: Column(
                children: [
                  const Text(
                    "Business Profile",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Divider(
                      color: MzanziInnovationHub.of(context)
                          ?.theme
                          .secondaryColor()),
                  const SizedBox(height: 10.0),
                  MihCircleAvatar(
                    imageFile: logoPreview,
                    fileNameController: logonameController,
                    userSelectedfile: logoFile,
                    width: 155,
                    editable: true,
                    frameColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    onChange: (newProPic) {
                      setState(() {
                        logoFile = newProPic;
                      });
                      print("logoFile: ${logoFile?.bytes}");
                    },
                    backgroundColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  ),
                  const SizedBox(height: 10.0),
                  MIHFileField(
                    controller: logonameController,
                    hintText: "Logo",
                    editable: false,
                    required: true,
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'png'],
                      );
                      if (result == null) return;
                      final selectedFile = result.files.first;
                      setState(() {
                        selectedLogo = selectedFile;
                      });
                      setState(() {
                        logonameController.text = selectedFile.name;
                      });
                    },
                  ),
                  const SizedBox(height: 10.0),
                  MIHTextField(
                    controller: regController,
                    hintText: "Registration No.",
                    editable: true,
                    required: true,
                  ),
                  const SizedBox(height: 10.0),
                  MIHTextField(
                    controller: nameController,
                    hintText: "Business Name",
                    editable: true,
                    required: true,
                  ),
                  const SizedBox(height: 10.0),
                  MIHDropdownField(
                    controller: typeController,
                    hintText: "Business Type",
                    dropdownOptions: const ["Doctors Office", "Other"],
                    required: true,
                    editable: true,
                    enableSearch: false,
                  ),
                  const SizedBox(height: 10.0),
                  ValueListenableBuilder(
                    valueListenable: busType,
                    builder:
                        (BuildContext context, String value, Widget? child) {
                      return Visibility(
                        visible: value == "Doctors Office",
                        child: MIHTextField(
                          controller: practiceNoController,
                          hintText: "Practice Number",
                          editable: true,
                          required: true,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10.0),
                  MIHTextField(
                    controller: vatNoController,
                    hintText: "VAT Number",
                    editable: true,
                    required: true,
                  ),
                  const SizedBox(height: 10.0),
                  MIHTextField(
                    controller: contactController,
                    hintText: "Contact Number",
                    editable: true,
                    required: true,
                  ),
                  const SizedBox(height: 10.0),
                  MIHTextField(
                    controller: emailController,
                    hintText: "Email",
                    editable: true,
                    required: true,
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      Flexible(
                        child: MIHTextField(
                          controller: locationController,
                          hintText: "Location",
                          editable: false,
                          required: false,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      SizedBox(
                        width: 100.0,
                        height: 50.0,
                        child: MIHButton(
                          buttonText: "Set",
                          buttonColor: MzanziInnovationHub.of(context)!
                              .theme
                              .secondaryColor(),
                          textColor: MzanziInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                          onTap: () {
                            MIHLocationAPI()
                                .getGPSPosition(context)
                                .then((position) {
                              if (position != null) {
                                setState(() {
                                  locationController.text =
                                      "${position.latitude}, ${position.longitude}";
                                });
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
            Column(
              children: [
                //const SizedBox(height: 15.0),
                const Text(
                  "My Business User",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Divider(
                  color:
                      MzanziInnovationHub.of(context)?.theme.secondaryColor(),
                ),
                const SizedBox(height: 10.0),
                MIHDropdownField(
                  controller: titleController,
                  hintText: "Title",
                  dropdownOptions: const ["Doctor", "Assistant", "Other"],
                  required: true,
                  editable: true,
                  enableSearch: false,
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: fnameController,
                  hintText: "Name",
                  editable: false,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MIHTextField(
                  controller: lnameController,
                  hintText: "Surname",
                  editable: false,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MIHFileField(
                  controller: signtureController,
                  hintText: "Signature",
                  editable: false,
                  required: true,
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'png', 'pdf'],
                    );
                    if (result == null) return;
                    final selectedFile = result.files.first;
                    setState(() {
                      selectedSignature = selectedFile;
                    });
                    setState(() {
                      signtureController.text = selectedFile.name;
                    });
                  },
                ),
                const SizedBox(height: 15.0),
                MIHDropdownField(
                  controller: accessController,
                  hintText: "Access",
                  dropdownOptions: const ["Full", "Partial"],
                  required: true,
                  editable: false,
                  enableSearch: false,
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: 500.0,
                  height: 50.0,
                  child: MIHButton(
                    buttonText: "Update",
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    textColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    onTap: () {
                      //print(business_id);
                      print("submit form call");
                      submitForm(business_id);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
