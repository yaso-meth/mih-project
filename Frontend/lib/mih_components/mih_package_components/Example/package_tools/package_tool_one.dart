import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_apis/mih_validation_services.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_form.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_image_display.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_search_bar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_text_form_field.dart';

class PackageToolOne extends StatefulWidget {
  const PackageToolOne({super.key});

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
  final FocusNode searchFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

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
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
              ),
              label: "Show New Window",
              labelBackgroundColor:
                  MzanziInnovationHub.of(context)!.theme.successColor(),
              labelStyle: TextStyle(
                color: MzanziInnovationHub.of(context)!.theme.primaryColor(),
                fontWeight: FontWeight.bold,
              ),
              backgroundColor:
                  MzanziInnovationHub.of(context)!.theme.successColor(),
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
    return MihPackageToolBody(
      borderOn: true,
      bodyItem: getBody(),
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
  }

  Widget getBody() {
    return Stack(
      children: [
        MihSingleChildScroll(
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
                      color: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              MihForm(
                formKey: _formKey,
                formFields: [
                  MihTextFormField(
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    controller: _textFieldZeroController,
                    multiLineInput: false,
                    requiredText: true,
                    hintText: "Username",
                    validator: (value) {
                      return MihValidationServices().validateUsername(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  MihTextFormField(
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                  MihTextFormField(
                    height: 250,
                    fillColor:
                        MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                    inputColor:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    controller: _textFieldFourController,
                    multiLineInput: true,
                    requiredText: false,
                    hintText: "Enter Multi Line Text",
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
                        }
                      },
                      buttonColor: MzanziInnovationHub.of(context)!
                          .theme
                          .secondaryColor(),
                      elevation: 10,
                      width: 300,
                      child: Text(
                        "Click Me",
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
              const SizedBox(height: 10),
              Divider(
                color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
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
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                hintColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                elevation: 10,
                width: 300,
                child: Text(
                  "Click Me",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.successColor(),
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color:
                          MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    ),
                    Text(
                      "Click Me",
                      style: TextStyle(
                        color: MzanziInnovationHub.of(context)!
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
                buttonColor:
                    MzanziInnovationHub.of(context)!.theme.errorColor(),
                width: 300,
                child: Text(
                  "Click Me",
                  style: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                backgroundColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                onChange: (selectedImage) {
                  setState(() {
                    file = selectedImage;
                  });
                },
              ),
              const SizedBox(height: 10),
              MihTextFormField(
                fillColor:
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                inputColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
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
                    MzanziInnovationHub.of(context)!.theme.secondaryColor(),
                inputColor:
                    MzanziInnovationHub.of(context)!.theme.primaryColor(),
                controller: _imagefileController,
                hintText: "Selected Image File",
                requiredText: false,
                readOnly: false,
              ),
              const SizedBox(height: 10),
            ],
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
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                  label: "Show New Window",
                  labelBackgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
                  labelStyle: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
                  onTap: () {
                    showTestWindow();
                  },
                ),
                SpeedDialChild(
                  child: Icon(
                    Icons.add,
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                  ),
                  label: "Show New Full Window",
                  labelBackgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
                  labelStyle: TextStyle(
                    color:
                        MzanziInnovationHub.of(context)!.theme.primaryColor(),
                    fontWeight: FontWeight.bold,
                  ),
                  backgroundColor:
                      MzanziInnovationHub.of(context)!.theme.successColor(),
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
