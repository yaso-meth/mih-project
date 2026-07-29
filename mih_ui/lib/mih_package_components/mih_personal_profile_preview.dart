import 'package:flutter/material.dart';
import 'package:mih_package_toolkit/mih_package_toolkit.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';

class MihPersonalProfilePreview extends StatefulWidget {
  final AppUser user;
  final ImageProvider<Object>? imageFile;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool loading;
  const MihPersonalProfilePreview({
    super.key,
    required this.user,
    required this.imageFile,
    required this.loading,
    this.foregroundColor,
    this.backgroundColor,
  });

  @override
  State<MihPersonalProfilePreview> createState() =>
      _MihPersonalProfilePreviewState();
}

class _MihPersonalProfilePreviewState extends State<MihPersonalProfilePreview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double profilePictureWidth = 60;
    return Row(
      children: [
        widget.loading
            ? Icon(
                MihIcons.mihRing,
                size: profilePictureWidth,
                color: widget.foregroundColor ?? MihColors.secondary(),
              )
            : widget.user.pro_pic_path.endsWith('/') ||
                    widget.user.pro_pic_path == ""
                ? Icon(
                    MihIcons.mihIDontKnow,
                    size: profilePictureWidth,
                    color: widget.foregroundColor ?? MihColors.secondary(),
                  )
                : MihCircleAvatar(
                    imageFile: widget.imageFile,
                    width: profilePictureWidth,
                    expandable: false,
                    editable: false,
                    fileNameController: TextEditingController(),
                    userSelectedfile: null,
                    frameColor: widget.foregroundColor ?? MihColors.secondary(),
                    backgroundColor:
                        widget.backgroundColor ?? MihColors.primary(),
                    onChange: null,
                  ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user.username.isNotEmpty
                  ? widget.user.username
                  : "Username",
              style: TextStyle(
                color: widget.foregroundColor ?? MihColors.secondary(),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.user.fname.isNotEmpty
                  ? "${widget.user.fname} ${widget.user.lname}"
                  : "Name Surname",
              style: TextStyle(
                color: widget.foregroundColor ?? MihColors.secondary(),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              widget.user.type.toUpperCase(),
              style: TextStyle(
                color: widget.foregroundColor ?? MihColors.secondary(),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        )
      ],
    );
  }
}
