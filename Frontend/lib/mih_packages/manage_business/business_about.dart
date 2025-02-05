import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:supertokens_flutter/supertokens.dart';
import 'package:http/http.dart' as http2;

import '../../mih_components/mih_inputs_and_buttons/mih_button.dart';
import '../../mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import '../../mih_components/mih_inputs_and_buttons/mih_file_input.dart';
import '../../mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import '../../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../../mih_env/env.dart';
import '../../mih_objects/arguments.dart';

class BusinessAbout extends StatefulWidget {
  final BusinessArguments arguments;
  const BusinessAbout({
    super.key,
    required this.arguments,
  });

  @override
  State<BusinessAbout> createState() => _BusinessAboutState();
}

class BusinessUserScreenArguments {}

class _BusinessAboutState extends State<BusinessAbout> {
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

  late PlatformFile? selectedLogo = null;
  late PlatformFile? selectedSignature = null;

  // late Future<BusinessUser?> futureBusinessUser;
  // BusinessUser? businessUser;
  // late Future<Business?> futureBusiness;
  // Business? business;

  late String business_id;
  late String oldLogoPath;
  late String oldSigPath;

  Future<void> deleteFileApiCall(String filePath) async {
    // delete file from minio
    var response = await http.delete(
      Uri.parse("$baseAPI/minio/delete/file/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{"file_path": filePath}),
    );
    //print("Here4");
    //print(response.statusCode);
    if (response.statusCode == 200) {
      //SQL delete
    } else {
      internetConnectionPopUp();
    }
  }

  // Future<BusinessUser?> getBusinessUserDetails() async {
  //   var response = await http
  //       .get(Uri.parse("$baseAPI/business-user/${widget.signedInUser.app_id}"));
  //   if (response.statusCode == 200) {
  //     String body = response.body;
  //     var decodedData = jsonDecode(body);
  //     BusinessUser business_User = BusinessUser.fromJson(decodedData);
  //     return business_User;
  //   } else {
  //     return null;
  //   }
  // }

  // Future<Business?> getBusinessAbout() async {
  //   var response = await http.get(
  //       Uri.parse("$baseAPI/business/app_id/${widget.signedInUser.app_id}"));
  //   if (response.statusCode == 200) {
  //     String body = response.body;
  //     var decodedData = jsonDecode(body);
  //     Business business = Business.fromJson(decodedData);
  //     return business;
  //   } else {
  //     return null;
  //   }
  // }

  Future<void> uploadSelectedFile(
      PlatformFile? file, TextEditingController controller) async {
    //to-do delete file when changed

    var token = await SuperTokens.getAccessToken();
    //print(t);
    //print("here1");
    var request = http2.MultipartRequest(
        'POST', Uri.parse("${AppEnviroment.baseApiUrl}/minio/upload/file/"));
    request.headers['accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['app_id'] = widget.arguments.signedInUser.app_id;
    request.fields['folder'] = "business_files";
    request.files.add(await http2.MultipartFile.fromBytes('file', file!.bytes!,
        filename: file.name.replaceAll(RegExp(r' '), '-')));
    var response1 = await request.send();
    if (response1.statusCode == 200) {
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
        uploadSelectedFile(selectedSignature, signtureController);
        deleteFileApiCall(oldSigPath);
      }

      Navigator.of(context).pushNamed('/');
      String message =
          "Your business profile is now live! You can now start connecting with customers and growing your business.";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> updateBusinessProfileAPICall(String business_id) async {
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
      }),
    );
    if (response.statusCode == 200) {
      //var businessResponse = jsonDecode(response.body);
      //print(selectedLogo != null);
      if (selectedLogo != null) {
        uploadSelectedFile(selectedLogo, logonameController);
        deleteFileApiCall(oldLogoPath);
      }
      updateBusinessUserAPICall(business_id);
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

  void submitForm(String business_id) {
    if (!validEmail()) {
      emailError();
    } else if (isFieldsFilled()) {
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

  void emailError() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Invalid Email");
      },
    );
  }

  bool validEmail() {
    String text = emailController.text;
    var regex = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(text);
  }

  bool isFullAccess() {
    if (widget.arguments.businessUser!.access == "Partial") {
      return false;
    } else {
      return true;
    }
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
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      //businessUser = results;
      titleController.text = widget.arguments.businessUser!.title;
      fnameController.text = widget.arguments.signedInUser.fname;
      lnameController.text = widget.arguments.signedInUser.lname;
      signtureController.text = widget.arguments.businessUser!.signature;
      titleController.text = widget.arguments.businessUser!.title;
      accessController.text = widget.arguments.businessUser!.access;

      oldSigPath = widget.arguments.businessUser!.sig_path;

      //business = results;
      business_id = widget.arguments.business!.business_id;
      regController.text = widget.arguments.business!.registration_no;
      nameController.text = widget.arguments.business!.Name;
      typeController.text = widget.arguments.business!.type;
      logonameController.text = widget.arguments.business!.logo_name;
      oldLogoPath = widget.arguments.business!.logo_path;
      contactController.text = widget.arguments.business!.contact_no;
      emailController.text = widget.arguments.business!.bus_email;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
        child: SingleChildScrollView(
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
                          .secondaryColor(),
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
                    MIHFileField(
                      controller: logonameController,
                      hintText: "Logo",
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
                          selectedLogo = selectedFile;
                        });
                        setState(() {
                          logonameController.text = selectedFile.name;
                        });
                      },
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
                    dropdownOptions: const ["Doctor", "Assistant"],
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
                  // const SizedBox(height: 15.0),
                  // const Text(
                  //   "My Test Data",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 25,
                  //   ),
                  // ),
                  // Divider(
                  //   color:
                  //       MzanziInnovationHub.of(context)?.theme.secondaryColor(),
                  // ),
                  // const SizedBox(height: 10.0),
                  // MIHTextField(
                  //   controller: typeController,
                  //   hintText: widget.arguments.business!.type,
                  //   editable: false,
                  //   required: true,
                  // ),
                  // const SizedBox(height: 15.0),
                  // MIHTextField(
                  //   controller: titleController,
                  //   hintText: widget.arguments.businessUser!.title,
                  //   editable: false,
                  //   required: true,
                  // ),
                  // const SizedBox(height: 15.0),
                  // MIHTextField(
                  //   controller: accessController,
                  //   hintText: widget.arguments.businessUser!.access,
                  //   editable: false,
                  //   required: true,
                  // ),
                  //const SizedBox(height: 15.0),
                  const SizedBox(height: 30.0),
                  SizedBox(
                    width: 500.0,
                    height: 50.0,
                    child: MIHButton(
                      buttonText: "Update",
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      textColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                      onTap: () {
                        //print(business_id);
                        submitForm(business_id);
                      },
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
}
