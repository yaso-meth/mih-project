import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_my_business_user_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_image_display.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';

class MihMyBusinessUser extends StatefulWidget {
  final BusinessArguments arguments;
  final ImageProvider<Object>? userProPicImage;
  final ImageProvider<Object>? userSignatureImage;

  const MihMyBusinessUser({
    super.key,
    required this.arguments,
    required this.userProPicImage,
    required this.userSignatureImage,
  });

  @override
  State<MihMyBusinessUser> createState() => _MihMyBusinessUserState();
}

class _MihMyBusinessUserState extends State<MihMyBusinessUser> {
  PlatformFile? userPicFile;
  PlatformFile? userSignatureFile;
  final fileNameController = TextEditingController();
  final titleTextController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final accessController = TextEditingController();
  final signtureController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String env;

  bool isFormFilled() {
    if (titleTextController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> uploadFile() async {
    if (userSignatureFile != null) {
      int uploadStatusCode = 0;
      uploadStatusCode = await MihFileApi.uploadFile(
        widget.arguments.signedInUser.app_id,
        env,
        "business_files",
        userSignatureFile!,
        context,
      );
      if (uploadStatusCode == 200) {
        int deleteStatusCode = 0;
        deleteStatusCode = await MihFileApi.deleteFile(
          widget.arguments.signedInUser.app_id,
          env,
          "business_files",
          widget.arguments.businessUser!.sig_path.split("/").last,
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

  Future<void> submitForm() async {
    if (isFormFilled()) {
      int statusCode = await MihMyBusinessUserServices().updateBusinessUser(
        widget.arguments.signedInUser.app_id,
        widget.arguments.businessUser!.business_id,
        titleTextController.text,
        accessController.text,
        signtureController.text,
        context,
      );
      if (statusCode == 200) {
        bool successfullyUploadedFile = await uploadFile();
        if (successfullyUploadedFile) {
          // Navigator.of(context).pop();
          // Navigator.of(context).pop();
          // Navigator.of(context).pushNamed(
          //   '/',
          //   arguments: AuthArguments(
          //     false,
          //     false,
          //   ),
          // );
          // File uploaded successfully
          String message = "Business details updated successfully";
          successPopUp(message, false);
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return const MIHSuccessMessage(
          //       successType: "Success",
          //       successMessage: "Business details updated successfully",
          //     );
          //   },
          // );
        } else {
          // File upload failed
          showDialog(
            context: context,
            builder: (context) {
              return MihPackageAlert(
                alertIcon: Icon(
                  Icons.warning_rounded,
                  color: MihColors.getRedColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                alertTitle: "Error Updating Business User Details",
                alertBody: Column(
                  children: [
                    Text(
                      "An error occurred while updating the business User details. Please check internet connection and try again.",
                      style: TextStyle(
                        color: MihColors.getSecondaryColor(
                            MzansiInnovationHub.of(context)!.theme.mode ==
                                "Dark"),
                      ),
                    ),
                  ],
                ),
                alertColour: MihColors.getRedColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const MIHErrorMessage(errorType: "Internet Connection");
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Input Error");
        },
      );
    }
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
                    context.goNamed(
                      'mihHome',
                      extra: stayOnPersonalSide,
                    );
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
    userSignatureFile = null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fileNameController.text =
          widget.arguments.signedInUser.pro_pic_path.split("/").last;
      signtureController.text =
          widget.arguments.businessUser!.sig_path.split("/").last;
      titleTextController.text = widget.arguments.businessUser!.title;
      fnameController.text = widget.arguments.signedInUser.fname;
      lnameController.text = widget.arguments.signedInUser.lname;
      accessController.text = widget.arguments.businessUser!.access;
    });
    if (AppEnviroment.getEnv() == "Prod") {
      env = "Prod";
    } else {
      env = "Dev";
    }
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
    return MihSingleChildScroll(
      child: Padding(
        padding: MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
            ? EdgeInsets.symmetric(horizontal: width * 0.2)
            : EdgeInsets.symmetric(horizontal: width * 0.075),
        child: Column(
          children: [
            MihForm(
              formKey: _formKey,
              formFields: [
                Center(
                  child: MihCircleAvatar(
                    imageFile: widget.userProPicImage,
                    width: 150,
                    editable: false,
                    fileNameController: fileNameController,
                    userSelectedfile: userPicFile,
                    frameColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    backgroundColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    onChange: (_) {},
                  ),
                ),
                Visibility(
                  visible: false,
                  child: MihTextFormField(
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    controller: fileNameController,
                    multiLineInput: false,
                    requiredText: true,
                    readOnly: true,
                    hintText: "Selected File Name",
                  ),
                ),
                const SizedBox(height: 20),
                MihTextFormField(
                  fillColor: MihColors.getSecondaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  inputColor: MihColors.getPrimaryColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                    imageFile: widget.userSignatureImage,
                    width: 300,
                    height: 200,
                    editable: true,
                    fileNameController: signtureController,
                    userSelectedfile: userSignatureFile,
                    onChange: (selectedFile) {
                      setState(() {
                        userSignatureFile = selectedFile;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: false,
                  child: MihTextFormField(
                    fillColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    inputColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                        submitForm();
                      } else {
                        MihAlertServices().formNotFilledCompletely(context);
                      }
                    },
                    buttonColor: MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
  }
}
