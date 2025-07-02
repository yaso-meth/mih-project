import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_business_card.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_location_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_success_message.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/arguments.dart';

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
      statusCode = await MihBusinessDetailsServices().updateBusinessDetails(
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

  void editBizProfileWindow(double width) {
    showDialog(
        context: context,
        builder: (context) => MihPackageWindow(
              fullscreen: false,
              windowTitle: 'Edit Profile',
              onWindowTapClose: () {
                Navigator.of(context).pop();
              },
              windowBody: MihSingleChildScroll(
                child: Padding(
                  padding: MzanziInnovationHub.of(context)!.theme.screenType ==
                          "desktop"
                      ? EdgeInsets.symmetric(horizontal: width * 0.05)
                      : EdgeInsets.symmetric(horizontal: width * 0),
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
                              frameColor: MzanziInnovationHub.of(context)!
                                  .theme
                                  .secondaryColor(),
                              backgroundColor: MzanziInnovationHub.of(context)!
                                  .theme
                                  .primaryColor(),
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
                              fillColor: MzanziInnovationHub.of(context)!
                                  .theme
                                  .secondaryColor(),
                              inputColor: MzanziInnovationHub.of(context)!
                                  .theme
                                  .primaryColor(),
                              controller: fileNameController,
                              multiLineInput: false,
                              requiredText: true,
                              readOnly: true,
                              hintText: "Selected File Name",
                            ),
                          ),
                          const SizedBox(height: 20),
                          MihTextFormField(
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            inputColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
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
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            inputColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
                            controller: nameController,
                            multiLineInput: false,
                            requiredText: true,
                            hintText: "Business Name",
                            validator: (value) {
                              return MihValidationServices().isEmpty(value);
                            },
                          ),
                          const SizedBox(height: 15),
                          MihDropdownField(
                            controller: typeController,
                            hintText: "Business Type",
                            dropdownOptions: const ["Doctors Office", "Other"],
                            editable: true,
                            enableSearch: true,
                            validator: (value) {
                              return MihValidationServices().isEmpty(value);
                            },
                            requiredText: true,
                          ),
                          const SizedBox(height: 10),
                          MihTextFormField(
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            inputColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
                            controller: practiceNoController,
                            multiLineInput: false,
                            requiredText:
                                typeController.text == "Doctors Office",
                            hintText: "Practice Number",
                            validator: (validateValue) {
                              return MihValidationServices()
                                  .isEmpty(validateValue);
                            },
                          ),
                          const SizedBox(height: 10),
                          MihTextFormField(
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            inputColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
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
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            inputColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
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
                            fillColor: MzanziInnovationHub.of(context)!
                                .theme
                                .secondaryColor(),
                            inputColor: MzanziInnovationHub.of(context)!
                                .theme
                                .primaryColor(),
                            controller: emailController,
                            multiLineInput: false,
                            requiredText: true,
                            hintText: "Business Email",
                            validator: (value) {
                              return MihValidationServices()
                                  .validateEmail(value);
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: MihTextFormField(
                                  fillColor: MzanziInnovationHub.of(context)!
                                      .theme
                                      .secondaryColor(),
                                  inputColor: MzanziInnovationHub.of(context)!
                                      .theme
                                      .primaryColor(),
                                  controller: locationController,
                                  multiLineInput: false,
                                  requiredText: true,
                                  hintText: "GPS Location",
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              MihButton(
                                onPressed: () {
                                  MIHLocationAPI()
                                      .getGPSPosition(context)
                                      .then((position) {
                                    if (position != null) {
                                      setState(() {
                                        locationController.text =
                                            "${position.latitude}, ${position.longitude}";
                                      });
                                    }
                                  });
                                },
                                buttonColor: MzanziInnovationHub.of(context)!
                                    .theme
                                    .secondaryColor(),
                                width: 100,
                                child: Text(
                                  "Set",
                                  style: TextStyle(
                                    color: MzanziInnovationHub.of(context)!
                                        .theme
                                        .primaryColor(),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Center(
                            child: MihButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  submitForm();
                                } else {
                                  MihAlertServices()
                                      .formNotFilledCompletely(context);
                                }
                              },
                              buttonColor: MzanziInnovationHub.of(context)!
                                  .theme
                                  .successColor(),
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
              ),
            ));
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
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      borderOn: false,
      innerHorizontalPadding: 10,
      bodyItem: getBody(screenWidth, context),
    );
  }

  Widget getBody(double width, BuildContext context) {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Padding(
            padding:
                MzanziInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.2)
                    : EdgeInsets.symmetric(horizontal: width * 0.075),
            child: Column(
              children: [
                Center(
                  child: MihCircleAvatar(
                    imageFile: widget.logoImage,
                    width: 150,
                    editable: false,
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
                FittedBox(
                  child: Text(
                    widget.arguments.business!.Name,
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ),
                // Center(
                //   child: Text(
                //     "*DEMO TEXT* This would be the bio of the user telling us a bit about themself and let. This would be the bio of the user telling us a bit about themself and let. This would be the bio of the user telling us a bit about themself",
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.bold,
                //       color: MzanziInnovationHub.of(context)!
                //           .theme
                //           .secondaryColor(),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 700,
                  child: MihBusinessCard(
                    businessName: widget.arguments.business!.Name,
                    cellNumber: widget.arguments.business!.contact_no,
                    email: widget.arguments.business!.bus_email,
                    gpsLocation: widget.arguments.business!.gps_location,
                    //To-Do: Add the business Website
                    website:
                        "https://app.mzansi-innovation-hub.co.za/privacy.html",
                  ),
                ),
                const SizedBox(height: 30.0),
                Center(
                  child: MihButton(
                    onPressed: () {
                      // Connect with the user
                      editBizProfileWindow(width);
                    },
                    buttonColor:
                        MzanziInnovationHub.of(context)!.theme.successColor(),
                    width: 300,
                    child: Text(
                      "Edit Profile",
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
                  editBizProfileWindow(width);
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
