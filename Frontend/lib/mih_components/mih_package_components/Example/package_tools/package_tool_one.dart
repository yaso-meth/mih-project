import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_inputs_and_buttons/mih_text_input.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_layout/mih_single_child_scroll.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_button.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_tool_body.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_package_window.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_floating_menu.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_image_display.dart';

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
  void initState() {
    super.initState();
    setState(() {
      imagePreview = null;
      // const NetworkImage(
      //     "https://lh3.googleusercontent.com/nW4ZZ89Q1ATz7Ht3nsAVWXL_cwNi4gNusqQZiL60UuuI3FG-VM7bTYDoJ-sUr2kDTdorfQYjxo5PjDM-0MO5rA=s512");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MihPackageToolBody(
      borderOn: true,
      bodyItem: getBody(),
    );
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
              const SizedBox(height: 10),
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
              MIHTextField(
                controller: _fileNameController,
                hintText: "Selected Avatar File",
                editable: false,
                required: false,
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
              MIHTextField(
                controller: _imagefileController,
                hintText: "Selected Image File",
                editable: false,
                required: false,
              ),
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
