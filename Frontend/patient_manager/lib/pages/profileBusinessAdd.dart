import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/components/myDropdownInput.dart';
import 'package:patient_manager/components/myErrorMessage.dart';
import 'package:patient_manager/components/mySuccessMessage.dart';
import 'package:patient_manager/components/myTextInput.dart';
import 'package:patient_manager/components/mybutton.dart';
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
  final logonameController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final titleController = TextEditingController();
  final signtureController = TextEditingController();
  final accessController = TextEditingController();

  late PlatformFile selectedLogo;
  late PlatformFile selectedSignature;

  Future<void> uploadSelectedFile(
      PlatformFile file, TextEditingController controller) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    var token = await SuperTokens.getAccessToken();
    var request = http2.MultipartRequest(
        'POST', Uri.parse("${AppEnviroment.baseApiUrl}/minio/upload/file/"));
    request.headers['accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['app_id'] = widget.signedInUser.app_id;
    request.files.add(await http2.MultipartFile.fromBytes('file', file.bytes!,
        filename: file.name.replaceAll(RegExp(r' '), '-')));
    var response1 = await request.send();
    if (response1.statusCode == 200) {
      var fname = file.name.replaceAll(RegExp(r' '), '-');
      var filePath = "${widget.signedInUser.app_id}/$fname";
      var response2 = await http.post(
        Uri.parse("${AppEnviroment.baseApiUrl}/files/insert/"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{
          "file_path": filePath,
          "file_name": fname,
          "app_id": widget.signedInUser.app_id
        }),
      );
      if (response2.statusCode == 201) {
      } else {
        internetConnectionPopUp();
      }
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
        "title": titleController.text,
        "access": accessController.text,
      }),
    );
    if (response.statusCode == 201) {
      uploadSelectedFile(selectedSignature, signtureController);
      Navigator.of(context).pushNamed('/home');
      String message =
          "Your business profile is now live! You can now start connecting with customers and growing your business.";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> createBusinessProfileAPICall() async {
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
        "logo_path": "${widget.signedInUser.app_id}/${logonameController.text}",
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
        return const MyErrorMessage(errorType: "Internet Connection");
      },
    );
  }

  void successPopUp(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return MySuccessMessage(
          successType: "Success",
          successMessage: message,
        );
      },
    );
  }

  void submitForm() {
    createBusinessProfileAPICall();
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
      appBar: const MIHAppBar(barTitle: "Add Business"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: KeyboardListener(
            focusNode: _focusNode,
            autofocus: true,
            onKeyEvent: (event) async {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                submitForm();
              }
            },
            child: Column(
              children: [
                const Text(
                  "Add Business Profile:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 15.0),
                MyTextField(
                  controller: regController,
                  hintText: "Registration No.",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MyTextField(
                  controller: nameController,
                  hintText: "Business Name",
                  editable: true,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MyDropdownField(
                  controller: typeController,
                  hintText: "Business Type",
                  dropdownOptions: const ["Doctors Office", "Other"],
                  required: true,
                  editable: true,
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 19,
                      child: MyTextField(
                        controller: logonameController,
                        hintText: "Logo",
                        editable: false,
                        required: true,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.attach_file),
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Divider(
                  color:
                      MzanziInnovationHub.of(context)?.theme.secondaryColor(),
                ),
                const SizedBox(height: 15.0),
                const Text(
                  "My Business User:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 15.0),
                MyDropdownField(
                  controller: titleController,
                  hintText: "Title",
                  dropdownOptions: const ["Doctor", "Assistant"],
                  required: true,
                  editable: true,
                ),
                const SizedBox(height: 10.0),
                MyTextField(
                  controller: fnameController,
                  hintText: "Name",
                  editable: false,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                MyTextField(
                  controller: lnameController,
                  hintText: "Surname",
                  editable: false,
                  required: true,
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 19,
                      child: MyTextField(
                        controller: signtureController,
                        hintText: "Signature",
                        editable: false,
                        required: true,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: IconButton(
                          icon: const Icon(Icons.attach_file),
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                MyDropdownField(
                  controller: accessController,
                  hintText: "Access",
                  dropdownOptions: const ["Full", "Partial"],
                  required: true,
                  editable: false,
                ),
                const SizedBox(height: 15.0),
                SizedBox(
                  width: 500.0,
                  height: 100.0,
                  child: MyButton(
                    buttonText: "Add",
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    textColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    onTap: () {
                      submitForm();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
