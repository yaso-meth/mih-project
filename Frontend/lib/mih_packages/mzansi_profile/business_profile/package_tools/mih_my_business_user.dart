import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_file_api.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_my_business_user_apis.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_image_display.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';

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
  late String env;

  bool isFormFilled() {
    if (signtureController.text.isEmpty ||
        titleDropdownController.text.isEmpty ||
        titleTextController.text.isEmpty ||
        fnameController.text.isEmpty ||
        lnameController.text.isEmpty ||
        accessController.text.isEmpty) {
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
      int statusCode = await MihMyBusinessUserApi().updateBusinessUser(
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
    return MihPackageToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
  }

  Widget getBody() {
    return MihSingleChildScroll(
      child: Column(
        children: [
          const Text(
            "My Business User",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
              color: MzanziInnovationHub.of(context)?.theme.secondaryColor()),
          const SizedBox(height: 10),
          MihCircleAvatar(
            imageFile: widget.userProPicImage,
            width: 150,
            editable: false,
            fileNameController: fileNameController,
            userSelectedfile: userPicFile,
            frameColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            backgroundColor:
                MzanziInnovationHub.of(context)!.theme.primaryColor(),
            onChange: (_) {},
          ),
          Visibility(
            visible: false,
            child: MIHTextField(
              controller: fileNameController,
              hintText: "Selected File Name",
              editable: false,
              required: false,
            ),
          ),
          const SizedBox(height: 20),
          MIHDropdownField(
            controller: titleDropdownController,
            hintText: "Title",
            dropdownOptions: const ["Doctor", "Assistant", "Other"],
            required: true,
            editable: true,
            enableSearch: false,
          ),
          const SizedBox(height: 10),
          MIHTextField(
            controller: titleTextController,
            hintText: "Other Title",
            editable: true,
            required: true,
          ),
          const SizedBox(height: 10),
          MIHTextField(
            controller: fnameController,
            hintText: "Name",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10),
          MIHTextField(
            controller: lnameController,
            hintText: "Surname",
            editable: false,
            required: true,
          ),
          const SizedBox(height: 10),
          MIHTextField(
            controller: accessController,
            hintText: "Access Level",
            editable: false,
            required: true,
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
          MihImageDisplay(
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
          const SizedBox(height: 10),
          Visibility(
            visible: false,
            child: MIHTextField(
              controller: signtureController,
              hintText: "Selected Signature File",
              editable: false,
              required: true,
            ),
          ),
          const SizedBox(height: 15),
          MihButton(
            onPressed: () {
              submitForm();
            },
            buttonColor:
                MzanziInnovationHub.of(context)!.theme.secondaryColor(),
            width: 300,
            child: Text(
              "Update",
              style: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
