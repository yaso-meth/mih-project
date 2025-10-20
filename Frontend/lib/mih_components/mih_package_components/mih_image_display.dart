import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ken_logger/ken_logger.dart';
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
    KenLogger.success(widget.imageFile.toString());
    if (widget.imageFile == null) {
      return null;
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
          imagePreview != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(widget.width * 0.1),
                  child: Image(image: imagePreview!),
                )
              : Container(
                  width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: MihColors.getSecondaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                    borderRadius: BorderRadius.circular(widget.width * 0.1),
                  ),
                  child: Icon(
                    Icons.image_not_supported_rounded,
                    size: widget.width * 0.3,
                    color: MihColors.getPrimaryColor(
                        MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
                  ),
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
                    print("here 2 Error: $e");
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
