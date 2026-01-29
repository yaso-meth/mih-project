import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_image_display.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_my_business_user_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MihUpdateMyBusinessUserDetails extends StatefulWidget {
  const MihUpdateMyBusinessUserDetails({super.key});

  @override
  State<MihUpdateMyBusinessUserDetails> createState() =>
      _MihUpdateMyBusinessUserDetailsState();
}

class _MihUpdateMyBusinessUserDetailsState
    extends State<MihUpdateMyBusinessUserDetails> {
  final fileNameController = TextEditingController();
  final titleTextController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final accessController = TextEditingController();
  final signtureController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PlatformFile? userPicFile;
  PlatformFile? newSelectedSignaturePic;
  late String env;

  bool isFormFilled() {
    if (titleTextController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> uploadFile(MzansiProfileProvider mzansiProfileProvider) async {
    if (newSelectedSignaturePic != null) {
      int uploadStatusCode = 0;
      uploadStatusCode = await MihFileApi.uploadFile(
        mzansiProfileProvider.user!.app_id,
        env,
        "business_files",
        newSelectedSignaturePic!,
        context,
      );
      if (uploadStatusCode == 200) {
        signtureController.text = newSelectedSignaturePic!.name;
        int deleteStatusCode = 0;
        deleteStatusCode = await MihFileApi.deleteFile(
          mzansiProfileProvider.user!.app_id,
          env,
          "business_files",
          mzansiProfileProvider.businessUser!.sig_path.split("/").last,
          context,
        );
        if (deleteStatusCode == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return true; // No file selected, so no upload needed
    }
  }

  Future<void> submitForm(MzansiProfileProvider mzansiProfileProvider) async {
    if (isFormFilled()) {
      bool successfullyUploadedFile = await uploadFile(mzansiProfileProvider);
      if (!mounted) return;
      if (successfullyUploadedFile) {
        int statusCode = await MihMyBusinessUserServices().updateBusinessUser(
          mzansiProfileProvider.user!.app_id,
          mzansiProfileProvider.businessUser!.business_id,
          titleTextController.text,
          accessController.text,
          signtureController.text,
          mzansiProfileProvider,
          context,
        );
        if (!mounted) return;
        if (statusCode == 200) {
          String message = "Business details updated successfully";
          context.pop();
          successPopUp(message, false);
        } else {
          MihAlertServices().errorBasicAlert(
            "Error Updating Business User Details",
            "An error occurred while updating the business User details. Please check internet connection and try again.",
            context,
          );
        }
      } else {
        MihAlertServices().internetConnectionAlert(context);
      }
    } else {
      MihAlertServices().inputErrorAlert(context);
    }
  }

  void successPopUp(String message, bool stayOnPersonalSide) {
    MihAlertServices().successBasicAlert(
      "Success!",
      message,
      context,
    );
  }

  Widget getWindowBody(double width) {
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        return MihSingleChildScroll(
          child: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.2)
                    : EdgeInsets.symmetric(horizontal: width * 0.075),
            child: Column(
              children: [
                MihForm(
                  formKey: _formKey,
                  formFields: [
                    Center(
                      child: MihCircleAvatar(
                        imageFile: mzansiProfileProvider.userProfilePicture,
                        width: 150,
                        editable: false,
                        fileNameController: fileNameController,
                        userSelectedfile: userPicFile,
                        frameColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        backgroundColor: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        onChange: (_) {},
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: MihTextFormField(
                        fillColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        inputColor: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        controller: fileNameController,
                        multiLineInput: false,
                        requiredText: true,
                        readOnly: true,
                        hintText: "Selected File Name",
                      ),
                    ),
                    const SizedBox(height: 10),
                    MihTextFormField(
                      fillColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      inputColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      controller: titleTextController,
                      multiLineInput: false,
                      requiredText: true,
                      readOnly: false,
                      hintText: "Title",
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 10),
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
                      readOnly: true,
                      hintText: "First Name",
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 10),
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
                      readOnly: true,
                      hintText: "Surname",
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    MihTextFormField(
                      fillColor: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      inputColor: MihColors.getPrimaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                      controller: accessController,
                      multiLineInput: false,
                      requiredText: true,
                      hintText: "Access Level",
                      readOnly: true,
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 300,
                      alignment: Alignment.topLeft,
                      child: const Text(
                        "Signature:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: MihImageDisplay(
                        imageFile: newSelectedSignaturePic != null
                            ? MemoryImage(newSelectedSignaturePic!.bytes!)
                            : mzansiProfileProvider.businessUserSignature,
                        width: 300,
                        height: 200,
                        editable: true,
                        fileNameController: signtureController,
                        userSelectedfile: newSelectedSignaturePic,
                        onChange: (selectedFile) {
                          setState(() {
                            newSelectedSignaturePic = selectedFile;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Visibility(
                      visible: false,
                      child: MihTextFormField(
                        fillColor: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        inputColor: MihColors.getPrimaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                        controller: fileNameController,
                        multiLineInput: false,
                        requiredText: true,
                        readOnly: true,
                        hintText: "Selected Signature File",
                      ),
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: MihButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submitForm(mzansiProfileProvider);
                          } else {
                            MihAlertServices().inputErrorAlert(context);
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
                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void setControllers() {
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    fileNameController.text =
        mzansiProfileProvider.user!.pro_pic_path.split("/").last;
    signtureController.text =
        mzansiProfileProvider.businessUser!.sig_path.split("/").last;
    titleTextController.text = mzansiProfileProvider.businessUser!.title;
    fnameController.text = mzansiProfileProvider.user!.fname;
    lnameController.text = mzansiProfileProvider.user!.lname;
    accessController.text = mzansiProfileProvider.businessUser!.access;
    if (AppEnviroment.getEnv() == "Prod") {
      env = "Prod";
    } else {
      env = "Dev";
    }
  }

  @override
  void dispose() {
    super.dispose();
    fileNameController.dispose();
    titleTextController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    accessController.dispose();
    signtureController.dispose();
    userPicFile = null;
    newSelectedSignaturePic = null;
  }

  @override
  void initState() {
    super.initState();
    setControllers();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageWindow(
      fullscreen: false,
      windowTitle: "Edit Profile",
      onWindowTapClose: () {
        context.pop();
      },
      windowBody: getWindowBody(screenWidth),
    );
  }
}
