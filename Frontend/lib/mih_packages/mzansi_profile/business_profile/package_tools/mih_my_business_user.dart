import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_my_business_user_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_image_display.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
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
  final titleDropdownController = TextEditingController();
  final titleTextController = TextEditingController();
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final accessController = TextEditingController();
  final signtureController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String env;

  bool isFormFilled() {
    if (titleDropdownController.text.isEmpty) {
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
        titleDropdownController.text,
        accessController.text,
        signtureController.text,
        context,
      );
      if (statusCode == 200) {
        bool successfullyUploadedFile = await uploadFile();
        if (successfullyUploadedFile) {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(
            '/',
            arguments: AuthArguments(
              false,
              false,
            ),
          );
          // File uploaded successfully
          showDialog(
            context: context,
            builder: (context) {
              return const MIHSuccessMessage(
                successType: "Success",
                successMessage: "Business details updated successfully",
              );
            },
          );
        } else {
          // File upload failed
          showDialog(
            context: context,
            builder: (context) {
              return MihPackageAlert(
                alertIcon: Icon(
                  Icons.warning_rounded,
                  color: MzanziInnovationHub.of(context)!.theme.errorColor(),
                ),
                alertTitle: "Error Updating Business User Details",
                alertBody: Column(
                  children: [
                    Text(
                      "An error occurred while updating the business User details. Please check internet connection and try again.",
                      style: TextStyle(
                        color: MzanziInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                    ),
                  ],
                ),
                alertColour:
                    MzanziInnovationHub.of(context)!.theme.errorColor(),
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

  @override
  void dispose() {
    super.dispose();
    fileNameController.dispose();
    titleDropdownController.dispose();
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
      titleDropdownController.text = widget.arguments.businessUser!.title;
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
        padding: MzanziInnovationHub.of(context)!.theme.screenType == "desktop"
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
                    frameColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    backgroundColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    onChange: (_) {},
                  ),
                ),
                Visibility(
                  visible: false,
                  child: MihTextFormField(
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    controller: fileNameController,
                    multiLineInput: false,
                    requiredText: true,
                    readOnly: true,
                    hintText: "Selected File Name",
                  ),
                ),
                const SizedBox(height: 20),
                MihDropdownField(
                  controller: titleDropdownController,
                  hintText: "Title",
                  dropdownOptions: const ["Doctor", "Assistant", "Other"],
                  editable: true,
                  enableSearch: true,
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                  requiredText: true,
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  inputColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  controller: titleTextController,
                  multiLineInput: false,
                  requiredText: true,
                  hintText: "Other Title",
                  validator: (value) {
                    return MihValidationServices().isEmpty(value);
                  },
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  inputColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                  fillColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  inputColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                  fillColor:
                      MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                  inputColor:
                      MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                      fontSize: 15,
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
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
