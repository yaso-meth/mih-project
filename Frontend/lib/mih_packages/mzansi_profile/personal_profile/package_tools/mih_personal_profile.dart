import 'dart:convert';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_toggle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supertokens_flutter/http.dart' as http;

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
  late String env;
  final _formKey = GlobalKey<FormState>();

  void notUniqueAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.warning_amber_rounded,
            size: 100,
            color: MzanziInnovationHub.of(context)!.theme.errorColor(),
          ),
          alertTitle: "Too Slow, That Username is Taken",
          alertBody: const Text(
            "The username you have entered is already taken by another member of Mzansi. Please choose a different username and try again.",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          alertColour: MzanziInnovationHub.of(context)!.theme.errorColor(),
        );
      },
    );
  }

  Future<void> submitForm() async {
    // print("============\nsubmiit form\n=================");
    if (widget.arguments.signedInUser.username != usernameController.text) {
      bool isUsernameUnique =
          await MihUserApis.isUsernameUnique(usernameController.text, context);
      print("isUsernameUnique: $isUsernameUnique");
      if (isUsernameUnique == false) {
        notUniqueAlert();
        return;
      }
    }
    if (oldProPicName != proPicController.text) {
      await uploadSelectedFile(proPic);
    }
    await updateUserApiCall();
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
    var response = await MihFileApi.uploadFile(
      widget.arguments.signedInUser.app_id,
      env,
      "profile_files",
      file,
      context,
    );
    if (response == 200) {
      deleteFileApiCall(oldProPicName);
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
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(
          '/',
          arguments: AuthArguments(
            true,
            false,
          ),
        );
        String message = "Your information has been updated successfully!";
        successPopUp(message);
      } else {
        internetConnectionPopUp();
      }
    }
  }

  Future<void> deleteFileApiCall(String filename) async {
    var response = await MihFileApi.deleteFile(
      widget.arguments.signedInUser.app_id,
      env,
      "profile_files",
      filename,
      context,
    );
    if (response == 200) {
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

  void editProfileWindow(double width) {
    showDialog(
      context: context,
      builder: (context) => MihPackageWindow(
        fullscreen: false,
        windowTitle: "Edit Profile",
        onWindowTapClose: () {
          Navigator.of(context).pop();
        },
        windowBody: Padding(
          padding:
              MzanziInnovationHub.of(context)!.theme.screenType == "desktop"
                  ? EdgeInsets.symmetric(horizontal: width * 0.05)
                  : EdgeInsets.symmetric(horizontal: width * 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              MihForm(
                formKey: _formKey,
                formFields: [
                  Center(
                    child: MihCircleAvatar(
                      imageFile: propicPreview,
                      width: 150,
                      editable: true,
                      fileNameController: proPicController,
                      userSelectedfile: proPic,
                      frameColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      backgroundColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                      onChange: (selectedImage) {
                        setState(() {
                          proPic = selectedImage;
                        });
                      },
                    ),
                  ),
                  // const SizedBox(height: 25.0),
                  Visibility(
                    visible: false,
                    child: MihTextFormField(
                      fillColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      inputColor:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                      controller: proPicController,
                      multiLineInput: false,
                      requiredText: true,
                      readOnly: true,
                      hintText: "Selected File Name",
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  MihTextFormField(
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    controller: usernameController,
                    multiLineInput: false,
                    requiredText: true,
                    hintText: "Username",
                    validator: (value) {
                      return MihValidationServices().validateUsername(value);
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
                    hintText: "Last Name",
                    validator: (value) {
                      return MihValidationServices().isEmpty(value);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  MihToggle(
                    hintText: "Activate Business Account",
                    initialPostion: businessUser,
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    secondaryFillColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    onChange: (value) {
                      setState(() {
                        businessUser = value;
                      });
                    },
                  ),
                  const SizedBox(height: 30.0),
                  Center(
                    child: MihButton(
                      onPressed: () {
                        //Add validation here
                        if (_formKey.currentState!.validate()) {
                          submitForm();
                        } else {
                          MihAlertServices().formNotFilledCompletely(context);
                        }
                      },
                      buttonColor:
                          MzanziInnovationHub.of(context)!.theme.successColor(),
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
                ],
              ),
            ],
          ),
        ),
      ),
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
    if (AppEnviroment.getEnv() == "Prod") {
      env = "Prod";
    } else {
      env = "Dev";
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
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(screenWidth),
    );
  }

  Widget getBody(double width) {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Padding(
            padding:
                MzanziInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.2)
                    : EdgeInsets.symmetric(horizontal: width * 0.075),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: MihCircleAvatar(
                    imageFile: propicPreview,
                    width: 150,
                    editable: false,
                    fileNameController: proPicController,
                    userSelectedfile: proPic,
                    frameColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    backgroundColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    onChange: (selectedImage) {
                      setState(() {
                        proPic = selectedImage;
                      });
                    },
                  ),
                ),
                FittedBox(
                  child: Text(
                    "@${widget.arguments.signedInUser.username}",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    "${widget.arguments.signedInUser.fname} ${widget.arguments.signedInUser.lname}",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    businessUser ? "Business" : "Personal",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: Text(
                    "*DEMO TEXT* This would be the bio of the user telling us a bit about themself and let. This would be the bio of the user telling us a bit about themself and let. This would be the bio of the user telling us a bit about themself",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Center(
                  child: MihButton(
                    onPressed: () {
                      // Connect with the user
                    },
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.successColor(),
                    width: 300,
                    child: Text(
                      "Connect",
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
              ],
            ),
          ),
        ),
        Positioned(
          right: 5,
          bottom: 10,
          child: MihFloatingMenu(
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                child: Icon(
                  Icons.edit,
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                ),
                label: "Edit Profile",
                labelBackgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                labelStyle: TextStyle(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                onTap: () {
                  editProfileWindow(width);
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
