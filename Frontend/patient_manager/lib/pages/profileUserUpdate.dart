import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gif/gif.dart';
import 'package:patient_manager/components/inputsAndButtons/mihFileInput.dart';
import 'package:patient_manager/components/mihAppBar.dart';
import 'package:patient_manager/components/popUpMessages/mihLoadingCircle.dart';
// import 'package:patient_manager/components/mihAppDrawer.dart';
import 'package:patient_manager/components/popUpMessages/mihErrorMessage.dart';
import 'package:patient_manager/components/popUpMessages/mihSuccessMessage.dart';
import 'package:patient_manager/components/inputsAndButtons/mihTextInput.dart';
import 'package:patient_manager/components/inputsAndButtons/mihButton.dart';
import 'package:patient_manager/env/env.dart';
import 'package:patient_manager/main.dart';
import 'package:patient_manager/objects/appUser.dart';
import 'package:supertokens_flutter/http.dart' as http;
import 'package:http/http.dart' as http2;
import 'package:supertokens_flutter/supertokens.dart';

class ProfileUserUpdate extends StatefulWidget {
  final AppUser signedInUser;
  //final String userEmail;
  const ProfileUserUpdate({
    super.key,
    required this.signedInUser,
  });

  @override
  State<ProfileUserUpdate> createState() => _ProfileUserUpdateState();
}

class _ProfileUserUpdateState extends State<ProfileUserUpdate>
    with TickerProviderStateMixin {
  final proPicController = TextEditingController();
  final usernameController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();

  late PlatformFile proPic;
  late Future<String> proPicUrl;
  late bool businessUser;
  final FocusNode _focusNode = FocusNode();
  late final GifController _controller;

  Future<String> getFileUrlApiCall(String filePath) async {
    if (widget.signedInUser.pro_pic_path == "") {
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

  Future<void> uploadSelectedFile(PlatformFile file) async {
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
    request.fields['app_id'] = widget.signedInUser.app_id;
    request.fields['folder'] = "profile_files";
    request.files.add(await http2.MultipartFile.fromBytes('file', file.bytes!,
        filename: file.name.replaceAll(RegExp(r' '), '-')));
    var response1 = await request.send();
    if (response1.statusCode == 200) {
      setState(() {
        //proPicController.clear();
        //futueFiles = fetchFiles();
      });
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
    var filePath = "${widget.signedInUser.app_id}/profile_files/$fname";
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
          "idusers": widget.signedInUser.idUser,
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
            .popAndPushNamed('/', arguments: widget.signedInUser);
        String message =
            "${widget.signedInUser.email}'s information has been updated successfully!";
        successPopUp(message);
      } else {
        internetConnectionPopUp();
      }
    }
  }

  bool isBusinessUser() {
    if (widget.signedInUser.type == "personal") {
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
    return RegExp(r'^(?=[a-zA-Z0-9._]{8,20}$)(?!.*[_.]{2})[^_.].*[^_.]$')
        .hasMatch(username);
  }

  Future<void> submitForm() async {
    if (isFieldsFilled()) {
      await uploadSelectedFile(proPic);
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

  @override
  void dispose() {
    _controller.dispose();
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
    if (widget.signedInUser.pro_pic_path.isNotEmpty) {
      proPicName = widget.signedInUser.pro_pic_path.split("/").last;
    }
    _controller = GifController(vsync: this);
    setState(() {
      proPicUrl = getFileUrlApiCall(widget.signedInUser.pro_pic_path);
      proPicController.text = proPicName;
      fnameController.text = widget.signedInUser.fname;
      lnameController.text = widget.signedInUser.lname;
      usernameController.text = widget.signedInUser.username;
      businessUser = isBusinessUser();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MIHAppBar(barTitle: "Update Profile"),
      //drawer: MIHAppDrawer(signedInUser: widget.signedInUser),
      body: SafeArea(
        child: Padding(
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
                    "Mzansi Profile:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  FutureBuilder(
                    future: proPicUrl,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData && snapshot.data != "") {
                          return Stack(
                            alignment: Alignment.center,
                            fit: StackFit.loose,
                            children: [
                              CircleAvatar(
                                //backgroundColor: Colors.green,
                                backgroundImage:
                                    NetworkImage(snapshot.requireData),
                                //'https://media.licdn.com/dms/image/D4D03AQGd1-QhjtWWpA/profile-displayphoto-shrink_400_400/0/1671698053061?e=2147483647&v=beta&t=a3dJI5yxs5-KeXjj10LcNCFuC9IOfa8nNn3k_Qyr0CA'),
                                radius: 50,
                              ),
                              SizedBox(
                                width: 110,
                                child: Image(
                                    image: MzanziInnovationHub.of(context)!
                                        .theme
                                        .altLogoFrame()),
                              )
                            ],
                          );
                        } else {
                          return SizedBox(
                              width: 110,
                              child: Image(
                                  image: MzanziInnovationHub.of(context)!
                                      .theme
                                      .altLogoFrame()));
                        }
                      } else {
                        return Center(
                          child: Text(
                            '${snapshot.error} occurred',
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10.0),
                  MIHFileField(
                    controller: proPicController,
                    hintText: "Profile Picture",
                    editable: true,
                    required: false,
                    onPressed: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'png', 'pdf'],
                      );
                      if (result == null) return;
                      final selectedFile = result.files.first;
                      setState(() {
                        proPic = selectedFile;
                      });

                      setState(() {
                        proPicController.text = selectedFile.name;
                      });
                    },
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
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
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
      ),
    );
  }
}
