import 'dart:convert';

import 'package:file_picker/file_picker.dart';
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
import 'package:patient_manager/objects/business.dart';
import 'package:patient_manager/objects/businessUser.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:supertokens_flutter/supertokens.dart';
import 'package:http/http.dart' as http2;

class ProfileBusinessUpdate extends StatefulWidget {
  //final BusinessUserScreenArguments arguments;
  final AppUser signedInUser;
  const ProfileBusinessUpdate({
    super.key,
    required this.signedInUser,
  });

  @override
  State<ProfileBusinessUpdate> createState() => _ProfileBusinessUpdateState();
}

class _ProfileBusinessUpdateState extends State<ProfileBusinessUpdate> {
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

  late PlatformFile? selectedLogo = null;
  late PlatformFile? selectedSignature = null;

  late Future<BusinessUser?> futureBusinessUser;
  BusinessUser? businessUser;
  late Future<Business?> futureBusiness;
  Business? business;

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

  Future<BusinessUser?> getBusinessUserDetails() async {
    var response = await http
        .get(Uri.parse("$baseAPI/business-user/${widget.signedInUser.app_id}"));
    if (response.statusCode == 200) {
      String body = response.body;
      var decodedData = jsonDecode(body);
      BusinessUser business_User = BusinessUser.fromJson(decodedData);
      return business_User;
    } else {
      return null;
    }
  }

  Future<Business?> getBusinessDetails() async {
    var response = await http.get(
        Uri.parse("$baseAPI/business/app_id/${widget.signedInUser.app_id}"));
    if (response.statusCode == 200) {
      String body = response.body;
      var decodedData = jsonDecode(body);
      Business business = Business.fromJson(decodedData);
      return business;
    } else {
      return null;
    }
  }

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
    request.fields['app_id'] = widget.signedInUser.app_id;
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
        "app_id": widget.signedInUser.app_id,
        "signature": signtureController.text,
        "sig_path":
            "${widget.signedInUser.app_id}/business_files/${signtureController.text}",
        "title": titleController.text,
        "access": accessController.text,
      }),
    );
    if (response.statusCode == 200) {
      if (selectedSignature != null) {
        uploadSelectedFile(selectedSignature, signtureController);
        deleteFileApiCall(oldSigPath);
      }

      Navigator.of(context).pushNamed('/home');
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
        return const Center(
          child: CircularProgressIndicator(),
        );
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
            "${widget.signedInUser.app_id}/business_files/${logonameController.text}",
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

  void submitForm(String business_id) {
    //to-do late
    updateBusinessProfileAPICall(business_id);
  }

  @override
  void initState() {
    futureBusinessUser = getBusinessUserDetails().then((results) {
      //print(results);
      setState(() {
        businessUser = results;
        titleController.text = businessUser!.title;
        fnameController.text = widget.signedInUser.fname;
        lnameController.text = widget.signedInUser.lname;
        signtureController.text = businessUser!.signature;
        titleController.text = businessUser!.title;
        accessController.text = businessUser!.access;
        oldSigPath = businessUser!.sig_path;
      });
      return null;
    });

    futureBusiness = getBusinessDetails().then((results) {
      //print(results);
      setState(() {
        business = results;
        business_id = business!.business_id;
        regController.text = business!.registration_no;
        nameController.text = business!.Name;
        typeController.text = business!.type;
        logonameController.text = business!.logo_name;
        oldLogoPath = business!.logo_path;
      });
      return null;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MIHAppBar(barTitle: "Business Profile"),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
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
                const Text(
                  "Update Business Profile:",
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
                      //print(business_id);
                      submitForm(business_id);
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
