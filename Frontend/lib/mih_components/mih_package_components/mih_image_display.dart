import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MihImageDisplay extends StatefulWidget {
  final ImageProvider<Object>? imageFile;
  final double width;
  final double height;
  final bool editable;
  final TextEditingController fileNameController;
  final onChange;
  final PlatformFile? userSelectedfile;
  const MihImageDisplay({
    super.key,
    required this.imageFile,
    required this.width,
    required this.height,
    required this.editable,
    required this.fileNameController,
    required this.userSelectedfile,
    required this.onChange,
  });

  @override
  State<MihImageDisplay> createState() => _MihImageDisplayState();
}

class _MihImageDisplayState extends State<MihImageDisplay> {
  late ImageProvider<Object>? imagePreview;

  ImageProvider<Object>? getImage() {
    Color dark = const Color(0XFF3A4454);
    if (widget.imageFile == null) {
      if (MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark") ==
          dark) {
        print("here in light icon");
        return const AssetImage(
            'lib/mih_components/mih_package_components/assets/images/i-dont-know-dark.png');
      } else {
        print("here in dark icon");
        return const AssetImage(
            'lib/mih_components/mih_package_components/assets/images/i-dont-know-light.png');
      }
    } else {
      return widget.imageFile;
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      imagePreview = getImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.imageFile == null)
    return Container(
      // color: Colors.white,
      alignment: Alignment.center,
      width: widget.width,
      height: widget.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(widget.width * 0.1),
            child: Image(image: imagePreview!),
          ),
          Visibility(
            visible: widget.editable,
            child: Positioned(
              bottom: 5,
              right: 5,
              child: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: MihColors.getGreenColor(
                      MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                ),
                color: MihColors.getPrimaryColor(
                    MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
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
                icon: const Icon(
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
