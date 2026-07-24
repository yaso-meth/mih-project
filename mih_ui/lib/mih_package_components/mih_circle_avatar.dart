import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';

class MihCircleAvatar extends StatefulWidget {
  final ImageProvider<Object>? imageFile;
  final double width;
  final bool expandable;
  final bool editable;
  final TextEditingController? fileNameController;
  final ValueChanged<PlatformFile>? onChange;
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
    final PlatformFile? file = await MihFileApi.pickImage();
    if (file != null) {
      String fileName = file.name;
      Uint8List fileBytes = await file.readAsBytes();
      setState(() {
        imagePreview = MemoryImage(fileBytes);
        widget.fileNameController!.text = fileName;
      });
      widget.onChange?.call(file);
    }
  }

  @override
  void initState() {
    super.initState();
    imagePreview = getAvatar();
  }

  @override
  void didUpdateWidget(covariant MihCircleAvatar oldWidget) {
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
              expandAvatar();
            }
          : null,
      child: SizedBox(
        width: widget.width,
        height: widget.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (imagePreview != null) ...[
              Positioned(
                right: widget.width * 0.03,
                child: CircleAvatar(
                  radius: widget.width / 2.2,
                  backgroundColor: widget.backgroundColor,
                  backgroundImage: imagePreview,
                ),
              ),
              Icon(
                size: widget.width,
                MihIcons.mihRing,
                color: widget.frameColor,
              ),
            ] else ...[
              Positioned(
                right: widget.width * 0.03,
                child: CircleAvatar(
                  radius: widget.width / 2.2,
                  backgroundColor: widget.backgroundColor,
                  backgroundImage: imagePreview,
                ),
              ),
              Icon(
                MihIcons.mihIDontKnow,
                size: widget.width,
                color: widget.frameColor,
              ),
            ],
            if (widget.editable)
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      MihColors.green(),
                    ),
                  ),
                  onPressed: _pickImage,
                  icon: Icon(
                    Icons.camera_alt,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
