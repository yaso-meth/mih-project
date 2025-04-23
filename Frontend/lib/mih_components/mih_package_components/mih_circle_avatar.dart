import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_components/mih_package_components/mih_icons.dart';

class MihCircleAvatar extends StatefulWidget {
  final ImageProvider<Object>? imageFile;
  final double width;
  final bool editable;
  final TextEditingController fileNameController;
  final onChange;
  const MihCircleAvatar({
    super.key,
    required this.imageFile,
    required this.width,
    required this.editable,
    required this.fileNameController,
    required this.onChange,
  });

  @override
  State<MihCircleAvatar> createState() => _MihCircleAvatarState();
}

class _MihCircleAvatarState extends State<MihCircleAvatar> {
  late ImageProvider<Object>? imagePreview;

  @override
  void initState() {
    super.initState();
    setState(() {
      imagePreview = widget.imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.width,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              radius: widget.width / 2,
              backgroundColor:
                  MzanziInnovationHub.of(context)!.theme.primaryColor(),
              backgroundImage: imagePreview,
            ),
          ),
          Icon(
            size: widget.width,
            MihIcons.mihCircleFrame,
            color: MzanziInnovationHub.of(context)!.theme.secondaryColor(),
          ),
          Visibility(
            visible: widget.editable,
            child: Positioned(
              bottom: 0,
              right: 0,
              child: IconButton.filled(
                onPressed: () async {
                  try {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.image,
                    );
                    // print("Here 1");
                    if (MzanziInnovationHub.of(context)!.theme.getPlatform() ==
                        "Web") {
                      // print("Here 2");
                      if (result == null) return;
                      // print("Here 3");
                      PlatformFile? selectedFile = result.files.first;
                      setState(() {
                        // print("Here 4");
                        widget.onChange(MemoryImage(selectedFile.bytes!));
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
                          widget.onChange(MemoryImage(androidFile.bytes!));
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
                icon: const Icon(Icons.edit),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
