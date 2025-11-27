import 'package:flutter/material.dart';
import 'package:mzansi_innovation_hub/main.dart';
import 'package:mzansi_innovation_hub/mih_objects/app_user.dart';
import 'package:mzansi_innovation_hub/mih_package_components/mih_circle_avatar.dart';
import 'package:mzansi_innovation_hub/mih_config/mih_colors.dart';

class MihPersonalProfilePreview extends StatefulWidget {
  final AppUser user;
  final ImageProvider<Object>? imageFile;
  const MihPersonalProfilePreview({
    super.key,
    required this.user,
    required this.imageFile,
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
        MihCircleAvatar(
          imageFile: widget.imageFile,
          width: profilePictureWidth,
          editable: false,
          fileNameController: TextEditingController(),
          userSelectedfile: null,
          frameColor: MihColors.getSecondaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          backgroundColor: MihColors.getPrimaryColor(
              MzansiInnovationHub.of(context)!.theme.mode == "Dark"),
          onChange: () {},
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
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              widget.user.fname.isNotEmpty
                  ? "${widget.user.fname} ${widget.user.lname}"
                  : "Name Surname",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Text(
              widget.user.type.toUpperCase(),
              style: TextStyle(
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
