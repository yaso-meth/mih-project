import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_toggle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MihPersonalProfile extends StatefulWidget {
  const MihPersonalProfile({super.key});

  @override
  State<MihPersonalProfile> createState() => _MihPersonalProfileState();
}

class _MihPersonalProfileState extends State<MihPersonalProfile> {
  TextEditingController proPicController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  PlatformFile? newSelectedProPic;
  bool businessUser = false;
  bool _controllersInitialized = false;
  String env = "";
  String oldProPicName = "";
  final _formKey = GlobalKey<FormState>();

  void initializeControllers(MzansiProfileProvider mzansiProfileProvider) {
    if (!_controllersInitialized && mzansiProfileProvider.user != null) {
      usernameController.text = mzansiProfileProvider.user!.username;
      fnameController.text = mzansiProfileProvider.user!.fname;
      lnameController.text = mzansiProfileProvider.user!.lname;
      purposeController.text = mzansiProfileProvider.user!.purpose;
      proPicController.text =
          mzansiProfileProvider.user!.pro_pic_path.isNotEmpty
              ? mzansiProfileProvider.user!.pro_pic_path.split("/").last
              : "";
      businessUser = mzansiProfileProvider.user!.type == "business";
      _controllersInitialized = true;
    }
  }

  void editProfileWindow(double width) {
    showDialog(
      context: context,
      builder: (context) => Consumer<MzansiProfileProvider>(
        builder: (BuildContext context,
            MzansiProfileProvider mzansiProfileProvider, Widget? child) {
          // usernameController.text = mzansiProfileProvider.user!.username;
          // fnameController.text = mzansiProfileProvider.user!.fname;
          // lnameController.text = mzansiProfileProvider.user!.lname;
          // purposeController.text = mzansiProfileProvider.user!.purpose;
          // proPicController.text =
          //     mzansiProfileProvider.user!.pro_pic_path.isNotEmpty
          //         ? mzansiProfileProvider.user!.pro_pic_path.split("/").last
          //         : "";
          initializeControllers(mzansiProfileProvider);
          return MihPackageWindow(
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
                          imageFile: newSelectedProPic != null
                              ? MemoryImage(newSelectedProPic!.bytes!)
                              : mzansiProfileProvider.userProfilePicture,
                          width: 150,
                          editable: true,
                          fileNameController: proPicController,
                          userSelectedfile: newSelectedProPic,
                          frameColor: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          backgroundColor: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          onChange: (selectedImage) {
                            setState(() {
                              newSelectedProPic = selectedImage;
                            });
                          },
                        ),
                      ),
                      // const SizedBox(height: 25.0),
                      Visibility(
                        visible: false,
                        child: MihTextFormField(
                          fillColor: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          inputColor: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          controller: proPicController,
                          multiLineInput: false,
                          requiredText: true,
                          readOnly: true,
                          hintText: "Selected File Name",
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        inputColor: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        controller: usernameController,
                        multiLineInput: false,
                        requiredText: true,
                        hintText: "Username",
                        validator: (value) {
                          return MihValidationServices()
                              .validateUsername(value);
                        },
                      ),
                      const SizedBox(height: 10.0),
                      MihTextFormField(
                        fillColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        inputColor: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
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
                        fillColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        inputColor: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
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
                        fillColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        inputColor: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
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
                        fillColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        secondaryFillColor: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
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
                              submitForm(mzansiProfileProvider);
                            } else {
                              MihAlertServices()
                                  .formNotFilledCompletely(context);
                            }
                          },
                          buttonColor: MihColors.getGreenColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          width: 300,
                          child: Text(
                            "Update",
                            style: TextStyle(
                              color: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
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
          );
        },
      ),
    );
  }

  Future<void> submitForm(MzansiProfileProvider mzansiProfileProvider) async {
    if (mzansiProfileProvider.user!.username != usernameController.text) {
      bool isUsernameUnique = await MihUserServices.isUsernameUnique(
          usernameController.text, context);
      if (isUsernameUnique == false) {
        notUniqueAlert();
        return;
      }
    }
    if (oldProPicName != proPicController.text) {
      await uploadSelectedFile(mzansiProfileProvider, newSelectedProPic);
    }
    await updateUserApiCall(mzansiProfileProvider);
  }

  Future<void> uploadSelectedFile(
      MzansiProfileProvider mzansiProfileProvider, PlatformFile? file) async {
    var response = await MihFileApi.uploadFile(
      mzansiProfileProvider.user!.app_id,
      env,
      "profile_files",
      file,
      context,
    );
    if (response == 200) {
      deleteFileApiCall(mzansiProfileProvider, oldProPicName);
    } else {
      internetConnectionPopUp();
    }
  }

  Future<void> deleteFileApiCall(
      MzansiProfileProvider mzansiProfileProvider, String filename) async {
    var response = await MihFileApi.deleteFile(
      mzansiProfileProvider.user!.app_id,
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

  Future<void> updateUserApiCall(
      MzansiProfileProvider mzansiProfileProvider) async {
    int responseCode = await MihUserServices().updateUserV2(
      mzansiProfileProvider.user!,
      fnameController.text,
      lnameController.text,
      usernameController.text,
      proPicController.text,
      purposeController.text,
      businessUser,
      context,
    );
    if (responseCode == 200) {
      setState(() {
        setProfileVariables(mzansiProfileProvider);
        newSelectedProPic = null;
      });
      bool stayOnPersonalSide = true;
      // if (originalProfileTypeIsBusiness == false && businessUser == true) {
      //   stayOnPersonalSide = false;
      // }
      String message = "Your information has been updated successfully!";
      context.pop();
      successPopUp(message, stayOnPersonalSide);
    } else {
      internetConnectionPopUp();
    }
  }

  Color getPurposeLimitColor(int limit) {
    if (_counter.value <= limit) {
      return MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark");
    } else {
      return MihColors.getRedColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark");
    }
  }

  void setProfileVariables(MzansiProfileProvider mzansiProfileProvider) {
    businessUser = mzansiProfileProvider.user!.type == "business";
    oldProPicName = mzansiProfileProvider.user!.pro_pic_path.isNotEmpty
        ? mzansiProfileProvider.user!.pro_pic_path.split("/").last
        : "";
    env = AppEnviroment.getEnv() == "Prod" ? env = "Prod" : env = "Dev";
  }

  void successPopUp(String message, bool stayOnPersonalSide) {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.check_circle_outline_rounded,
            size: 150,
            color: MihColors.getGreenColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          alertTitle: "Successfully Updated Profile",
          alertBody: Column(
            children: [
              Text(
                message,
                style: TextStyle(
                  color: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: MihButton(
                  onPressed: () {
                    context.pop();
                  },
                  buttonColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  elevation: 10,
                  width: 300,
                  child: Text(
                    "Dismiss",
                    style: TextStyle(
                      color: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          alertColour: MihColors.getGreenColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
        // return MIHSuccessMessage(
        //   successType: "Success",
        //   successMessage: message,
        // );
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

  void notUniqueAlert() {
    showDialog(
      context: context,
      builder: (context) {
        return MihPackageAlert(
          alertIcon: Icon(
            Icons.warning_amber_rounded,
            size: 100,
            color: MihColors.getRedColor(
                MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          ),
          alertTitle: "Too Slow, That Username is Taken",
          alertBody: const Text(
            "The username you have entered is already taken by another member of Mzansi. Please choose a different username and try again.",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          alertColour: MihColors.getRedColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        );
      },
    );
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
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        if (mzansiProfileProvider.user == null) {
          //Change to new user flow
          return Center(
            child: Mihloadingcircle(),
          );
        }
        // else if (mzansiProfileProvider.user!.username.isEmpty) {
        //   editProfileWindow(width);
        // }
        else {
          businessUser = mzansiProfileProvider.user!.type == "business";
          oldProPicName = mzansiProfileProvider.user!.pro_pic_path.isNotEmpty
              ? mzansiProfileProvider.user!.pro_pic_path.split("/").last
              : "";
          env = AppEnviroment.getEnv() == "Prod" ? env = "Prod" : env = "Dev";
          KenLogger.success(
              mzansiProfileProvider.userProfilePicture.toString());
          return MihSingleChildScroll(
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
                      imageFile: mzansiProfileProvider.userProfilePicture,
                      width: 150,
                      editable: false,
                      fileNameController: proPicController,
                      userSelectedfile: newSelectedProPic,
                      frameColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      backgroundColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      onChange: (selectedImage) {
                        setState(() {
                          newSelectedProPic = selectedImage;
                        });
                      },
                      key: ValueKey(mzansiProfileProvider.userProfilePicUrl),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      mzansiProfileProvider.user!.username.isNotEmpty
                          ? mzansiProfileProvider.user!.username
                          : "username",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      mzansiProfileProvider.user!.fname.isNotEmpty
                          ? "${mzansiProfileProvider.user!.fname} ${mzansiProfileProvider.user!.lname}"
                          : "Name Surname",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Text(
                      businessUser == true ? "Business" : "Personal",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Center(
                    child: SizedBox(
                      width: 700,
                      child: Text(
                        mzansiProfileProvider.user!.purpose.isNotEmpty
                            ? mzansiProfileProvider.user!.purpose
                            : "No Personal Mission added yet",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
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
                      buttonColor: MihColors.getGreenColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      width: 300,
                      child: Text(
                        mzansiProfileProvider.user!.username.isEmpty
                            ? "Set Up Profile"
                            : "Edit Profile",
                        style: TextStyle(
                          color: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
