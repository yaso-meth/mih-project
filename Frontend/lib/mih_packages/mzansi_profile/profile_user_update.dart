import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:http/http.dart' as http2;
import 'package:supertokens_flutter/supertokens.dart';

import '../../mih_components/mih_inputs_and_buttons/mih_button.dart';
import '../../mih_components/mih_inputs_and_buttons/mih_file_input.dart';
import '../../mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import '../../mih_components/mih_layout/mih_action.dart';
import '../../mih_components/mih_layout/mih_body.dart';
import '../../mih_components/mih_layout/mih_header.dart';
import '../../mih_components/mih_layout/mih_layout_builder.dart';
import '../../mih_components/mih_pop_up_messages/mih_error_message.dart';
import '../../mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import '../../mih_components/mih_pop_up_messages/mih_success_message.dart';
import '../../mih_components/mih_profile_picture.dart';
import '../../mih_env/env.dart';
import '../../mih_objects/arguments.dart';

class ProfileUserUpdate extends StatefulWidget {
  final AppProfileUpdateArguments arguments;
  // final AppUser signedInUser;
  // final ImageProvider<Object>? propicFile;
  const ProfileUserUpdate({
    super.key,
    required this.arguments,
  });

  @override
  State<ProfileUserUpdate> createState() => _ProfileUserUpdateState();
}

class _ProfileUserUpdateState extends State<ProfileUserUpdate> {
  final proPicController = TextEditingController();
  final usernameController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();

  PlatformFile? proPic;
  late ImageProvider<Object>? propicPreview;
  late bool businessUser;
  final FocusNode _focusNode = FocusNode();

  late String oldProPicName;

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

  Future<String> getFileUrlApiCall(String filePath) async {
    if (widget.arguments.signedInUser.pro_pic_path == "") {
      return "";
    } else if (AppEnviroment.getEnv() == "Dev") {
      return "${AppEnviroment.baseFileUrl}/mih/$filePath";
    } else {
      var url = "${AppEnviroment.baseApiUrl}/minio/pull/file/$filePath/prod";
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String body = response.body;
        var decodedData = jsonDecode(body);

        return decodedData['minioURL'];
      } else {
        throw Exception(
            "Error: GetUserData status code ${response.statusCode}");
      }
    }
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

  bool isFieldsFilled() {
    if (fnameController.text.isEmpty ||
        lnameController.text.isEmpty ||
        usernameController.text.isEmpty) {
      return false;
    } else {
      return true;
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
        Navigator.of(context)
            .popAndPushNamed('/', arguments: widget.arguments.signedInUser);
        String message =
            "${widget.arguments.signedInUser.email}'s information has been updated successfully!";
        successPopUp(message);
      } else {
        internetConnectionPopUp();
      }
    }
  }

  bool isBusinessUser() {
    if (widget.arguments.signedInUser.type == "personal") {
      return false;
    } else {
      return true;
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

  void usernamePopUp() {
    showDialog(
      context: context,
      builder: (context) {
        return const MIHErrorMessage(errorType: "Invalid Username");
      },
    );
  }

  bool isUsernameValid(String username) {
    return RegExp(r'^[a-zA-Z][a-zA-Z0-9_]{5,19}$').hasMatch(username);
  }

  Future<void> submitForm() async {
    if (isFieldsFilled()) {
      if (oldProPicName != proPicController.text) {
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

  MIHAction getActionButton() {
    return MIHAction(
      icon: const Icon(Icons.arrow_back),
      iconSize: 35,
      onTap: () {
        Navigator.of(context).pop();

        Navigator.of(context).popAndPushNamed(
          '/',
          arguments: true,
        );
      },
    );
  }

  MIHHeader getHeader() {
    return const MIHHeader(
      headerAlignment: MainAxisAlignment.center,
      headerItems: [
        Text(
          "Mzansi Profile",
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
      borderOn: false,
      bodyItems: [
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
    );
  }

  @override
  void dispose() {
    proPicController.dispose();
    usernameController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    _focusNode.dispose();
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
    return MIHLayoutBuilder(
      actionButton: getActionButton(),
      header: getHeader(),
      secondaryActionButton: null,
      body: getBody(),
      actionDrawer: null,
      secondaryActionDrawer: null,
      bottomNavBar: null,
      pullDownToRefresh: false,
      onPullDown: () async {},
    );
  }
}
