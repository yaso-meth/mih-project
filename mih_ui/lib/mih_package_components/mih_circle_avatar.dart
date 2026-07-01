import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/main.dart';

class MihCircleAvatar extends StatefulWidget {
  final ImageProvider<Object>? imageFile;
  final double width;
  final bool expandable;
  final bool editable;
  final TextEditingController? fileNameController;
  final onChange;
  final PlatformFile? userSelectedfile;
  final Color frameColor;
  final Color? backgroundColor;
  const MihCircleAvatar({
    super.key,
    required this.imageFile,
    required this.width,
    required this.expandable,
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
    if (widget.imageFile == null) {
      return null;
    } else {
      return widget.imageFile;
    }
  }

  void expandAvatar() {
    showDialog(
        context: context,
        builder: (context) {
          return MihPackageWindow(
            fullscreen: true,
            windowTitle: "",
            scrollbarOn: false,
            onWindowTapClose: () {
              context.pop();
            },
            windowBody: SizedBox.expand(
              child: InteractiveViewer(
                child: Image(image: imagePreview!),
              ),
            ),
          );
        });
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
    return GestureDetector(
      onTap: widget.expandable
          ? () {
              KenLogger.success("Avatar tapped");
              expandAvatar();
            }
          : null,
      child: Container(
        alignment: Alignment.center,
        width: widget.width,
        height: widget.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Visibility(
              visible: imagePreview != null,
              child: Positioned(
                right: widget.width * 0.03,
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
                MihIcons.mihIDontKnow,
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
                      MihColors.green(),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      FilePickerResult? result = await FilePicker.pickFiles(
                        type: FileType.image,
                      );
                      // print("Here 1");
                      if (MzansiInnovationHub.of(context)!
                              .theme
                              .getPlatform() ==
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
                          widget.fileNameController!.text = selectedFile.name;
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
                            widget.fileNameController!.text =
                                file.path.split('/').last;
                          });
                        } else {
                          print("here in else");
                          // User canceled the picker
                        }
                      }
                    } catch (e) {
                      print("Here Error: $e");
                    }
                  },
                  icon: Icon(
                    Icons.camera_alt,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
