import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_business_info_card.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_location_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
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
  final countryCodeController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final locationController = TextEditingController();
  final websiteController = TextEditingController();
  final ratingController = TextEditingController();
  final missionVisionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  late String env;

  Future<void> submitForm() async {
    if (isFormFilled()) {
      int statusCode = 0;
      statusCode = await MihBusinessDetailsServices().updateBusinessDetailsV2(
        widget.arguments.business!.business_id,
        nameController.text,
        typeController.text,
        regController.text,
        practiceNoController.text,
        vatNoController.text,
        emailController.text,
        getNumberWithCountryCode(),
        // contactController.text,
        locationController.text,
        fileNameController.text,
        websiteController.text,
        ratingController.text.isEmpty ? "0" : ratingController.text,
        missionVisionController.text,
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
                  color: MihColors.getRedColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                alertTitle: "Error Updating Business Details",
                alertBody: Column(
                  children: [
                    Text(
                      "An error occurred while updating the business details. Please check internet connection and try again.",
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

  void setContactNumberControllers() {
    if (widget.arguments.business!.contact_no[0] == "+") {
      List<String> contactDetails =
          widget.arguments.business!.contact_no.split("-");
      setState(() {
        countryCodeController.text = contactDetails[0];
        contactController.text = contactDetails[1];
      });
    } else {
      setState(() {
        countryCodeController.text = "+27";
        contactController.text = widget.arguments.business!.contact_no;
      });
    }
  }

  String getNumberWithCountryCode() {
    String numberWithoutBeginingZero = "";
    if (contactController.text[0] == "0") {
      numberWithoutBeginingZero = contactController.text
          .replaceAll(" ", "")
          .substring(1, contactController.text.length);
    } else {
      numberWithoutBeginingZero = contactController.text.replaceAll("-", " ");
    }
    return "${countryCodeController.text}-$numberWithoutBeginingZero";
  }

  void editBizProfileWindow(double width) {
    showDialog(
        context: context,
        builder: (context) => MihPackageWindow(
              fullscreen: false,
              windowTitle: 'Edit Profile',
              onWindowTapClose: () {
                Navigator.of(context).pop();
                resetControllers();
              },
              windowBody: MihSingleChildScroll(
                child: Padding(
                  padding: MzansiInnovationHub.of(context)!.theme.screenType ==
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
                              frameColor: MihColors.getSecondaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              backgroundColor: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
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
                          const SizedBox(height: 20),
                          MihTextFormField(
                            fillColor: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            inputColor: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            controller: nameController,
                            multiLineInput: false,
                            requiredText: true,
                            hintText: "Business Name",
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
                            controller: typeController,
                            multiLineInput: false,
                            requiredText: true,
                            hintText: "Business Type",
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
                          Container(
                            width: 300,
                            alignment: Alignment.topLeft,
                            child: const Text(
                              "Contact Number:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CountryCodePicker(
                                padding: EdgeInsetsGeometry.all(0),
                                onChanged: (selectedCode) {
                                  setState(() {
                                    countryCodeController.text =
                                        selectedCode.toString();
                                  });
                                  debugPrint(
                                      "Selected Country Code: ${countryCodeController.text}");
                                },
                                initialSelection: countryCodeController.text,
                                showDropDownButton: false,
                                pickerStyle: PickerStyle.bottomSheet,
                                dialogBackgroundColor:
                                    MihColors.getPrimaryColor(
                                        MzansiInnovationHub.of(context)!
                                                .theme
                                                .mode ==
                                            "Dark"),
                                barrierColor: MihColors.getPrimaryColor(
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
                                        "Dark"),
                              ),
                              Expanded(
                                child: MihTextFormField(
                                  fillColor: MihColors.getSecondaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
                                  inputColor: MihColors.getPrimaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
                                  controller: contactController,
                                  numberMode: true,
                                  multiLineInput: false,
                                  requiredText: true,
                                  hintText: null,
                                  validator: (value) {
                                    return MihValidationServices()
                                        .isEmpty(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          MihTextFormField(
                            height: 250,
                            fillColor: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            inputColor: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            controller: missionVisionController,
                            multiLineInput: true,
                            requiredText: true,
                            hintText: "Business Mission & Vision",
                            validator: (value) {
                              return MihValidationServices().validateLength(
                                  missionVisionController.text, 256);
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
                                        color: getMissionVisionLimitColor(256),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      "/256",
                                      style: TextStyle(
                                        color: getMissionVisionLimitColor(256),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                );
                              },
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
                            controller: websiteController,
                            multiLineInput: false,
                            requiredText: false,
                            hintText: "Business Website",
                            validator: (value) {
                              return MihValidationServices()
                                  .validateWebsite(value, false);
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
                            controller: regController,
                            multiLineInput: false,
                            requiredText: false,
                            hintText: "Registration No.",
                            validator: (value) {
                              // return MihValidationServices().isEmpty(value);
                              return null;
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
                            controller: practiceNoController,
                            multiLineInput: false,
                            requiredText: false,
                            hintText: "Practice Number",
                            validator: (validateValue) {
                              return null;
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
                            controller: vatNoController,
                            multiLineInput: false,
                            requiredText: false,
                            hintText: "VAT Number",
                            validator: (value) {
                              // return MihValidationServices().isEmpty(value);
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: MihTextFormField(
                                  fillColor: MihColors.getSecondaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
                                  inputColor: MihColors.getPrimaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
                                          "Dark"),
                                  controller: locationController,
                                  multiLineInput: false,
                                  requiredText: true,
                                  readOnly: true,
                                  hintText: "GPS Location",
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              MihButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const Mihloadingcircle(
                                        message: "Getting your location",
                                      );
                                    },
                                  );
                                  MIHLocationAPI()
                                      .getGPSPosition(context)
                                      .then((position) {
                                    if (position != null) {
                                      setState(() {
                                        locationController.text =
                                            "${position.latitude}, ${position.longitude}";
                                      });
                                    }
                                    //Dismiss loading indicator
                                    Navigator.of(context).pop();
                                  });
                                },
                                buttonColor: MihColors.getSecondaryColor(
                                    MzansiInnovationHub.of(context)!
                                            .theme
                                            .mode ==
                                        "Dark"),
                                width: 100,
                                child: Text(
                                  "Set",
                                  style: TextStyle(
                                    color: MihColors.getPrimaryColor(
                                        MzansiInnovationHub.of(context)!
                                                .theme
                                                .mode ==
                                            "Dark"),
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
                              buttonColor: MihColors.getGreenColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              width: 300,
                              child: Text(
                                "Update",
                                style: TextStyle(
                                  color: MihColors.getPrimaryColor(
                                      MzansiInnovationHub.of(context)!
                                              .theme
                                              .mode ==
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
              ),
            ));
  }

  Color getMissionVisionLimitColor(int limit) {
    if (_counter.value <= limit) {
      return MihColors.getSecondaryColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark");
    } else {
      return MihColors.getRedColor(
          MzansiInnovationHub.of(context)!.theme.mode == "Dark");
    }
  }

  void resetControllers() {
    setState(() {
      fileNameController.text =
          widget.arguments.business!.logo_path.split("/").last;
      regController.text = widget.arguments.business!.registration_no;
      nameController.text = widget.arguments.business!.Name;
      typeController.text = widget.arguments.business!.type;
      practiceNoController.text = widget.arguments.business!.practice_no;
      vatNoController.text = widget.arguments.business!.vat_no;
      emailController.text = widget.arguments.business!.bus_email;
      locationController.text = widget.arguments.business!.gps_location;
      websiteController.text = widget.arguments.business!.website;
      ratingController.text = widget.arguments.business!.rating;
      missionVisionController.text = widget.arguments.business!.mission_vision;
    });
    setContactNumberControllers();
    if (AppEnviroment.getEnv() == "Prod") {
      env = "Prod";
    } else {
      env = "Dev";
    }
    missionVisionController.addListener(() {
      setState(() {
        _counter.value = missionVisionController.text.characters.length;
      });
    });
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
    websiteController.dispose();
    ratingController.dispose();
    missionVisionController.dispose();
    imageFile = null;
  }

  @override
  void initState() {
    super.initState();
    resetControllers();
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
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
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
                    frameColor: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    backgroundColor: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    widget.arguments.business!.type,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: MihColors.getSecondaryColor(
                          MzansiInnovationHub.of(context)!.theme.mode ==
                              "Dark"),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // FittedBox(
                //   child: Text(
                //     "Mission & Vision",
                //     style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.bold,
                //       color: MzansiInnovationHub.of(context)!
                //           .theme
                //           .secondaryColor(),
                //     ),
                //   ),
                // ),
                Center(
                  child: SizedBox(
                    width: 700,
                    child: Text(
                      widget.arguments.business!.mission_vision.isNotEmpty
                          ? widget.arguments.business!.mission_vision
                          : "No Mission & Vision added yet",
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
                const SizedBox(height: 20),
                SizedBox(
                  width: 700,
                  child: MihBusinessCard(
                    // businessid: widget.arguments.business!.business_id,
                    // businessName: widget.arguments.business!.Name,
                    // cellNumber: widget.arguments.business!.contact_no,
                    // email: widget.arguments.business!.bus_email,
                    // gpsLocation: widget.arguments.business!.gps_location,
                    // rating: widget.arguments.business!.rating.isNotEmpty
                    //     ? double.parse(widget.arguments.business!.rating)
                    //     : 0,
                    // website: widget.arguments.business!.website,
                    business: widget.arguments.business!,
                    startUpSearch: null,
                    width: width,
                  ),
                ),
                const SizedBox(height: 30.0),
                Center(
                  child: MihButton(
                    onPressed: () {
                      // Connect with the user
                      editBizProfileWindow(width);
                    },
                    buttonColor: MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    width: 300,
                    child: Text(
                      "Edit Profile",
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
        ),
        // Positioned(
        //   right: 5,
        //   bottom: 10,
        //   child: MihFloatingMenu(
        //     animatedIcon: AnimatedIcons.menu_close,
        //     children: [
        //       SpeedDialChild(
        //         child: Icon(
        //           Icons.edit,
        //           color: MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        //         ),
        //         label: "Edit Profile",
        //         labelBackgroundColor:
        //             MihColors.getGreenColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        //         labelStyle: TextStyle(
        //           color: MihColors.getPrimaryColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        //           fontWeight: FontWeight.bold,
        //         ),
        //         backgroundColor:
        //             MihColors.getGreenColor(MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
        //         onTap: () {
        //           editBizProfileWindow(width);
        //         },
        //       )
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
