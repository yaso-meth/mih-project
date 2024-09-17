import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_file_input.dart';
import 'package:patient_manager/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:patient_manager/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:supertokens_flutter/supertokens.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http2;

class ProfileBusinessAdd extends StatefulWidget {
  //final BusinessUserScreenArguments arguments;
  final AppUser signedInUser;
  const ProfileBusinessAdd({
    super.key,
    required this.signedInUser,
  });

  @override
  State<ProfileBusinessAdd> createState() => _ProfileBusinessAddState();
}

class _ProfileBusinessAddState extends State<ProfileBusinessAdd> {
  final FocusNode _focusNode = FocusNode();
  final baseAPI = AppEnviroment.baseApiUrl;

  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final regController = TextEditingController();
  final addressController = TextEditingController();
  final logonameController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final titleController = TextEditingController();
  final signtureController = TextEditingController();
  final accessController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();

  late PlatformFile selectedLogo;
  late PlatformFile selectedSignature;

  Future<void> uploadSelectedFile(
      PlatformFile file, TextEditingController controller) async {
    var token = await SuperTokens.getAccessToken();
    var request = http2.MultipartRequest(
        'POST', Uri.parse("${AppEnviroment.baseApiUrl}/minio/upload/file/"));
    request.headers['accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['app_id'] = widget.signedInUser.app_id;
    request.fields['folder'] = "business_files";
    request.files.add(await http2.MultipartFile.fromBytes('file', file.bytes!,
        filename: file.name.replaceAll(RegExp(r' '), '-')));
    var response1 = await request.send();
    if (response1.statusCode == 200) {
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> createBusinessUserAPICall(String business_id) async {
    var response = await http.post(
      Uri.parse("$baseAPI/business-user/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "business_id": business_id,
        "app_id": widget.signedInUser.app_id,
        "signature": signtureController.text,
        "sig_path":
            "${widget.signedInUser.app_id}/business_files/${signtureController.text}",
        "title": titleController.text,
        "access": accessController.text,
      }),
    );
    if (response.statusCode == 201) {
      uploadSelectedFile(selectedSignature, signtureController);
      Navigator.of(context).pushNamed('/');
      String message =
          "Your business profile is now live! You can now start connecting with customers and growing your business.";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> createBusinessProfileAPICall() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );

    var response = await http.post(
      Uri.parse("$baseAPI/business/insert/"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8"
      },
      body: jsonEncode(<String, dynamic>{
        "Name": nameController.text,
        "type": typeController.text,
        "registration_no": regController.text,
        "logo_name": logonameController.text,
        "logo_path":
            "${widget.signedInUser.app_id}/business_files/${logonameController.text}",
        "contact_no": contactController.text,
        "bus_email": emailController.text,
      }),
    );
    if (response.statusCode == 201) {
      var businessResponse = jsonDecode(response.body);
      createBusinessUserAPICall(businessResponse['business_id']);
      uploadSelectedFile(selectedLogo, logonameController);
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

  void submitForm() {
    if (!validEmail()) {
      emailError();
    } else if (isFieldsFilled()) {
      createBusinessProfileAPICall();
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
      fnameController.text = widget.signedInUser.fname;
      lnameController.text = widget.signedInUser.lname;
      accessController.text = "Full";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const MIHAppBar(
      //   barTitle: "Add Business",
      //   propicFile: null,
      // ),
      //drawer: MIHAppDrawer(signedInUser: widget.signedInUser),
      body: SafeArea(
        child: Stack(
          children: [
            KeyboardListener(
              focusNode: _focusNode,
              autofocus: true,
              onKeyEvent: (event) async {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.enter) {
                  submitForm();
                }
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    //const SizedBox(height: 15),
                    const Text(
                      "Add Business Profile",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 25.0),
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
                    Divider(
                      color: MzanziInnovationHub.of(context)
                          ?.theme
                          .secondaryColor(),
                    ),
                    //const SizedBox(height: 15.0),
                    const Text(
                      "My Business User",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    MIHDropdownField(
                      controller: titleController,
                      hintText: "Title",
                      dropdownOptions: const ["Doctor", "Assistant"],
                      required: true,
                      editable: true,
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
                    ),
                    const SizedBox(height: 30.0),
                    SizedBox(
                      width: 500.0,
                      height: 50.0,
                      child: MIHButton(
                        buttonText: "Add",
                        buttonColor: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        textColor: MzanziInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        onTap: () {
                          submitForm();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 5,
              width: 50,
              height: 50,
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
            )
          ],
        ),
      ),
    );
  }
}
