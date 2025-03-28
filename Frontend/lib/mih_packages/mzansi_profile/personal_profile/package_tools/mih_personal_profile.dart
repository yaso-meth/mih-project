import 'dart:convert';

import 'package:Mzansi_Innovation_Hub/main.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_button.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_file_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_package/mih-app_tool_body.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:Mzansi_Innovation_Hub/mih_components/mih_profile_picture.dart';
import 'package:Mzansi_Innovation_Hub/mih_env/env.dart';
import 'package:Mzansi_Innovation_Hub/mih_objects/arguments.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/supertokens.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:http/http.dart' as http2;

class MihPersonalProfile extends StatefulWidget {
  final AppProfileUpdateArguments arguments;
  const MihPersonalProfile({
    super.key,
    required this.arguments,
  });

  @override
  State<MihPersonalProfile> createState() => _MihPersonalProfileState();
}

class _MihPersonalProfileState extends State<MihPersonalProfile> {
  final proPicController = TextEditingController();
  final usernameController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  PlatformFile? proPic;
  late ImageProvider<Object>? propicPreview;
  late bool businessUser;
  late String oldProPicName;

  Future<void> submitForm() async {
    // print("============\nsubmiit form\n=================");
    if (isFieldsFilled()) {
      if (oldProPicName != proPicController.text) {
        // print("here 1");
        // print("Pro File Name: ${proPic!.name}");
        // print("Pro File Bytes: ${proPic!.bytes}");
        await uploadSelectedFile(proPic);
      }
      await updateUserApiCall();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    }
  }

  bool isFieldsFilled() {
    if (fnameController.text.isEmpty ||
        lnameController.text.isEmpty ||
        usernameController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool isBusinessUser() {
    if (widget.arguments.signedInUser.type == "personal") {
      return false;
    } else {
      return true;
    }
  }

  bool isUsernameValid(String username) {
    return RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{5,19}$').hasMatch(username);
  }

  Future<void> uploadSelectedFile(PlatformFile? file) async {
    //print("MIH Profile Picture: $file");
    //var strem = new http.ByteStream.fromBytes(file.bytes.)
    //start loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Mihloadingcircle();
      },
    );
    var token = await SuperTokens.getAccessToken();
    var request = http2.MultipartRequest(
        'POST', Uri.parse("${AppEnviroment.baseApiUrl}/minio/upload/file/"));
    request.headers['accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['app_id'] = widget.arguments.signedInUser.app_id;
    request.fields['folder'] = "profile_files";
    request.files.add(await http2.MultipartFile.fromBytes('file', file!.bytes!,
        filename: file.name.replaceAll(RegExp(r' '), '-')));
    var response1 = await request.send();
    if (response1.statusCode == 200) {
      deleteFileApiCall(oldProPicName);
      // end loading circle
      //Navigator.of(context).pop();
      // String message =
      //     "The file ${file.name.replaceAll(RegExp(r' '), '-')} has been successfully generated and added to ${widget.signedInUser.fname} ${widget.signedInUser.lname}'s record. You can now access and download it for their use.";
      // successPopUp(message);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> updateUserApiCall() async {
    var fname = proPicController.text.replaceAll(RegExp(r' '), '-');
    var filePath =
        "${widget.arguments.signedInUser.app_id}/profile_files/$fname";
    var profileType;
    if (businessUser) {
      profileType = "business";
    } else {
      profileType = "personal";
    }
    if (isUsernameValid(usernameController.text) == false) {
      usernamePopUp();
    } else {
      var response = await http.put(
        Uri.parse("${AppEnviroment.baseApiUrl}/user/update/"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: jsonEncode(<String, dynamic>{
          "idusers": widget.arguments.signedInUser.idUser,
          "username": usernameController.text,
          "fnam": fnameController.text,
          "lname": lnameController.text,
          "type": profileType,
          "pro_pic_path": filePath,
        }),
      );
      //print("Here4");
      //print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(
          '/',
          arguments: AuthArguments(
            true,
            false,
          ),
        );
        // Navigator.of(context).pushNamed(
        //   '/mzansi-profile',
        //   arguments: AppProfileUpdateArguments(
        //       widget.arguments.signedInUser, widget.arguments.propicFile),
        // );
        String message =
            "${widget.arguments.signedInUser.email}'s information has been updated successfully!";
        successPopUp(message);
      } else {
        internetConnectionPopUp();
      }
    }
  }

  Future<void> deleteFileApiCall(String filename) async {
    // delete file from minio
    var fname = filename.replaceAll(RegExp(r' '), '-');
    var filePath =
        "${widget.arguments.signedInUser.app_id}/profile_files/$fname";
    var response = await http.delete(
      Uri.parse("${AppEnviroment.baseApiUrl}/minio/delete/file/"),
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

  void usernamePopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Invalid Username");
      },
    );
  }

  @override
  void dispose() {
    proPicController.dispose();
    usernameController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var proPicName = "";
    if (widget.arguments.signedInUser.pro_pic_path.isNotEmpty) {
      proPicName = widget.arguments.signedInUser.pro_pic_path.split("/").last;
    }
    setState(() {
      propicPreview = widget.arguments.propicFile;
      oldProPicName = proPicName;
      proPicController.text = proPicName;
      fnameController.text = widget.arguments.signedInUser.fname;
      lnameController.text = widget.arguments.signedInUser.lname;
      usernameController.text = widget.arguments.signedInUser.username;
      businessUser = isBusinessUser();
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
      child: Column(
        children: [
          //displayProPic(),
          MIHProfilePicture(
            profilePictureFile: widget.arguments.propicFile,
            proPicController: proPicController,
            proPic: proPic,
            width: 155,
            radius: 70,
            drawerMode: false,
            editable: true,
            onChange: (newProPic) {
              setState(() {
                proPic = newProPic;
              });
            },
          ),
          const SizedBox(height: 25.0),
          Visibility(
            visible: false,
            child: MIHFileField(
              controller: proPicController,
              hintText: "Profile Picture",
              editable: false,
              required: false,
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpg', 'png'],
                );
                if (result == null) return;
                final selectedFile = result.files.first;
                setState(() {
                  proPic = selectedFile;
                  propicPreview = MemoryImage(proPic!.bytes!);
                });

                setState(() {
                  proPicController.text = selectedFile.name;
                });
              },
            ),
          ),
          // const SizedBox(height: 10.0),
          // MIHTextField(
          //   controller: proPicController,
          //   hintText: "Pro Pic",
          //   editable: true,
          //   required: true,
          // ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: usernameController,
            hintText: "Username",
            editable: true,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: fnameController,
            hintText: "First Name",
            editable: true,
            required: true,
          ),
          const SizedBox(height: 10.0),
          MIHTextField(
            controller: lnameController,
            hintText: "Last Name",
            editable: true,
            required: true,
          ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Activate Business Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Switch(
                value: businessUser,
                onChanged: (bool value) {
                  setState(() {
                    businessUser = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          SizedBox(
            width: 500.0,
            height: 50.0,
            child: MIHButton(
              buttonText: "Update",
              buttonColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              textColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              onTap: () {
                submitForm();
              },
            ),
          ),
        ],
      ),
    );
  }
}
