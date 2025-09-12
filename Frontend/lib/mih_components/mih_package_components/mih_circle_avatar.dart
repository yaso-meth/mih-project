import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MihCircleAvatar extends StatefulWidget {
  final ImageProvider<Object>? imageFile;
  final double width;
  final bool editable;
  final TextEditingController fileNameController;
  final onChange;
  final PlatformFile? userSelectedfile;
  final Color frameColor;
  final Color? backgroundColor;
  const MihCircleAvatar({
    super.key,
    required this.imageFile,
    required this.width,
    required this.editable,
    required this.fileNameController,
    required this.userSelectedfile,
    required this.frameColor,
    required this.backgroundColor,
    required this.onChange,
  });

  @override
  State<MihCircleAvatar> createState() => _MihCircleAvatarState();
}

class _MihCircleAvatarState extends State<MihCircleAvatar> {
  late ImageProvider<Object>? imagePreview;

  ImageProvider<Object>? getAvatar() {
    // Color dark = const Color(0XFF3A4454);
    if (widget.imageFile == null) {
      return null;
      // if (widget.backgroundColor == dark) {
      //   print("here in light icon");
      //   return const AssetImage(
      //       'lib/mih_components/mih_package_components/assets/images/i-dont-know-light.png');
      // } else {
      //   print("here in dark icon");
      //   return const AssetImage(
      //       'lib/mih_components/mih_package_components/assets/images/i-dont-know-dark.png');
      // }
    } else {
      return widget.imageFile;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      imagePreview = getAvatar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      alignment: Alignment.center,
      width: widget.width,
      height: widget.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Visibility(
            visible: imagePreview != null,
            child: Positioned(
              child: CircleAvatar(
                radius: widget.width / 2.2,
                backgroundColor: widget.backgroundColor,
                backgroundImage: imagePreview,
              ),
            ),
          ),
          Visibility(
            visible: imagePreview != null,
            child: Icon(
              size: widget.width,
              MihIcons.mihRing,
              color: widget.frameColor,
            ),
          ),
          Visibility(
            visible: imagePreview == null,
            child: Icon(
              MihIcons.iDontKnow,
              size: widget.width,
              color: widget.frameColor,
            ),
          ),
          Visibility(
            visible: widget.editable,
            child: Positioned(
              bottom: 0,
              right: 0,
              child: IconButton.filled(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    MihColors.getGreenColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
                ),
                onPressed: () async {
                  try {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    // print("Here 1");
                    if (MzansiInnovationHub.of(context)!.theme.getPlatform() ==
                        "Web") {
                      // print("Here 2");
                      if (result == null) return;
                      // print("Here 3");
                      PlatformFile? selectedFile = result.files.first;
                      setState(() {
                        // print("Here 4");
                        widget.onChange(selectedFile);
                        // print("Here 5");
                        imagePreview = MemoryImage(selectedFile.bytes!);
                      });

                      setState(() {
                        widget.fileNameController.text = selectedFile.name;
                      });
                    } else {
                      if (result != null) {
                        File file = File(result.files.single.path!);
                        PlatformFile? androidFile = PlatformFile(
                          path: file.path,
                          name: file.path.split('/').last,
                          size: file.lengthSync(),
                          bytes: await file.readAsBytes(), // Read file bytes
                          //extension: fileExtension,
                        );
                        setState(() {
                          widget.onChange(androidFile);
                          imagePreview = FileImage(file);
                        });

                        setState(() {
                          widget.fileNameController.text =
                              file.path.split('/').last;
                        });
                      } else {
                        print("here in else");
                        // User canceled the picker
                      }
                    }
                  } catch (e) {
                    print("Error: $e");
                  }
                },
                icon: Icon(
                  Icons.edit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
