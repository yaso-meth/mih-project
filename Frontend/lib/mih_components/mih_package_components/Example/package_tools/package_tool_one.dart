import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_objects/business.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_banner_ad.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_business_profile_preview.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_personal_profile_preview.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_pop_up_messages/mih_loading_circle.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';
import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_business_info_card.dart';
// import 'package:mzansi_innovation_hub/mih_packages/mzansi_profile/business_profile/components/mih_business_info_card.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_alert_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_location_services.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_date_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_dropdwn_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_numeric_stepper.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_image_display.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_radio_options.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_time_field.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_toggle.dart';
import 'package:redacted/redacted.dart';

class PackageToolOne extends StatefulWidget {
  final AppUser user;
  final Business business;
  const PackageToolOne({
    super.key,
    required this.user,
    required this.business,
  });

  @override
  State<PackageToolOne> createState() => _PackageToolOneState();
}

class _PackageToolOneState extends State<PackageToolOne> {
  late ImageProvider<Object>? imagePreview;
  PlatformFile? file;
  PlatformFile? imageFile;
  TextEditingController _fileNameController = TextEditingController();
  TextEditingController _imagefileController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController _textFieldZeroController = TextEditingController();
  TextEditingController _textFieldOneController = TextEditingController();
  TextEditingController _textFieldTwoController = TextEditingController();
  TextEditingController _textFieldThreeController = TextEditingController();
  TextEditingController _textFieldFourController = TextEditingController();
  TextEditingController _textFieldFiveController = TextEditingController();
  TextEditingController _textFieldSixController = TextEditingController();
  TextEditingController _textFieldSevenController = TextEditingController();
  TextEditingController _textFieldEightController = TextEditingController();
  TextEditingController _textFieldNineController = TextEditingController();
  bool switchpositioin = true;
  final FocusNode searchFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late Future<Position?> myCoordinates;
  String myLocation = "";

  void showTestFullWindow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: true,
          windowTitle: "Test Full",
          onWindowTapClose: () {
            Navigator.of(context).pop();
          },
          windowBody: Text("Testing Window Body"),
        );
      },
    );
  }

  void showTestWindow() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return MihPackageWindow(
          fullscreen: false,
          windowTitle: "Test No Full",
          menuOptions: [
            SpeedDialChild(
              child: Icon(
                Icons.add,
                color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
              ),
              label: "Show New Window",
              labelBackgroundColor: MihColors.getGreenColor(context),
              labelStyle: TextStyle(
                color: MzansiInnovationHub.of(context)!.theme.primaryColor(),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: MihColors.getGreenColor(context),
              onTap: () {
                // showTestWindow();
              },
            ),
          ],
          onWindowTapClose: () {
            Navigator.of(context).pop();
          },
          windowBody: Text(
              "Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body Testing Window Body "),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MihPackageToolBody(
      borderOn: false,
      bodyItem: getBody(screenWidth),
    );
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    _imagefileController.dispose();
    _searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      imagePreview = null;
      // const NetworkImage(
      //     "https://lh3.googleusercontent.com/nW4ZZ89Q1ATz7Ht3nsAVWXL_cwNi4gNusqQZiL60UuuI3FG-VM7bTYDoJ-sUr2kDTdorfQYjxo5PjDM-0MO5rA=s512");
    });

    // myCoordinates = MIHLocationAPI().getGPSPosition(context);
  }

  Widget getBody(double width) {
    return Stack(
      children: [
        MihSingleChildScroll(
          child: Padding(
            padding:
                MzansiInnovationHub.of(context)!.theme.screenType == "desktop"
                    ? EdgeInsets.symmetric(horizontal: width * 0.2)
                    : EdgeInsets.symmetric(horizontal: width * 0.075),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hello",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: MihButton(
                    onPressed: () {
                      KenLogger.success("Successfully tested");
                    },
                    buttonColor: MihColors.getGreenColor(context),
                    elevation: 10,
                    width: 300,
                    child: Text(
                      "Success Logger",
                      style: TextStyle(
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: MihButton(
                    onPressed: () {
                      KenLogger.error("Successfully tested");
                    },
                    buttonColor: MihColors.getRedColor(context),
                    elevation: 10,
                    width: 300,
                    child: Text(
                      "Error Logger",
                      style: TextStyle(
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: MihButton(
                    onPressed: () {
                      KenLogger.warning("Successfully tested");
                    },
                    buttonColor: MihColors.getOrangeColor(context),
                    elevation: 10,
                    width: 300,
                    child: Text(
                      "Warning Logger",
                      style: TextStyle(
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: MihButton(
                    onPressed: () {
                      KenLogger.info("Successfully tested");
                    },
                    buttonColor: MihColors.getBluishPurpleColor(context),
                    elevation: 10,
                    width: 300,
                    child: Text(
                      "Info Logger",
                      style: TextStyle(
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CountryCodePicker(
                  padding: EdgeInsetsGeometry.all(0),
                  onChanged: (selectedCode) {
                    debugPrint("Selected Country Code: $selectedCode");
                  },
                  initialSelection: '+27',
                  showDropDownButton: false,
                  pickerStyle: PickerStyle.bottomSheet,
                  dialogBackgroundColor:
                      MzansiInnovationHub.of(context)!.theme.primaryColor(),
                  barrierColor:
                      MzansiInnovationHub.of(context)!.theme.primaryColor(),
                ),
                const SizedBox(height: 10),
                Center(
                  child: MihButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const Mihloadingcircle(
                            message: "Getting your profile data",
                          );
                        },
                      );
                    },
                    buttonColor:
                        MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                    elevation: 10,
                    width: 300,
                    child: Text(
                      "Show Loading",
                      style: TextStyle(
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Personal Preview",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                MihPersonalProfilePreview(
                  user: widget.user,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Business Preview",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                    future: MIHLocationAPI().getGPSPosition(context),
                    builder: (context, asyncSnapshot) {
                      // print(asyncSnapshot.connectionState);
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        // return MihBusinessProfilePreview(
                        //   business: widget.business,
                        //   myLocation: null,
                        // ).redacted(
                        //   context: context,
                        //   redact: true,
                        // );
                        return Container(
                          width: 150,
                          height: 50,
                          // color: Colors.black,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else if (asyncSnapshot.hasError ||
                          !asyncSnapshot.hasData ||
                          asyncSnapshot.data == null) {
                        return Container(
                          width: 150,
                          height: 50,
                          color: Colors.red,
                          child: Center(child: Text("Location unavailable")),
                        );
                      } else {
                        final myLocation = asyncSnapshot.data
                            .toString()
                            .replaceAll("Latitude: ", "")
                            .replaceAll("Longitude: ", "");
                        print("My Location is this: $myLocation");
                        return MihBusinessProfilePreview(
                          business: widget.business,
                          myLocation: myLocation,
                        );
                      }
                    }),
                const SizedBox(height: 10),
                Text("This text should be redacted").redacted(
                  context: context,
                  redact: true,
                ),
                MihBusinessCard(
                  business: Business(
                    "business_id",
                    "Name",
                    "type",
                    "registration_no",
                    "logo_name",
                    "logo_path",
                    "+27812345679",
                    "bus_email",
                    "app_id",
                    "gps_location",
                    "practice_no",
                    "vat_no",
                    "website",
                    "rating",
                    "mission_vision",
                  ),
                  startUpSearch: '',
                  width: 300,
                ).redacted(
                  context: context,
                  redact: true,
                ),
                const SizedBox(height: 10),
                Divider(
                  color:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  thickness: 2,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ad Test",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                      ),
                    ),
                  ],
                ),
                MihBannerAd(),
                const SizedBox(height: 10),
                Divider(
                  color:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  thickness: 2,
                ),
                const SizedBox(height: 10),
                MihForm(
                  formKey: _formKey,
                  formFields: [
                    MihTextFormField(
                      width: 200,
                      fillColor: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      inputColor:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      controller: _textFieldZeroController,
                      multiLineInput: false,
                      requiredText: false,
                      hintText: "Username",
                      validator: (value) {
                        return MihValidationServices().validateUsername(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    MihTextFormField(
                      fillColor: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      inputColor:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      controller: _textFieldOneController,
                      multiLineInput: false,
                      requiredText: true,
                      hintText: "Email",
                      autofillHints: [AutofillHints.email],
                      validator: (value) {
                        return MihValidationServices().validateEmail(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    MihTextFormField(
                      fillColor: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      inputColor:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      controller: _textFieldTwoController,
                      multiLineInput: false,
                      requiredText: true,
                      hintText: "Password",
                      passwordMode: true,
                      autofillHints: [AutofillHints.password],
                      validator: (value) {
                        return MihValidationServices().validatePassword(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    MihTextFormField(
                      fillColor: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      inputColor:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      controller: _textFieldThreeController,
                      multiLineInput: false,
                      requiredText: true,
                      hintText: "Numbers Only",
                      numberMode: true,
                      validator: (value) => value == null || value.isEmpty
                          ? 'This Field is required'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    MihNumericStepper(
                      controller: _textFieldFiveController,
                      fillColor: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      inputColor:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      hintText: "Number Stepper",
                      requiredText: true,
                      minValue: 1,
                      maxValue: 5,
                      validationOn: true,
                    ),
                    const SizedBox(height: 10),
                    MihToggle(
                      hintText: "Toggle",
                      initialPostion: switchpositioin,
                      fillColor: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      secondaryFillColor:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      readOnly: false,
                      onChange: (value) {
                        setState(() {
                          switchpositioin = value;
                        });
                        print("Toggle Value: $switchpositioin");
                      },
                    ),
                    const SizedBox(height: 10),
                    MihRadioOptions(
                      controller: _textFieldSixController,
                      hintText: "Radio Options",
                      fillColor: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      secondaryFillColor:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      requiredText: true,
                      radioOptions: const ["Option 1", "Option 2"],
                    ),
                    const SizedBox(height: 10),
                    MihDropdownField(
                      controller: _textFieldNineController,
                      hintText: "Dropdown",
                      dropdownOptions: const [
                        "Option 1",
                        "Option 2",
                        "Option 3",
                      ],
                      editable: true,
                      enableSearch: true,
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                      requiredText: true,
                    ),
                    const SizedBox(height: 10),
                    MihDateField(
                      controller: _textFieldSevenController,
                      labelText: "Date Field",
                      required: true,
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    MihTimeField(
                      controller: _textFieldEightController,
                      labelText: "Time Field",
                      required: true,
                      validator: (value) {
                        return MihValidationServices().isEmpty(value);
                      },
                    ),
                    const SizedBox(height: 10),
                    MihTextFormField(
                      height: 250,
                      fillColor: MzansiInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      inputColor:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      controller: _textFieldFourController,
                      multiLineInput: true,
                      requiredText: false,
                      hintText: "Enter Multi Line Text",
                      validator: (value) {
                        return MihValidationServices()
                            .validateLength(_textFieldFourController.text, 50);
                      },
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: MihButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Process data
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Input Valid")),
                            );
                          } else {
                            MihAlertServices().formNotFilledCompletely(context);
                          }
                        },
                        buttonColor: MzansiInnovationHub.of(context)!
                            .theme
                            .secondaryColor(),
                        elevation: 10,
                        width: 300,
                        child: Text(
                          "Submit Form",
                          style: TextStyle(
                            color: MzansiInnovationHub.of(context)!
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
                const SizedBox(height: 10),
                Divider(
                  color:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  thickness: 2,
                ),
                const SizedBox(height: 10),
                MihSearchBar(
                  controller: _searchController,
                  hintText: "Ask Mzansi",
                  // prefixIcon: Icons.search,
                  prefixIcon: Icons.search,
                  prefixAltIcon: MihIcons.mzansiAi,
                  width: 300,
                  fillColor:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  hintColor:
                      MzansiInnovationHub.of(context)!.theme.primaryColor(),
                  onPrefixIconTap: () {
                    print("Search Icon Pressed: ${_searchController.text}");
                  },
                  searchFocusNode: searchFocusNode,
                ),
                const SizedBox(height: 20),
                MihButton(
                  onPressed: () {
                    print("Button Pressed");
                  },
                  buttonColor:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  elevation: 10,
                  width: 300,
                  child: Text(
                    "Click Me",
                    style: TextStyle(
                      color:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                MihButton(
                  onPressed: () {
                    print("Button Pressed");
                  },
                  buttonColor: MihColors.getGreenColor(context),
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: MzansiInnovationHub.of(context)!
                            .theme
                            .primaryColor(),
                      ),
                      Text(
                        "Click Me",
                        style: TextStyle(
                          color: MzansiInnovationHub.of(context)!
                              .theme
                              .primaryColor(),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                MihButton(
                  onPressed: () {
                    print("Button Pressed");
                  },
                  buttonColor: MihColors.getRedColor(context),
                  width: 300,
                  child: Text(
                    "Click Me",
                    style: TextStyle(
                      color:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  color: Colors.black,
                  width: 200,
                  height: 200,
                  padding: EdgeInsets.zero,
                  alignment: Alignment.center,
                  child: IconButton.filled(
                    onPressed: () {},
                    icon: Icon(
                      MihIcons.mihLogo,
                      color:
                          MzansiInnovationHub.of(context)!.theme.primaryColor(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MihCircleAvatar(
                  imageFile: imagePreview,
                  width: 50,
                  editable: false,
                  fileNameController: _fileNameController,
                  userSelectedfile: file,
                  frameColor:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  backgroundColor:
                      MzansiInnovationHub.of(context)!.theme.primaryColor(),
                  onChange: (selectedImage) {
                    setState(() {
                      file = selectedImage;
                    });
                  },
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  inputColor:
                      MzansiInnovationHub.of(context)!.theme.primaryColor(),
                  controller: _fileNameController,
                  hintText: "Selected Avatar File",
                  requiredText: false,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
                MihImageDisplay(
                  imageFile: imagePreview,
                  width: 300,
                  height: 200,
                  editable: true,
                  fileNameController: _imagefileController,
                  userSelectedfile: imageFile,
                  onChange: (selectedFile) {
                    setState(() {
                      imageFile = selectedFile;
                    });
                  },
                ),
                const SizedBox(height: 10),
                MihTextFormField(
                  fillColor:
                      MzansiInnovationHub.of(context)!.theme.secondaryColor(),
                  inputColor:
                      MzansiInnovationHub.of(context)!.theme.primaryColor(),
                  controller: _imagefileController,
                  hintText: "Selected Image File",
                  requiredText: false,
                  readOnly: false,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: MihFloatingMenu(
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  child: Icon(
                    Icons.add,
                    color:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                  label: "Show New Window",
                  labelBackgroundColor: MihColors.getGreenColor(context),
                  labelStyle: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: MihColors.getGreenColor(context),
                  onTap: () {
                    showTestWindow();
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.add,
                    color:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                  label: "Show New Full Window",
                  labelBackgroundColor: MihColors.getGreenColor(context),
                  labelStyle: TextStyle(
                    color:
                        MzansiInnovationHub.of(context)!.theme.primaryColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor: MihColors.getGreenColor(context),
                  onTap: () {
                    showTestFullWindow();
                  },
                ),
              ]),
        )
      ],
    );
  }
}
