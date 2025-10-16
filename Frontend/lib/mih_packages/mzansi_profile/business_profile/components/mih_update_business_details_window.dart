import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_alert.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_error_message.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_providers/mzansi_profile_provider.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_env.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_business_details_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_location_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:provider/provider.dart';

class MihUpdateBusinessDetailsWindow extends StatefulWidget {
  final double width;
  const MihUpdateBusinessDetailsWindow({
    super.key,
    required this.width,
  });

  @override
  State<MihUpdateBusinessDetailsWindow> createState() =>
      _MihUpdateBusinessDetailsWindowState();
}

class _MihUpdateBusinessDetailsWindowState
    extends State<MihUpdateBusinessDetailsWindow> {
  final _formKey = GlobalKey<FormState>();
  PlatformFile? newSelectedLogoPic;
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
  final ValueNotifier<int> _counter = ValueNotifier<int>(0);
  late String env;

  void setContactNumberControllers(
      MzansiProfileProvider mzansiProfileProvider) {
    if (mzansiProfileProvider.business!.contact_no[0] == "+") {
      List<String> contactDetails =
          mzansiProfileProvider.business!.contact_no.split("-");
      setState(() {
        countryCodeController.text = contactDetails[0];
        contactController.text = contactDetails[1];
      });
    } else {
      setState(() {
        countryCodeController.text = "+27";
        contactController.text = mzansiProfileProvider.business!.contact_no;
      });
    }
  }

  void setControllers() {
    MzansiProfileProvider mzansiProfileProvider =
        context.read<MzansiProfileProvider>();
    setState(() {
      fileNameController.text =
          mzansiProfileProvider.business!.logo_path.split("/").last;
      regController.text = mzansiProfileProvider.business!.registration_no;
      nameController.text = mzansiProfileProvider.business!.Name;
      typeController.text = mzansiProfileProvider.business!.type;
      practiceNoController.text = mzansiProfileProvider.business!.practice_no;
      vatNoController.text = mzansiProfileProvider.business!.vat_no;
      emailController.text = mzansiProfileProvider.business!.bus_email;
      locationController.text = mzansiProfileProvider.business!.gps_location;
      websiteController.text = mzansiProfileProvider.business!.website;
      ratingController.text = mzansiProfileProvider.business!.rating;
      missionVisionController.text =
          mzansiProfileProvider.business!.mission_vision;
    });
    setContactNumberControllers(mzansiProfileProvider);
    if (AppEnviroment.getEnv() == "Prod") {
      env = "Prod";
    } else {
      env = "Dev";
    }
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

  void _updateMissionVisionCounter() {
    // New function name
    // No need for setState since you are using a ValueNotifier for _counter
    _counter.value = missionVisionController.text.characters.length;
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

  bool isFormFilled() {
    if (typeController.text.isEmpty) {
      return false;
    } else {
      return true;
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

  Future<bool> uploadFile(MzansiProfileProvider mzansiProfileProvider) async {
    if (newSelectedLogoPic != null) {
      int uploadStatusCode = 0;
      uploadStatusCode = await MihFileApi.uploadFile(
        mzansiProfileProvider.business!.business_id,
        env,
        "business_files",
        newSelectedLogoPic!,
        context,
      );
      if (uploadStatusCode == 200) {
        int deleteStatusCode = 0;
        deleteStatusCode = await MihFileApi.deleteFile(
          mzansiProfileProvider.business!.logo_path.split("/").first,
          env,
          "business_files",
          mzansiProfileProvider.business!.logo_path.split("/").last,
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
    KenLogger.success("Start Submit Form");
    if (isFormFilled()) {
      KenLogger.success("Form Filled");
      KenLogger.success("Start File Upload");
      bool successfullyUploadedFile = await uploadFile(mzansiProfileProvider);
      KenLogger.success(
          "File Upload Complete: outcome $successfullyUploadedFile");
      if (!mounted) return;
      KenLogger.success("is mounted");
      if (successfullyUploadedFile) {
        KenLogger.success("Start Details Update");
        int statusCode = 0;
        statusCode = await MihBusinessDetailsServices().updateBusinessDetailsV2(
          mzansiProfileProvider.business!.business_id,
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
          mzansiProfileProvider,
          context,
        );
        KenLogger.success("Details Update Complete: status code $statusCode");
        if (!mounted) return;
        KenLogger.success("is mounted");
        if (statusCode == 200) {
          KenLogger.success("Start Success Message");
          //You left of here
          String message = "Your information has been updated successfully!";
          context.pop();
          successPopUp(message, false);
          // File uploaded successfully
        } else {
          context.pop();
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
        context.pop();
        if (!mounted) return;
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
  void initState() {
    super.initState();
    setControllers();
    missionVisionController.addListener(_updateMissionVisionCounter);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MzansiProfileProvider>(
      builder: (BuildContext context,
          MzansiProfileProvider mzansiProfileProvider, Widget? child) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: 'Edit Profile',
          onWindowTapClose: () {
            context.pop();
          },
          windowBody: MihSingleChildScroll(
            child: Padding(
              padding:
                  MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                      ? EdgeInsets.symmetric(horizontal: widget.width * 0.05)
                      : EdgeInsets.symmetric(horizontal: widget.width * 0),
              child: Column(
                children: [
                  MihForm(
                    formKey: _formKey,
                    formFields: [
                      Center(
                        child: MihCircleAvatar(
                          imageFile: newSelectedLogoPic != null
                              ? MemoryImage(newSelectedLogoPic!.bytes!)
                              : mzansiProfileProvider.businessProfilePicture,
                          width: 150,
                          editable: true,
                          fileNameController: fileNameController,
                          userSelectedfile: newSelectedLogoPic,
                          frameColor: MihColors.getSecondaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          backgroundColor: MihColors.getPrimaryColor(
                              MzansiInnovationHub.of(context)!.theme.mode ==
                                  "Dark"),
                          onChange: (selectedfile) {
                            setState(() {
                              newSelectedLogoPic = selectedfile;
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
                          return MihValidationServices()
                              .validateNoSpecialChars(value);
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
                          return MihValidationServices().validateEmail(value);
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
                            dialogBackgroundColor: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                            barrierColor: MihColors.getPrimaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
                                    "Dark"),
                          ),
                          Expanded(
                            child: MihTextFormField(
                              fillColor: MihColors.getSecondaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              inputColor: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              controller: contactController,
                              numberMode: true,
                              multiLineInput: false,
                              requiredText: true,
                              hintText: null,
                              validator: (value) {
                                return MihValidationServices().isEmpty(value);
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
                          builder:
                              (BuildContext context, int value, Widget? child) {
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
                                  MzansiInnovationHub.of(context)!.theme.mode ==
                                      "Dark"),
                              inputColor: MihColors.getPrimaryColor(
                                  MzansiInnovationHub.of(context)!.theme.mode ==
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
                                context.pop();
                              });
                            },
                            buttonColor: MihColors.getSecondaryColor(
                                MzansiInnovationHub.of(context)!.theme.mode ==
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
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
