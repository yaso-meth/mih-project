import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_user_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MihEditPersonalProfileWindow extends StatefulWidget {
  const MihEditPersonalProfileWindow({super.key});

  @override
  State<MihEditPersonalProfileWindow> createState() =>
      _MihEditPersonalProfileWindowState();
}

class _MihEditPersonalProfileWindowState
    extends State<MihEditPersonalProfileWindow> {
  TextEditingController proPicController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  bool _controllersInitialized = false;
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  final _formKey = GlobalKey<FormState>();
  PlatformFile? newSelectedProPic;
  String oldProPicName = "";
  String env = "";
  bool businessUser = false;

  void initializeControllers(MzansiProfileProvider mzansiProfileProvider) {
    businessUser = mzansiProfileProvider.business != null;
    oldProPicName = mzansiProfileProvider.user!.pro_pic_path.isNotEmpty
        ? mzansiProfileProvider.user!.pro_pic_path.split("/").last
        : "";
    env = AppEnviroment.getEnv() == "Prod" ? env = "Prod" : env = "Dev";
    if (!_controllersInitialized && mzansiProfileProvider.user != null) {
      usernameController.text = mzansiProfileProvider.user!.username;
      fnameController.text = mzansiProfileProvider.user!.fname;
      lnameController.text = mzansiProfileProvider.user!.lname;
      purposeController.text = mzansiProfileProvider.user!.purpose;
      proPicController.text =
          mzansiProfileProvider.user!.pro_pic_path.isNotEmpty
              ? mzansiProfileProvider.user!.pro_pic_path.split("/").last
              : "";
      businessUser = mzansiProfileProvider.business != null;
      _controllersInitialized = true;
    }
  }

  Future<void> submitForm(MzansiProfileProvider mzansiProfileProvider) async {
    try {
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
    } catch (erro) {
      MihAlertServices().internetConnectionAlert(context);
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
        newSelectedProPic = null;
      });
      mzansiProfileProvider.syncWithMihServerData();
      String message = "Your information has been updated successfully!";
      successPopUp(
        mzansiProfileProvider,
        message,
      );
    } else {
      MihAlertServices().internetConnectionAlert(context);
    }
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
      MihAlertServices().internetConnectionAlert(context);
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
      MihAlertServices().internetConnectionAlert(context);
    }
  }

  void setProfileVariables(MzansiProfileProvider mzansiProfileProvider) {
    businessUser = mzansiProfileProvider.business != null;
    oldProPicName = mzansiProfileProvider.user!.pro_pic_path.isNotEmpty
        ? mzansiProfileProvider.user!.pro_pic_path.split("/").last
        : "";
    env = AppEnviroment.getEnv() == "Prod" ? env = "Prod" : env = "Dev";
  }

  Color getPurposeLimitColor(int limit) {
    if (_counter.value <= limit) {
      return MihColors.secondary();
    } else {
      return MihColors.red();
    }
  }

  void successPopUp(
    MzansiProfileProvider profileProvider,
    String message,
  ) {
    MihAlertServices().successAdvancedAlert(
      "Successfully Updated Profile",
      message,
      [
        MihButton(
          onPressed: () {
            context.pop();
            context.pop();
          },
          buttonColor: MihColors.primary(),
          elevation: 10,
          width: 300,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: MihColors.secondary(),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
      context,
    );
  }

  void setupBusinessPopUp(
    MzansiProfileProvider profileProvider,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: null,
          onWindowTapClose: null,
          windowBody: Column(
            children: [
              Icon(
                MihIcons.businessSetup,
                size: 150,
                color: MihColors.secondary(),
              ),
              Text(
                "Setup Business Profile?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MihColors.primary(),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "It looks like this is the first time activating your business account. Would you like to set up your business now or would you like to do it later?",
                style: TextStyle(
                  color: MihColors.secondary(),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    MihButton(
                      onPressed: () {
                        context.pop();
                        context.goNamed(
                          'businessProfileSetup',
                          extra: profileProvider.user,
                        );
                      },
                      buttonColor: MihColors.green(),
                      elevation: 10,
                      width: 300,
                      child: Text(
                        "Setup Business",
                        style: TextStyle(
                          color: MihColors.primary(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    MihButton(
                      onPressed: () {
                        context.pop();
                        context.pop();
                        context.pop();
                      },
                      buttonColor: MihColors.orange(),
                      elevation: 10,
                      width: 300,
                      child: Text(
                        "Setup Later",
                        style: TextStyle(
                          color: MihColors.primary(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void notUniqueAlert() {
    MihAlertServices().errorBasicAlert(
      "Too Slow, That Username is Taken",
      "The username you have entered is already taken by another member of Mzansi. Please choose a different username and try again.",
      context,
    );
  }

  @override
  void initState() {
    super.initState();
    initializeControllers(context.read<MzansiProfileProvider>());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Edit Profile",
          onWindowTapClose: () {
            Navigator.of(context).pop();
          },
          windowBody: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: screenWidth * 0.05)
                    : EdgeInsets.symmetric(horizontal: screenWidth * 0),
            child: Stack(
              children: [
                Column(
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
                            expandable: false,
                            editable: true,
                            fileNameController: proPicController,
                            userSelectedfile: newSelectedProPic,
                            frameColor: MihColors.secondary(),
                            backgroundColor: MihColors.primary(),
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
                            fillColor: MihColors.secondary(),
                            inputColor: MihColors.primary(),
                            controller: proPicController,
                            multiLineInput: false,
                            requiredText: true,
                            readOnly: true,
                            hintText: "Selected File Name",
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          children: [
                            Text(
                              "*NB: Internet connection required to update profile.",
                              style: TextStyle(
                                color: MihColors.red(),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        MihTextFormField(
                          fillColor: MihColors.secondary(),
                          inputColor: MihColors.primary(),
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
                          fillColor: MihColors.secondary(),
                          inputColor: MihColors.primary(),
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
                          fillColor: MihColors.secondary(),
                          inputColor: MihColors.primary(),
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
                          fillColor: MihColors.secondary(),
                          inputColor: MihColors.primary(),
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
                            builder: (BuildContext context, int value,
                                Widget? child) {
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
                        // const SizedBox(height: 10.0),
                        // MihToggle(
                        //   hintText: "Activate Business Account",
                        //   initialPostion: businessUser,
                        //   fillColor: MihColors.secondary(),
                        //   secondaryFillColor: MihColors.primary(),
                        //   onChange: (value) {
                        //     setState(() {
                        //       businessUser = value;
                        //     });
                        //     KenLogger.success("Business User: $businessUser");
                        //   },
                        // ),
                        const SizedBox(height: 30.0),
                        Center(
                          child: MihButton(
                            onPressed: () {
                              //Add validation here
                              if (_formKey.currentState!.validate()) {
                                submitForm(mzansiProfileProvider);
                              } else {
                                MihAlertServices().inputErrorAlert(context);
                              }
                            },
                            buttonColor: MihColors.green(),
                            width: 300,
                            child: Text(
                              mzansiProfileProvider.user!.username.isEmpty
                                  ? "Setup Profile"
                                  : "Update",
                              style: TextStyle(
                                color: MihColors.primary(),
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
                Positioned(
                  right: 0,
                  top: 0,
                  child: MihButton(
                    onPressed: () {
                      //Add validation here
                      if (_formKey.currentState!.validate()) {
                        submitForm(mzansiProfileProvider);
                      } else {
                        MihAlertServices().inputErrorAlert(context);
                      }
                    },
                    buttonColor: MihColors.green(),
                    width: 100,
                    height: 25,
                    child: Text(
                      mzansiProfileProvider.user!.username.isEmpty
                          ? "Setup Profile"
                          : "Update",
                      style: TextStyle(
                        color: MihColors.primary(),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
