import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';

class MihImageDisplay extends StatefulWidget {
  final ImageProvider<Object>? imageFile;
  final double width;
  final double height;
  final bool expandable;
  final bool editable;
  final TextEditingController? fileNameController;
  final ValueChanged<PlatformFile>? onChange;
  final PlatformFile? userSelectedfile;
  const MihImageDisplay({
    super.key,
    required this.imageFile,
    required this.width,
    required this.height,
    required this.expandable,
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
    if (widget.imageFile == null) {
      return null;
    } else {
      return widget.imageFile;
    }
  }

  void expandImage() {
    if (imagePreview == null) return;
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
      },
    );
  }

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
      );
      PlatformFile? selectedFile;
      ImageProvider<Object>? newPreview;
      Uint8List selectedFileBytes;
      if (result != null) {
        if (kIsWeb || kIsWasm) {
          selectedFile = result.files.first;
          selectedFileBytes = await selectedFile.readAsBytes();
          newPreview = MemoryImage(selectedFileBytes);
        } else {
          File file = File(result.files.single.path!);
          selectedFileBytes = await file.readAsBytes();
          selectedFile = PlatformFile(
            path: file.path,
            name: file.path.split('/').last,
            size: file.lengthSync(),
            bytes: selectedFileBytes, // Read file bytes
          );
          newPreview = FileImage(file);
        }
        setState(() {
          imagePreview = newPreview;
          widget.fileNameController!.text = selectedFile!.name;
        });
        widget.onChange?.call(selectedFile);
      } else {
        KenLogger.error("User didnt pick avatar");
      }
    } catch (e) {
      KenLogger.error("Mih Avatar: $e");
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
  void didUpdateWidget(covariant MihImageDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageFile != oldWidget.imageFile) {
      setState(() {
        imagePreview = widget.imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.expandable
          ? () {
              KenLogger.success("Avatar tapped");
              expandImage();
            }
          : null,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (imagePreview != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(widget.width * 0.1),
                child: Container(
                  // width: widget.width,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: MihColors.secondary(),
                    borderRadius: BorderRadius.circular(widget.width * 0.1),
                  ),
                  child: Image(image: imagePreview!),
                ),
              ),
            ] else ...[
              Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: MihColors.secondary(),
                  borderRadius: BorderRadius.circular(widget.width * 0.1),
                ),
                child: Icon(
                  Icons.image_not_supported_rounded,
                  size: widget.width * 0.3,
                  color: MihColors.primary(),
                ),
              ),
            ],
            if (widget.editable)
              Positioned(
                bottom: 5,
                right: 5,
                child: IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: MihColors.green(),
                  ),
                  color: MihColors.primary(),
                  onPressed: _pickImage,
                  icon: const Icon(
                    Icons.edit,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
