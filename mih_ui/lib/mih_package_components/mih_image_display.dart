import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ken_logger/ken_logger.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_services/mih_file_services.dart';

class MihImageDisplay extends StatefulWidget {
  final ImageProvider<Object>? imageFile;
  final double height;
  final double? width;
  final BoxFit fit;
  final bool expandable;
  final bool editable;
  final bool blur;
  final BorderRadius? borderRadius;
  final TextEditingController? fileNameController;
  final ValueChanged<PlatformFile>? onChange;
  final PlatformFile? userSelectedfile;
  const MihImageDisplay({
    super.key,
    required this.imageFile,
    required this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.expandable = false,
    this.editable = false,
    this.blur = false,
    this.borderRadius,
    this.fileNameController,
    this.userSelectedfile,
    this.onChange,
  });

  @override
  State<MihImageDisplay> createState() => _MihImageDisplayState();
}

class _MihImageDisplayState extends State<MihImageDisplay> {
  late ImageProvider<Object>? imagePreview;

  @override
  void initState() {
    super.initState();
    imagePreview = widget.imageFile;
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

  void expandImage() {
    if (imagePreview == null) return;
    Widget modalImage = Image(
      image: imagePreview!,
      width: double.infinity,
      fit: BoxFit.fitWidth,
    );
    if (widget.blur) {
      modalImage = ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: 35.0,
          sigmaY: 35.0,
        ),
        child: modalImage,
      );
    }
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
              child: Center(
                child: modalImage,
              ),
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
  Widget build(BuildContext context) {
    final BorderRadius effectiveRadius =
        widget.borderRadius ?? BorderRadius.circular(widget.height * 0.1);
    Widget content;
    if (imagePreview != null) {
      Widget imageWidget = Image(
        image: imagePreview!,
        height: widget.height,
        width: widget.width,
        fit: widget.fit,
      );
      if (widget.blur) {
        imageWidget = ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: 15.0,
            sigmaY: 15.0,
          ),
          child: imageWidget,
        );
      }
      content = ClipRRect(
        borderRadius: effectiveRadius,
        child: Container(
          color: MihColors.secondary(),
          child: imageWidget,
        ),
      );
    } else {
      content = Container(
        width: widget.width ?? widget.height,
        height: widget.height,
        decoration: BoxDecoration(
          color: MihColors.secondary(),
          borderRadius: effectiveRadius,
        ),
        child: Icon(
          Icons.image_not_supported_rounded,
          size: widget.height * 0.3,
          color: MihColors.primary(),
        ),
      );
    }
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
            content,
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
