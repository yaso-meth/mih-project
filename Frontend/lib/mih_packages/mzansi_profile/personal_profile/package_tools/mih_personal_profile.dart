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
  final purposeController = TextEditingController();
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  PlatformFile? proPic;
  late ImageProvider<Object>? propicPreview;
  late bool originalProfileTypeIsBusiness;
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
            color: MzansiInnovationHub.of(context)!.theme.errorColor(),
          ),
          alertTitle: "Too Slow, That Username is Taken",
          alertBody: const Text(
            "The username you have entered is already taken by another member of Mzansi. Please choose a different username and try again.",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          alertColour: MzansiInnovationHub.of(context)!.theme.errorColor(),
        );
      },
    );
  }

  Future<void> submitForm() async {
    // print("============\nsubmiit form\n=================");
    if (widget.arguments.signedInUser.username != usernameController.text) {
      bool isUsernameUnique = await MihUserServices.isUsernameUnique(
          usernameController.text, context);
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
    int responseCode = await MihUserServices().updateUserV2(
      widget.arguments.signedInUser,
      fnameController.text,
      lnameController.text,
      usernameController.text,
      proPicController.text,
      purposeController.text,
      businessUser,
      context,
    );
    if (responseCode == 200) {
      bool stayOnPersonalSide = true;
      if (originalProfileTypeIsBusiness == false && businessUser == true) {
        stayOnPersonalSide = false;
      }
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(
        '/',
        arguments: AuthArguments(
          stayOnPersonalSide,
          // true,
          false,
        ),
      );
      String message = "Your information has been updated successfully!";
      successPopUp(message);
    } else {
      internetConnectionPopUp();
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

  Color getPurposeLimitColor(int limit) {
    if (_counter.value <= limit) {
      return MzansiInnovationHub.of(context)!.theme.secondaryColor();
    } else {
      return MzansiInnovationHub.of(context)!.theme.errorColor();
    }
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
              MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
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
                      frameColor: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      backgroundColor:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
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
                      fillColor: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      inputColor:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
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
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
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
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
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
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
                    controller: lnameController,
                    multiLineInput: false,
                    requiredText: true,
                    hintText: "Last Name",
                    validator: (value) {
                      return MihValidationServices().isEmpty(value);
                    },
                  ),
                  const SizedBox(height: 10.0),
                  MihTextFormField(
                    height: 250,
                    fillColor:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
                    controller: purposeController,
                    multiLineInput: true,
                    requiredText: true,
                    hintText: "Your Personal Mission",
                    validator: (value) {
                      return MihValidationServices()
                          .validateLength(purposeController.text, 256);
                    },
                  ),
                  SizedBox(
                    height: 15,
                    child: ValueListenableBuilder(
                      valueListenable: _counter,
                      builder:
                          (BuildContext context, int value, Widget? child) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "$value",
                              style: TextStyle(
                                color: getPurposeLimitColor(256),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "/256",
                              style: TextStyle(
                                color: getPurposeLimitColor(256),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  MihToggle(
                    hintText: "Activate Business Account",
                    initialPostion: businessUser,
                    fillColor:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    secondaryFillColor:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
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
                          MzansiInnovationHub.of(context)!.theme.successColor(),
                      width: 300,
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: MzansiInnovationHub.of(context)!
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
    purposeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var proPicName = "";
    if (widget.arguments.signedInUser.pro_pic_path.isNotEmpty) {
      proPicName = widget.arguments.signedInUser.pro_pic_path.split("/").last;
    }
    if (AppEnviroment.getEnv() == "Prod") {
      env = "Prod";
    } else {
      env = "Dev";
    }
    purposeController.addListener(() {
      setState(() {
        _counter.value = purposeController.text.characters.length;
      });
    });
    setState(() {
      propicPreview = widget.arguments.propicFile;
      oldProPicName = proPicName;
      proPicController.text = proPicName;
      fnameController.text = widget.arguments.signedInUser.fname;
      lnameController.text = widget.arguments.signedInUser.lname;
      usernameController.text = widget.arguments.signedInUser.username;
      purposeController.text = widget.arguments.signedInUser.purpose;
      businessUser = isBusinessUser();
      if (businessUser) {
        originalProfileTypeIsBusiness = true;
      } else {
        originalProfileTypeIsBusiness = false;
      }
    });
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
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
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
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    backgroundColor:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
                    onChange: (selectedImage) {
                      setState(() {
                        proPic = selectedImage;
                      });
                    },
                  ),
                ),
                FittedBox(
                  child: Text(
                    widget.arguments.signedInUser.username.isNotEmpty
                        ? widget.arguments.signedInUser.username
                        : "username",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    widget.arguments.signedInUser.fname.isNotEmpty
                        ? "${widget.arguments.signedInUser.fname} ${widget.arguments.signedInUser.lname}"
                        : "Name Surname",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: MzansiInnovationHub.of(context)!
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
                      color: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Center(
                  child: SizedBox(
                    width: 700,
                    child: Text(
                      widget.arguments.signedInUser.purpose.isNotEmpty
                          ? widget.arguments.signedInUser.purpose
                          : "No Personal Mission added yet",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Center(
                  child: MihButton(
                    onPressed: () {
                      // Connect with the user
                      editProfileWindow(width);
                    },
                    buttonColor:
                        MzansiInnovationHub.of(context)!.theme.successColor(),
                    width: 300,
                    child: Text(
                      widget.arguments.signedInUser.username.isEmpty
                          ? "Set Up Profile"
                          : "Edit Profile",
                      style: TextStyle(
                        color: MzansiInnovationHub.of(context)!
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
                  color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
                ),
                label: "Edit Profile",
                labelBackgroundColor:
                    MzansiInnovationHub.of(context)!.theme.successColor(),
                labelStyle: TextStyle(
                  color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
                  fontWeight: FontWeight.bold,
                ),
                backgroundColor:
                    MzansiInnovationHub.of(context)!.theme.successColor(),
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
