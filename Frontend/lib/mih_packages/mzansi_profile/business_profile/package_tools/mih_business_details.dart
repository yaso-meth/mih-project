import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_business_details_apis.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_file_api.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_location_api.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_dropdown_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
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
  final _formKey = GlobalKey<FormState>();
  late String env;

  Future<void> submitForm() async {
    if (isFormFilled()) {
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
    if (typeController.text.isEmpty) {
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
      innerHorizontalPadding: 10,
      bodyItem: getBody(context),
    );
  }

  Widget getBody(BuildContext context) {
    return MihSingleChildScroll(
        child: Column(
      children: [
        MihForm(
          formKey: _formKey,
          formFields: [
            Center(
              child: MihCircleAvatar(
                imageFile: widget.logoImage,
                width: 150,
                editable: true,
                fileNameController: fileNameController,
                userSelectedfile: imageFile,
                frameColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                backgroundColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                onChange: (selectedfile) {
                  setState(() {
                    imageFile = selectedfile;
                  });
                },
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
            MihTextFormField(
              fillColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              controller: regController,
              multiLineInput: false,
              requiredText: true,
              hintText: "Registration No.",
              validator: (value) {
                return MihValidationServices().isEmpty(value);
              },
            ),
            const SizedBox(height: 10),
            MihTextFormField(
              fillColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              controller: nameController,
              multiLineInput: false,
              requiredText: true,
              hintText: "Business Name",
              validator: (value) {
                return MihValidationServices().isEmpty(value);
              },
            ),
            const SizedBox(height: 15),
            MIHDropdownField(
              controller: typeController,
              hintText: "Business Type",
              dropdownOptions: const ["Doctors Office", "Other"],
              required: true,
              editable: true,
              enableSearch: false,
            ),
            const SizedBox(height: 10),
            MihTextFormField(
              fillColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              controller: practiceNoController,
              multiLineInput: false,
              requiredText: typeController.text == "Doctors Office",
              hintText: "Practice Number",
              validator: (validateValue) {
                return MihValidationServices().isEmpty(validateValue);
              },
            ),
            const SizedBox(height: 10),
            MihTextFormField(
              fillColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              controller: vatNoController,
              multiLineInput: false,
              requiredText: true,
              hintText: "VAT Number",
              validator: (value) {
                return MihValidationServices().isEmpty(value);
              },
            ),
            const SizedBox(height: 10),
            MihTextFormField(
              fillColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              controller: contactController,
              multiLineInput: false,
              requiredText: true,
              hintText: "Contact Number",
              validator: (value) {
                return MihValidationServices().isEmpty(value);
              },
            ),
            const SizedBox(height: 10),
            MihTextFormField(
              fillColor:
                  MzanziInnovationHub.of(context)!.theme.secondaryColor(),
              inputColor: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              controller: emailController,
              multiLineInput: false,
              requiredText: true,
              hintText: "Business Email",
              validator: (value) {
                return MihValidationServices().validateEmail(value);
              },
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: MihTextFormField(
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    controller: locationController,
                    multiLineInput: false,
                    requiredText: true,
                    hintText: "GPS Location",
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
                      color:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Center(
              child: MihButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitForm();
                  }
                },
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                width: 300,
                child: Text(
                  "Update",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
    ));
  }
}
