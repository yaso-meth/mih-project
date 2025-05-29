import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_business_details_apis.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_file_api.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_location_api.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_env/env.dart';
import 'package:mzansi_innovation_hub/mih_objects/arguments.dart';

class MihBusinessDetails extends StatefulWidget {
  final BusinessArguments arguments;
  final ImageProvider<Object>? logoImage;
  const MihBusinessDetails({
    super.key,
    required this.arguments,
    required this.logoImage,
  });

  @override
  State<MihBusinessDetails> createState() => _MihBusinessDetailsState();
}

class _MihBusinessDetailsState extends State<MihBusinessDetails> {
  PlatformFile? imageFile;
  final fileNameController = TextEditingController();
  final regController = TextEditingController();
  final nameController = TextEditingController();
  final typeController = TextEditingController();
  final practiceNoController = TextEditingController();
  final vatNoController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  late String env;

  Future<void> submitForm() async {
    if (!isEmailValid()) {
      showDialog(
        context: context,
        builder: (context) {
          return const MIHErrorMessage(errorType: "Invalid Email");
        },
      );
    } else if (isFormFilled()) {
      int statusCode = 0;
      statusCode = await MihBusinessDetailsApi().updateBusinessDetails(
        widget.arguments.business!.business_id,
        nameController.text,
        typeController.text,
        regController.text,
        practiceNoController.text,
        vatNoController.text,
        emailController.text,
        contactController.text,
        locationController.text,
        fileNameController.text,
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
                alertTitle: "Error Updating Business Details",
                alertBody: Column(
                  children: [
                    Text(
                      "An error occurred while updating the business details. Please check internet connection and try again.",
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

  Future<bool> uploadFile() async {
    if (imageFile != null) {
      int uploadStatusCode = 0;
      uploadStatusCode = await MihFileApi.uploadFile(
        widget.arguments.business!.business_id,
        env,
        "business_files",
        imageFile!,
        context,
      );
      if (uploadStatusCode == 200) {
        int deleteStatusCode = 0;
        deleteStatusCode = await MihFileApi.deleteFile(
          widget.arguments.business!.logo_path.split("/").first,
          env,
          "business_files",
          widget.arguments.business!.logo_path.split("/").last,
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

  bool isFileSelected() {
    if (imageFile != null) {
      return true;
    } else {
      return false;
    }
  }

  bool isEmailValid() {
    String text = emailController.text;
    var regex = RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$');
    return regex.hasMatch(text);
  }

  bool isFormFilled() {
    if (regController.text.isEmpty ||
        nameController.text.isEmpty ||
        typeController.text.isEmpty ||
        practiceNoController.text.isEmpty ||
        vatNoController.text.isEmpty ||
        contactController.text.isEmpty ||
        emailController.text.isEmpty ||
        locationController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  @override
  void dispose() {
    super.dispose();
    fileNameController.dispose();
    regController.dispose();
    nameController.dispose();
    typeController.dispose();
    practiceNoController.dispose();
    vatNoController.dispose();
    contactController.dispose();
    emailController.dispose();
    locationController.dispose();
    imageFile = null;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fileNameController.text =
          widget.arguments.business!.logo_path.split("/").last;
      regController.text = widget.arguments.business!.registration_no;
      nameController.text = widget.arguments.business!.Name;
      typeController.text = widget.arguments.business!.type;
      practiceNoController.text = widget.arguments.business!.practice_no;
      vatNoController.text = widget.arguments.business!.vat_no;
      contactController.text = widget.arguments.business!.contact_no;
      emailController.text = widget.arguments.business!.bus_email;
      locationController.text = widget.arguments.business!.gps_location;
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
      borderOn: false,
      bodyItem: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    return MihSingleChildScroll(
        child: Column(
      children: [
        MihCircleAvatar(
          imageFile: widget.logoImage,
          width: 150,
          editable: true,
          fileNameController: fileNameController,
          userSelectedfile: imageFile,
          frameColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          backgroundColor:
              MzanziInnovationHub.of(context)!.theme.primaryColor(),
          onChange: (selectedfile) {
            setState(() {
              imageFile = selectedfile;
            });
          },
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
        MIHTextField(
          controller: regController,
          hintText: "Registration No.",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
        MIHTextField(
          controller: nameController,
          hintText: "Business Name",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
        MIHTextField(
          controller: typeController,
          hintText: "Business Type",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
        MIHTextField(
          controller: practiceNoController,
          hintText: "Practice Number",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
        MIHTextField(
          controller: vatNoController,
          hintText: "VAT Number",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
        MIHTextField(
          controller: contactController,
          hintText: "Contact Number",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
        MIHTextField(
          controller: emailController,
          hintText: "Email",
          editable: true,
          required: true,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Flexible(
              child: MIHTextField(
                controller: locationController,
                hintText: "Location",
                editable: false,
                required: false,
              ),
            ),
            const SizedBox(width: 10.0),
            MihButton(
              onPressed: () {
                MIHLocationAPI().getGPSPosition(context).then((position) {
                  if (position != null) {
                    setState(() {
                      locationController.text =
                          "${position.latitude}, ${position.longitude}";
                    });
                  }
                });
              },
              buttonColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              width: 100,
              child: Text(
                "Set",
                style: TextStyle(
                  color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        MihButton(
          onPressed: () {
            submitForm();
          },
          buttonColor: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
    ));
  }
}
